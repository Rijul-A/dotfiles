#!/usr/bin/python3

import logging
import os
import shlex
import subprocess
import sys

from gotify import Gotify


def logger():
    if not hasattr( logger, 'logger' ):
        logger.logger = logging.getLogger( __name__ )
        handler = logging.StreamHandler()
        handler.setFormatter(
            logging.Formatter( '[%(levelname)s] %(message)s' )
        )
        logger.logger.addHandler( handler )
        logger.logger.setLevel( logging.INFO )
    return logger.logger


def log( *values, sep = ' ' ):
    logger().info( sep.join( values ) )


def notify( gotify, message, title, priority ):
    gotify.create_message(
        message = message,
        title = title,
        priority = priority
    )


def parse_env_vars():
    vars = [
        ( 'GOTIFY_URL',
          True,
          None ),
        ( 'GOTIFY_APP_TOKEN',
          True,
          None ),
        ( 'RESTIC_REPOSITORY_SUBPATH',
          True,
          None ),
        ( 'RESTIC_BACKUP_SOURCE',
          True,
          None ),
        ( 'RESTIC_KEEP_N',
          True,
          lambda x: int( x ) ),
    ]
    result = []
    for var in vars:
        name, required, transform = var
        val = os.environ.get( name )
        if not val and required:
            log( 'Environment variable {} missing'.format( name ) )
            sys.exit( 1 )
        transform = transform or ( lambda x: x )
        try:
            result.append( transform( val ) )
        except Exception as e:
            log( 'Error in environment variable {}'.format( name ) )
            log( repr( e ) )
            sys.exit( 1 )
    return result


def run_generic( command, operation, gotify, message ):
    log( "Running", command )
    result = subprocess.run(
        shlex.split( command ),
        stdout = subprocess.PIPE,
        stderr = subprocess.PIPE
    )
    stderr = result.stderr.decode( 'utf-8' )
    stdout = result.stdout.decode( 'utf-8' )
    if result.returncode != 0:
        title = "failure"
        priority = 8
    else:
        title = "success"
        priority = 3
    notify(
        gotify,
        message,
        'Restic {} {}'.format( operation,
                               title ),
        priority
    )
    log( title )
    log( stdout )
    log( stderr )
    return result.returncode == 0


def backup( gotify, restic_repository_subpath, restic_backup_source ):
    backup_command = \
        '/usr/bin/restic ' \
        '--password-file ./pw.txt ' \
        '--exclude-file ./excludes.txt ' \
        '-o rclone.args=' \
        '"serve restic --stdio --bwlimit 8.5M --b2-hard-delete" ' \
        '-o rclone.program="/usr/bin/rclone" ' \
        '-r rclone:crypt:backups/{} ' \
        '--exclude-if-present .nobackup ' \
        'backup {}'.format(
            restic_repository_subpath,
            restic_backup_source
        )
    return run_generic(
        backup_command,
        'backup',
        gotify,
        restic_backup_source,
    )


def prune(
    gotify,
    restic_repository_subpath,
    restic_backup_source,
    restic_keep_n
):
    prune_command = \
        '/usr/bin/restic ' \
        '--password-file ./pw.txt ' \
        '-o rclone.args=' \
        '"serve restic --stdio --bwlimit 8.5M --b2-hard-delete --fast-list" ' \
        '-o rclone.program="/usr/bin/rclone" ' \
        '-r rclone:crypt:backups/{} ' \
        'forget --keep-last {} --prune'.format(
            restic_repository_subpath,
            restic_keep_n
        )
    return run_generic( prune_command, 'pruning', gotify, restic_backup_source )


def main():
    gotify_url, \
    gotify_app_token, \
    restic_repository_subpath, \
    restic_backup_source, \
    restic_keep_n = \
        parse_env_vars()
    gotify = Gotify( gotify_url, gotify_app_token )
    success = backup( gotify, restic_repository_subpath, restic_backup_source )
    if success:
        success = success and prune(
            gotify,
            restic_repository_subpath,
            restic_backup_source,
            restic_keep_n
        )
        if not success:
            notify( gotify, restic_backup_source, 'Restic pruning failed', 3 )
    else:
        notify( gotify, restic_backup_source, 'Restic pruning skipped', 1 )
    sys.exit( 0 if success else 1 )


if __name__ == "__main__":
    main()
