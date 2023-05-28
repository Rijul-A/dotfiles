#!/usr/bin/python3
import json
import subprocess
import psutil
import time
import notify2
import os
import requests

from tendo import singleton

# Wait up to 5 minutes + 12 seconds at maximum
timeout = 5 * 60 + 12

def notify( title, message, timeout = 2000 ):
    if not hasattr( notify, "can_notify" ):
        notify.can_notify = False
    print( title, ":", message )
    if not notify.can_notify:
        try:
            notify2.init( "Kodi start script" )
            notify.can_notify = True
        except:
            return
    notice = notify2.Notification( title, message )
    notice.set_timeout( timeout )
    notice.set_urgency( notify2.URGENCY_LOW )
    notice.show()

def processRunning( name ):
    return name in ( p.name() for p in psutil.process_iter() )

def isKodiRunning():
    data = {'jsonrpc': '2.0', 'id': 1, 'method': 'JSONRPC.Ping'}
    try:
        status_code = requests.post( 'http://localhost:8080/jsonrpc', data = json.dumps( data ) ).status_code
        return status_code == 200
    except:
        return False

def main():
    # Ensure only one instance can run
    _ = singleton.SingleInstance()
    # Exit if SSH testing
    if os.getenv( "XDG_SESSION_TYPE" ) == "tty":
        notify( "Error", "Cannot launch kodi over SSH" )
        return
    # Ping Kodi, and request Home if ponged
    if isKodiRunning():
        notify( "Kodi running", "Going to home" )
        data = {'jsonrpc': '2.0', 'id': 1, 'method': 'Input.Home'}
        status_code = requests.post( 'http://localhost:8080/jsonrpc', data = json.dumps( data ) ).status_code
        return status_code == 200
    status_code = 404
    start_time = time.time()
    flag = False
    while status_code != 200 and time.time() - start_time <= timeout:
        try:
            # Ping Kodi
            status_code = requests.post( "http://localhost:8096/System/Ping" ).status_code
        except:
            # Notify if first ping failed so that its visible on screen
            if not flag:
                notify( "Jellyfin Kodi helper", "Checking for Jellyfin before starting Kodi", 5000 )
                flag = True
            time.sleep( 1 )
    if status_code == 200:
        notify( "Success", "Jellyfin ready, starting Kodi" )
        with open( "/dev/null", "w" ) as devnull:
            # needed so that this script can terminate once kodi is up
            subprocess.Popen( [ "kodi" ], stdin = None, stdout = devnull, stderr = devnull )
            # wait for Kodi to be up
            while not isKodiRunning():
                time.sleep( 1 )
    else:
        notify( "Error", "Jellyfin not active; cannot start Kodi" )

if __name__ == "__main__":
    main()