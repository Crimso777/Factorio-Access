import json
import subprocess
import re
import http, http.client, http.cookiejar
import urllib
import urllib.request
import os
import getpass
import zipfile
import webbrowser
import fa_paths
import time

from shutil import rmtree
from sys import platform

download_package_map = {
    "win32":"win64-manual",
    "Darwin":"osx",
    "linux":"linux64"
    }
download_package = download_package_map[platform]

if not download_package:
    raise ValueError("Unsupported Platform:"+platform)
    
package_map = {
    ('win64','full'):"core-win64",
    ('linux64','full'):"core-linux64",
    ('mac','full'):"core-mac",
    }

FACTORIO_INSTALL_PATH = "./"

PLAYER_DATA_PATH = os.path.join(fa_paths.WRITE_DIR, "player-data.json")
TEMP_PATH = os.path.join(fa_paths.WRITE_DIR,  'temp')



class NoRedirection_for_get_token_e(urllib.request.HTTPErrorProcessor):
    def https_response(self, request, response):
        if response.code == 302 and request.full_url == "https://www.factorio.com/get-token":
            return response
        return super().https_response(request,response)

class NoRedirectHandler(urllib.request.HTTPRedirectHandler):
    def http_error_302(self, req, fp, code, msg, headers):
        if req.full_url == "https://www.factorio.com/get-token":
            infourl = urllib.response.addinfourl(fp, headers, req.get_full_url())
            infourl.status = code
            return infourl
        return super().http_error_302(req, fp, code, msg, headers)



opener = urllib.request.build_opener(
    NoRedirection_for_get_token_e(),
    urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()),
    urllib.request.HTTPSHandler(debuglevel=0) #change to 1 for testing 0 for production
    )
#cloudfare rejects the default user agent
opener.addheaders = [('User-agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36')]





def prompt_login():
    username=""
    while len(username) == 0 :
        username=input("Factorio Username:")
    password=""
    while len(password) == 0 :
        password=getpass.getpass("Factorio Password: ")
    return {
        "username":username,
        "password":password
    }

def service_token_promt():
    username=""
    while len(username) == 0 :
        username=input("Factorio Username:")
    token=''
    while True:
        print("To get your service token, which is required for updates, and most multiplayer functions, please follow the instructions below:")
        print("1. Go to https://factorio.com/profile in your browser. An option to launch is at the end of the instructions.")
        print('2. Once logged in and on your profile page, Click the link with the text "reveal".')
        print("3. Once clicked, your token string will be just before the link that will have disapeared. The token consists of a string of 30 numbers and letters between a and f. The text after the token starts with an i.")
        token=input("4. Enter your token here, or l to to to open the page for you, or n to skip for now.")
        token=token.strip()
        if re.fullmatch(r'[nN][oO]?',token):
            token=''
            break
        if re.fullmatch(r'[\da-f]{30}',token):
            break
        if re.fullmatch(r'[Ll](aunch)?',token):
            webbrowser.open('https://factorio.com/profile')
            continue
        print("The token entered did not match the expected format. Please try again, or enter no to skip")
    return {"username":username,"token":token}
        
    

def api_log_in():
    params=prompt_login()
    params['api_version']='4'
    params['require_game_ownership']='true'
    encoded_params= urllib.parse.urlencode(params).encode('utf-8')
    with opener.open('https://auth.factorio.com/api-login',encoded_params) as response:
       json_resp = json.load(response)
    return json_resp

def scrape_CSRF_token(page_html):
    for input_element in re.finditer(r'<\s*input([^>]*)>',page_html,re.IGNORECASE):
        input_html = input_element.group(1)
        if re.search(r'\bname\s*=[\s"]*csrf_token[\s"]', input_html, re.IGNORECASE):
            token_match = re.search(r'\bvalue\s*=\s*"([^\s"]+)"',input_html,re.IGNORECASE)
            if token_match:
                return token_match.group(1)
    return None

def scrape_username(page_html):
    token_match = re.search(r'\bhref\s*=\s*"/profile"[^>]*>\s*([^<\s]+)\s*<',page_html,re.IGNORECASE)
    if token_match:
        return token_match.group(1)
    return None


