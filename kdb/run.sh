#!/bin/sh

q tick.q sym . -p 5000 </dev/null >logs/tp.log 2>&1 &

q tick/r.q :5000 -p 5001 </dev/null >logs/rdb.log 2>&1 &
# connect to tp and hdb
q tick/r.q :5000 localhost:5002 -p 6001 </dev/null >logs/rdb2.log 2>&1 &

q sym -p 5002 </dev/null >logs/hdb.log 2>&1 &
