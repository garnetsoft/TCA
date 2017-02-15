
show "loading tca.q from rttca.q";

sysfamily:`sym xkey ("SSIISSFs";enlist",")0:`$":csv/sysfamily.csv";
contracts:`sym xkey ("SSSSSSSSSSSS";enlist",")0: `$":csv/contracts.csv";

ordTypeMap:`1`2`3`4`5`6`7`8`9`A`B`J!(`Market`Limit`StopLimit`MOC`WithOrWithout``LimitOrBetter`LimitWithOrWithOut`OnBasis`OnClose`LOC`MIT);

/
TCA functions
\
getAllTCAs:{[]
 getTCAs[exec distinct ClOrdID from select from qorders where CumQty>0]
 };

getTCAs:{
 `time xdesc raze getTCA2 each x
 };

getTCA2:{[orderId] 
 /show  orderId;
 qfills:select from qorders where  ClOrdID in orderId, LastQty>0;
 t0:first exec TransactTime from qfills;
 t1:last  exec TransactTime from qfills;
 
 qsym:first exec sym from qfills; 
 fstime:first exec time from qfills;
 fetime:last  exec time from qfills; / note end with the last Fill

 qfills:update qstime:fstime, qetime:fetime, NumFills:count qfills from qfills;
 qticks:select from tick where sym=qsym, time within ("T"$(string fstime);"T"$(string fetime));
 / show (string qsym)," qticks count: ",(string (count qticks));

 / qarrivalpx:first exec PX from qticks;
 qarrivalpx: last exec PX from (-1#select from tick where sym=qsym, time<fstime ); / use last tick before 1st fill
 qtickstats:select NumTicks:count i, VOL:sum QTY, VWAP:QTY wavg PX from qticks;
 mktTicks:last exec NumTicks from qtickstats;
 mktVOL:last exec VOL from qtickstats;
 mktVWAP:last exec VWAP from qtickstats; 
 qfills:update ArrivalPx:?[null qarrivalpx;LastPx;qarrivalpx], MktVolume:?[null mktVOL;CumQty;mktVOL], MktVWAP:?[null mktVWAP;AvgPx;mktVWAP], TickCount:?[null mktTicks;NumFills;mktTicks] from qfills;

 / show qstats;
 qstats:select by ClOrdID from qfills;
 qstats:update VWAPCost:?[Side=`1;1;-1]*10000*(AvgPx-MktVWAP)%MktVWAP, SlippageBps:?[Side=`1;1;-1]*10000*(AvgPx-ArrivalPx)%ArrivalPx, PctVolume:CumQty%(MktVolume+CumQty) from qstats;
 qstats:qstats lj `sym xkey contracts;
 outtbl:select time, sym, ClOrdID, ExecID, Side, ordTypeMap[OrdType], OrderQty, CumQty, MktVolume+CumQty, ArrivalPx, AvgPx, MktVWAP, VWAPCost, SlippageBps, PctVolume, Sector:subsector_id, NumFills, TickCount, FirstFillTime:t0, LastFillTime:t1 from qstats where CumQty>0;

 outtbl
 };
 
 
/
get real-time tick hourly volume
\
getRTVol:{[markets]
  rtvol:select last time, rtTicks:count i, rtVol:sum QTY by sym, time.hh from tick where sym in `ES`CL`EBM`US2`FV2 ;
  rtvol:rtvol lj `sym`hh xkey histvol;
  rtvolcum:select sym, hh, rtVolCum:sums rtVol, histAvgVolCum:sums Avg30DHourlyVolum  from rtvol;
  tblout:rtvol lj `sym`hh xkey rtvolcum;

  0!tblout
 };
 
 
/ 
send updates to client
\
refresh:{

  targets: exec h from handle where active=1b, h<>0, not null user;
  show "xxxx targets: ",(string count targets)," - ",(string .z.T);
  
  if [(count targets) > 0;{
    show "Notifying targets=", (string count x);
    data:0!getRTVol[];  
    n:0;
    do[count x;
      h:x[n];
	  (neg h)(`upd;`tcatable;data);
	  n:n+1;
    ];} targets
  ] 
 }


/ 
.z.ts:{refresh[]};
\t 10000;
\
 