def site_log_in():
    with opener.open("https://www.factorio.com/login") as response:
        page_html=response.read().decode()
    username = scrape_username(page_html)
    if username:
        return username
    token = scrape_CSRF_token(page_html)
    if not token:
        print("login CSRF token not found")
        return False
    cred = prompt_login()
    params={
        'csrf_token':token,
        'next_url':'',
        'next_mods':'False',
        'username_or_email':cred['username'],
        'password':cred['password']
        }
    encoded_params= urllib.parse.urlencode(params).encode('utf-8')
    req = urllib.request.Request("https://www.factorio.com/login",
            encoded_params,
            {'referer':'https://www.factorio.com/login'}
        )
    with opener.open(req) as response:
        html = response.read().decode()
    username=scrape_username(html)
    if not username:
        print(html)
    return username
    
def get_service_token_through_site():
    req = urllib.request.Request("https://www.factorio.com/get-token"
            ,b""
            ,{'accept':'application/json, text/javascript, */*; q=0.01'}
        )
    with opener.open(req) as response:
        print(response)
        data = response.read()
        print(data)
        json_token = json.load(data.decode())
    return json_token.token

def get_latest_stable():
    with opener.open("https://factorio.com/api/latest-releases") as response:
        json_page = json.load(response)
    return json_page['stable']['alpha']

def download(url,filename):
    with open(filename,'wb') as fp, opener.open(url) as dl:
        print(f"saving {url} to {filename}")
        length = dl.getheader('content-length')
        buffsize = 4096

        if length:
            length = int(length)
            if length > 4096*20:
                print(f'Downloading {length} bytes')
          
        bytes_done = 0
        last_percent = -1
        last_reported=time.time()
        while True:
            buffer = dl.read(buffsize)
            if not buffer:
                break
            fp.write(buffer)
            bytes_done += len(buffer)
            if length:
                percent = bytes_done*100//length
                if percent>last_percent and time.time()>= 5 + last_reported:
                    print(f"{percent}%")
                    last_percent=percent
                    last_reported= time.time()
        if length and length > 4096*20:
            print("Done")

def delete_dir_if_exists(dirname):
    if os.path.exists(dirname):
        print("deleteing "+dirname)
        rmtree(dirname)

def overwrite_factorio_intall_from_new_zip(filename):
    delete_dir_if_exists(FACTORIO_INSTALL_PATH+'bin')
    delete_dir_if_exists(FACTORIO_INSTALL_PATH+'data')
    delete_dir_if_exists(FACTORIO_INSTALL_PATH+'doc-html')
    print("extracting new installation")
    with zipfile.ZipFile(filename) as zp:
        my_path = zipfile.Path(zp)
        nested_dir = next(my_path.iterdir())
        print(nested_dir.name)
        #zp.extractall(FACTORIO_INSTALL_PATH)
    print("done extracting. Deleting download.")
    

#function totally a work in progress don't attempt to use    
def install():
    username=site_log_in()
    if not username:
        print("Login Failed")
        return False
    #token=get_service_token_through_site()
    version = input('Enter version to download. Leave blank for latest stable:')
    if not version:
        version= get_latest_stable()
    os.makedirs(TEMP_PATH, exist_ok=True)
    filename=TEMP_PATH+'factorio-'+version+'-'+download_package
    print("Downloading version "+version)
    download(f"https://www.factorio.com/get-download/{version}/alpha/{download_package}",filename)
    overwrite_factorio_intall_from_new_zip(filename)

def set_player_data(player):
    with open(PLAYER_DATA_PATH,'w') as player_file:
        json.dump(player,player_file)

def get_player_data():
    with open(PLAYER_DATA_PATH) as player_file:
        return json.load(player_file)

