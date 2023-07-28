#!/usr/bin/python3
import json
import logging
import os
import psutil
import requests
import subprocess
import time

from dotenv import load_dotenv
import notify2
from tendo import singleton

# Wait up to 5 minutes + 12 seconds at maximum
timeout = 5 * 60 + 12


def notify( title, message, timeout = 2000 ):
    # Call the init function only once
    if not hasattr( notify, "can_notify" ):
        notify.can_notify = False
    print( title, ":", message )
    if not notify.can_notify:
        try:
            notify2.init( "Kodi start script" )
            notify.can_notify = True
        except:
            return
    # Run the notification
    notice = notify2.Notification( title, message )
    notice.set_timeout( timeout )
    notice.set_urgency( notify2.URGENCY_LOW )
    notice.show()
    logging.info( "{} {}".format( title, message ) )


def processRunning( name ):
    return name in ( p.name() for p in psutil.process_iter() )


def isKodiRunning():
    data = {
        'jsonrpc': '2.0',
        'id': 1,
        'method': 'JSONRPC.Ping'
    }
    try:
        status_code = requests.post(
            'http://localhost:8080/jsonrpc',
            data = json.dumps( data )
        ).status_code
        return status_code == 200
    except:
        return False


def main():
    logging.basicConfig( filename = "log.txt", level = logging.DEBUG )
    # Ensure only one instance can run
    _ = singleton.SingleInstance()
    # Exit if SSH testing
    if os.getenv( "XDG_SESSION_TYPE" ) == "tty":
        logging.error( "Cannot launch kodi over SSH" )
        notify( "Error", "Cannot launch kodi over SSH" )
        return
    # This is provided via the command line and not in .env
    # So that the TV is not turned on at each reboot
    if os.getenv( "IS_REMOTE" ):
        logging.debug( "Remote mode" )
        # All of the above variables are sent via .env
        load_dotenv()
        ip = os.getenv( "TV_IP_ADDRESS" )
        pw = os.getenv( "TV_PASSWORD" )
        mac = os.getenv( "TV_MAC_ADDRESS" )
        hdmi = os.getenv( "TV_HDMI_PORT" )
        if all( [ x is not None for x in [ ip, pw, mac, hdmi ] ] ):
            logging.debug( "Have all TV related environment variables" )
            # Wake up TV, if it is asleep
            from wakeonlan import send_magic_packet
            send_magic_packet( mac )
            # inititalize TV object
            from sony_bravia_api import Bravia
            bravia = Bravia( 'TV', ip, 'http://{}/sony/'.format( ip ), pw )
            bravia.setPower( True )
            # If we are already on Kodi HDMI input, do nothing
            # To avoid the "HDMI x" box showing up for no reason
            switchToKodi = False
            response = bravia.send( 'avContent',
                                    'getPlayingContentInfo',
                                    [] ).json()
            if 'error' in response:
                switchToKodi = True
            else:
                result = response.get( 'result',
                                       [ {} ] )[ 0 ].get( 'title',
                                                          '' )
                switchToKodi = result != 'HDMI {}'.format( hdmi )
            # Switch to Kodi
            if switchToKodi:
                bravia.setExtInput( 'hdmi', hdmi )
            else:
                logging.debug( "TV is already on Kodi port" )
    else:
        logging.debug( "Not remote mode" )
    # Ping Kodi, and show Home if ponged
    if isKodiRunning():
        # View Kodi Home
        notify( "Kodi running", "Going to home" )
        data = {
            'jsonrpc': '2.0',
            'id': 1,
            'method': 'Input.Home'
        }
        status_code = requests.post(
            'http://localhost:8080/jsonrpc',
            data = json.dumps( data )
        ).status_code
        return status_code == 200
    status_code = 404
    start_time = time.time()
    flag = False
    while status_code != 200 and time.time() - start_time <= timeout:
        try:
            # Ping Jellyfin
            status_code = requests.post(
                "http://localhost:8096/System/Ping"
            ).status_code
        except:
            # Notify if first ping failed so that its visible on screen
            if not flag:
                notify(
                    "Jellyfin Kodi helper",
                    "Checking for Jellyfin before starting Kodi",
                    5000
                )
                flag = True
            time.sleep( 1 )
    if status_code == 200:
        notify( "Success", "Jellyfin ready, starting Kodi" )
        with open( "/dev/null", "w" ) as devnull:
            # needed so that this script can terminate once kodi is up
            subprocess.Popen(
                [ "kodi" ],
                stdin = None,
                stdout = devnull,
                stderr = devnull
            )
            # wait for Kodi to be up
            while not isKodiRunning():
                time.sleep( 1 )
    else:
        logging.error( "Jellyfin not active; cannot start Kodi" )
        notify( "Error", "Jellyfin not active; cannot start Kodi" )


if __name__ == "__main__":
    main()
