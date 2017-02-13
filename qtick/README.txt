TICK ARCHITECTURE OVERVIEW
==========================
architecture setup (data flow): fh -> tp -> rt -> hdb

FINAL TECHNICAL SETUP
=====================
- start tp on port 5000: 				q tp.q  -p 5000 -tp_path tplog
- start rt on port 5001: 				q rt.q  -p 5001 -tp ::5000 -hdb data
- start hdb on port 5002: 				q hdb.q -p 5002 -db data

- to start tp feedhandler processes, goto:

1. Futures/FX

2. EQ

3. QH