def get_credentials(quiet=False):
    if not os.path.exists(PLAYER_DATA_PATH):
        if not quiet:
            print("Player data does not exist yet. Please start the game in single player first.")
        return None
    player = get_player_data()
    if not player["service-username"] or not player["service-token"]:
        log_res = service_token_promt()#api_log_in()
        if not log_res:
            print("Not logged in")
            return None
        player["service-username"] = log_res['username']
        player["service-token"] = log_res['token']
        set_player_data(player)
    return {
        "username":player["service-username"],
        "token":player["service-token"]
        }
    
    
def get_current_version():
    version_str = subprocess.check_output(fa_paths.BIN + " --version").decode('utf-8')
    version_re = r"Version:\s*([\d\.]+)\s*\(\s*([^,]+),\s*([^,]+),\s*([^)]+)\)"
    maybe_match = re.match(version_re , version_str)
    if not maybe_match:
        print("could not match version string", version_str)
        return None
    groups= maybe_match.groups()
    check_type = (groups[2],groups[3])
    if not check_type in package_map:
        print("could not identify package type from:", (groups[2],groups[3]))
        return None    
    return {"from":groups[0],"package":package_map[check_type]}


def check_for_updates(credentials,connection,current_version):
    print("cheing for factotio updates...")
    params=credentials.copy()
    params["apiVersion"]=2
    connection.request("GET",'/get-available-versions?'+urllib.parse.urlencode(credentials))
    resp = connection.getresponse()
    if resp.status != 200:
        print("error: "+ resp.status + " " + resp.reason)
        return None
    availble = json.load(resp)
    if not availble:
        print("couldn't get any updates")
        return None
    if current_version['package'] not in availble:
        print("no available verions match package. Versions are:")
        for ver in availble.keys():
            print('\t',ver)
        return None
    versions = availble[current_version['package']]
    upgrade_list=[]
    version = current_version['from']
    for upgrade in versions:
        if 'stable' in upgrade:
            stable = upgrade['stable']
    found = True
    while found and version!=stable:
        found=False
        for upgrade in versions:
            if 'from' in upgrade and upgrade['from']==version:
                upgrade_list.append(upgrade)
                version = upgrade['to']
                found=True
                break
    return upgrade_list

def update_filename(current_version,update):
    return os.path.join(TEMP_PATH,current_version['package']+'-'+update['from']+'-'+update['to']+'-update.zip')

def prep_update(credentials, current_version, update_canidates):
    os.makedirs(TEMP_PATH, exist_ok=True)
    params=credentials.copy()
    params['package']=current_version['package']
    params['apiVersion']=2
    params['isTarget']='false'
    for i, update in enumerate(update_canidates):
        if i+1 == len(update_canidates):
            params['isTarget']='true'
        this_params = params | update
        print('Downloading '+update['to'])
        download(f"https://updater.factorio.com/updater/get-download?"+urllib.parse.urlencode(this_params),update_filename(params,update))
    print('Finished Downloads')
    return
    
def execute_update(current_version, update_canidates):
    print(current_version,update_canidates)
    params=[fa_paths.BIN]
    for update in update_canidates:
        file = os.path.abspath(update_filename(current_version,update))
        params.append('--apply-update')
        params.append(file)
    print(params)
    print(subprocess.check_output(params).decode('utf-8'))
    #todo subprocess spawns another process and exits, casueing the cleanup to proceed before the update completes.

def cleanup_update(current_version, update_canidates):
    for update in update_canidates:
        file = os.path.abspath(update_filename(current_version,update))
        os.remove(file)

def do_update(confirm=True):
    credentials = get_credentials()
    if not credentials:
        return False
    current_version = get_current_version()
    if not current_version:
        return False
    connection = http.client.HTTPSConnection("updater.factorio.com")
    update_canidates = check_for_updates(credentials,connection,current_version)
    connection.close()
    if not update_canidates:
        print('no updates available')
        return False
    if confirm:
        input("update to "+update_canidates[-1]['to']+'? Enter to continue.')
    else:
        print("updating to "+update_canidates[-1]['to'])
    prep_update(credentials, current_version, update_canidates)
    execute_update(current_version, update_canidates)
    cleanup_update(current_version, update_canidates)
    print("all-done")
    
    
    
if "__main__" == __name__:
    do_update()