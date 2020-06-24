TICK ARCHITECTURE OVERVIEW
==========================
architecture setup (data flow): fh -> tp -> rt -> hdb

FINAL TECHNICAL SETUP
=====================
- start tp on port 6000: 				q tp.q  -p 6000 -tp_path tplog
- start rt on port 6001: 				q rt.q  -p 6001 -tp ::6000 -hdb data
- start hdb on port 6002: 				q hdb.q -p 6002 -db data

- to start tp feedhandler processes, goto:

1. Futures/FX

2. EQ

3. QH
