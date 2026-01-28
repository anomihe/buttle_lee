#!/bin/sh
set -e

echo "Applying migrations..."
./server --apply-migrations --mode=$runmode --server-id=$serverid --logging=$logging --role=$role

echo "Starting server..."
./server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role
