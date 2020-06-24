/
 data structures used:- lists/vectors (and nested lists), tables
 concepts used:- file i/o and file handles, ipc: sync and async message passing, socket handles
 internal callbacks (.z.pc and .z.ts in particular), .Q.dpft function
 date-partitioned historical databases and their structure, advantages, etc.
 and in general sub/pub architectures
\

\l utils.q                                                       / load utils file

check_params[`tp`hdb;"q rt.q -tp localhost:5000 -hdb /tmp/taq/"];

t:{update "p"$1970.01.01D+tms from select by sym from trade};
q:{update "p"$1970.01.01D+tms from select by sym from quote};
summary2:{`n`open`mn`av`md`mx`dv`close!(count;first;min;avg;med;max;sdev;last)@\:x};

dow30:("ISSSSDSSS";enlist",") 0:`:/home/gfeng/git/data/dow30.csv;
sector:("ISS";enlist",") 0:`:/home/gfeng/git/data/sector.csv;

get_summaryX:{[]
 s:update src:{"http://ny529s.com/logo/",x,".png"} each src from update src:string sym from select id:count i, volume:sum size by sym from trade;

 p:select price by sym from select last price by sym, qtm.minute from trade where qtm.minute>=09:30;

 pohlc:raze {
  t:select from trade where sym=x, qtm.minute>=09:30;
  o:1#t;
  l:1#select from t where price=min price;
  h:1#select from t where price=max price;
  c:-1#t;
  m:select ps:price, tick:last price by sym from `qtm xasc (o,l,h,c);
  m
  } each exec distinct sym from (select by sym from trade);

 `id`src`sym`price`volume`ps`tick xcols 0!(s lj p lj pohlc)
 };


get_summary2:{[]
 / r:select from trade where qtm.time>=?[.z.T>=13:30;13:30;12:01];
 s:update l2dv:vwap-2*dv, r2dv:vwap+2*dv, qtm:string qtm, atr:mx-mn  from select last qtm, id:count i, n:count i, open:first price, mn:min price, mu:avg price, md:med price, mx:max price, dv:sdev price, vwap:size wavg price, close:last price, chg:last deltas price, volume:sum size by sym from trade where qtm.time>=?[.z.T>=13:30;13:30;12:01];
 p:select price by sym from select last price by sym, qtm.minute from trade where qtm.time>=?[.z.T>=13:30;13:30;12:01];
 pohlc:raze {
  t:select from trade where sym=x, qtm.time>=?[.z.T>=13:30;13:30;12:01];
  o:1#t;
  l:1#select from t where price=min price;
  h:1#select from t where price=max price;
  c:-1#t;
  m:select ps:price, tick:last price by sym from `qtm xasc (o,l,h,c);
  m
  } each exec distinct sym from (select by sym from trade);

 img:update src:{"http://ny529s.com/logo/",x,".png"} each src from update src:string sym from select n:count i by sym from trade;
 :0!(s lj p lj pohlc lj img)
 };



TP:frmt_handle get_param`tp;                                     / tickerplant handle
HDB:frmt_handle get_param`hdb;                                   / database partition to save data to
SPLAY_TABLES:`iextops`iexquote2;

/
 define the replay function
 l - log to replay
 seq - up to which sequence number to replay
\
replay:{[l;seq]
 / -11!(seq;l);                                                   / replay number seq chunks of data
 value each seq#(get l)
 };

/
 sub to tp handle
 tp - tp handle name, e.g. `:localhost:5000
\ 
sub_tp:{[tp]
  TPH:hopen tp;                                                 / open connection
  TPH"tp_sub[]";                                                / subscribe to tickerplant; tp will trigger set schemas and trigger replay
 };

/
 callbacks from tp all arrive on upd
 we could provide callback, but won't do it for simplicity reasons
 so let's set upd to insert
 t - table to insert to (table is a symbol, `trade or `quote)
 d - data to insert (list of vectors)
\
upd:{[t;d]
 t insert d;                                                / insert data into target table; simple huh!
 };

/
 save function
 we always partition on sym
 dp - database path
 d - date partition to save to
 t - table to save (symbol, e.g. `trade)
\
save_t:{[dp;d;t]
  .log.info"Save table ",(string t),". Number of records in table: ", string count get t;
  .Q.dpft[dp;d;`sym;t];                                                         / sort table by sym
   empty t;                                                                     / delete from table, but keep `g#
  .log.info"Finished saving table ", string t;
 };

save_t2:{[dp;d;t]
  .log.info"Save table ",(string t),". Number of records in table: ", string count get t;
  .Q.dpft[dp;d;`sym;update sym:symbol from t];                                  / sort table by sym
   empty t;                                                                     / delete from table, but keep `g#
  .log.info"Finished saving table ", string t;
 };


/
 eod function
 d - date to save to
\
eod:{[d]
  .log.info"Start saving tables."; 
  / if[count tables[]; save_t[HDB;d;] each tables[]];                             / save any table in root to disk
  save_t[HDB;d;] each `trade`iextops`iexquote;

  / save_t2[HDB;d;] each `iextops`iexquote;
  .log.info"Finnished saving tables.";
  / empty each tables[];
  / exit 0;                                                                       / exit safely
 };

// setup process
init:{[]
  .log.info"Subscribe to tickerplant";
   sub_tp[TP];                                                                  / subscribe to tp
 };

init[];
