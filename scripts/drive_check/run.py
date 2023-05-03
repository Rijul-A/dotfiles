#!/usr/bin/python3

import logging
import os
import sys
from threading import Event

exit = Event()


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
    logger().info( sep.join( [ str( v ) for v in values ] ) )


def listdir( path ):
    try:
        _ = os.listdir( path )
    except os.error:
        return False
    return True


def check( path, inverse ):
    # first is `ismount` which is cheaper to execute
    # so only if it fails is when you go to listdir
    result = os.path.ismount( path ) and listdir( path )
    return inverse != result


def parse_env_vars():
    result = []
    variables = [
        ( 'MOUNT_PATH',
          True,
          None,
         ),
        ( 'SECONDS_BETWEEN_CHECKS',
          True,
          None,
         ),
        ( 'LOG_EVERY_X_INTERVALS',
          True,
          lambda x: int( x ),
         ),
        (
            'INVERSE',
            False,
            lambda x: ( x is not None and x.lower() == 'true' ),
        )
    ]
    for var in variables:
        name, required, transform = var
        val = os.environ.get( name )
        if required and not val:
            log( 'Environment variable {} missing'.format( name ) )
            sys.exit( 2 )
        transform = transform or ( lambda x: x )
        result.append( transform( val ) )
    return result


def main():
    path, seconds, log_intervals, inverse = parse_env_vars()
    true_value = "unavailable" if inverse else "available"
    log( "Checking {} every {} seconds".format( path, seconds ) )
    count = -1
    while not exit.is_set():
        if not check( path, inverse ):
            log( "Drive {} {}".format( path, true_value ) )
            sys.exit( 1 )
        count = count + 1
        if count % log_intervals == 0:
            log( "Drive {} {}".format( path, true_value ) )
        exit.wait( int( seconds ) )
    sys.exit( 0 )


def quit( signo, _frame ):
    log( "Interrupted by %d, shutting down" % signo )
    exit.set()


if __name__ == '__main__':
    import signal
    for sig in ( 'TERM', 'HUP', 'INT' ):
        signal.signal( getattr( signal, 'SIG' + sig ), quit )
    main()
