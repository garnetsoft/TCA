/ fixTagToName:read0 hsym `$"tags.txt";
/ table: ("ISI"; enlist ",") 0:`data.csv
tags:("SS";enlist ",") 0:`tags.txt;
fixTagToName: (tags`Tag)!(tags`Field);
/ convert back to table
/ flip (`tag`field)!(key fixTagToName;value fixTagToName);

getAllTags:{[msg](!)."S=|"0:msg}
getTag:{[tag;msg](getAllTags[msg])[tag]}

/ fixMsgs:read0 hsym `$path,"/fixMsgs.txt";
/ fixTbl:(uj/){flip fixTagToName[key d]!value enlist each d:getAllTags x} each fixMsgs;

fixMsgs:read0 hsym `$"fixMsgs.txt";
fixTbl:(uj/){flip fixTagToName[key d]!value enlist each d:getAllTags x} each fixMsgs;

fixmsgs:([]  Account:`$();  AvgPx:`float$();  ClOrdID:();  Commission:`float$();  CommType:`$();  CumQty:`float$();  Currency:`$();  ExecID:();  ExecRefID:();  HandlInst:`$();  LastCapacity:`$();  LastMkt:`$();  LastPx:`float$();  LastQty:`int$(); LeavesQty:`float$();  MsgType:`$();  OrderID:();  OrderQty:`int$();  OrdStatus:`$();  OrigClOrdID:();  Price:`float$();  SecurityID:`$();  SenderSubID:`$();  SendingTime:`datetime$();  Side:`$();  Symbol:`$();  Text:();  TimeInForce:`$();  TransactTime:`datetime$();  FixMessage:();  Time:`datetime$()  );

order:([OrderID:()]  ClOrdID:();  OrigClOrdID:();  SecurityID:`$();  Symbol:`$();  Side:`$();  OrderQty:`int$();  CumQty:`float$(); LeavesQty:`float$();  AvgPx:`float$();  Currency:`$();  Commission:`float$();  CommType:`$();  CommValue:`float$();  Account:`$();  MsgType:`$();  OrdStatus:`$();  OrderTime:`datetime$();  TransactTime:`datetime$();  AmendTime:`datetime$();  TimeInForce:`$()  );

upd:{[t;x]  
  t insert x;  
  x:`TransactTime xasc x;  

  updNewOrder[`order;select from x where MsgType in `D];  
  x:select from x where not MsgType in `D;  

  {$[(first x`MsgType)=`8;   
       updExecOrder[`order;x];     
     (first x`MsgType)=`G;   
       updAmendOrder[`order;x];    
     (first x`MsgType) in `9`F; 
       updCancelOrder[`order;x];      
    :()
    ];  
  } each (where 0b=(=':)x`MsgType) cut x  
  } 

/ updNewOrder:{[t;x] show "updNewOrder ..." }
updNewOrder:{[t;x]  x:update OrderTime:TransactTime from x;  t insert inter[cols t;cols x]#x;  } 

updExecOrder:{[t;x] show "updExecOrder ..." }
updAmendOrder:{[t;x] show "updAmendOrder ..." }
updCancelOrder:{[t;x] show "updCancelOrder ..." }

colConv:{[intype;outtype] $[(intype in ("C";"c"))&(outtype in ("C";"c"));eval'; (intype in ("C";"c"));upper[outtype]$; (outtype in ("C";"c"));string; upper[outtype]$string ]}; 
matchToSchema:{[t;schema]    c:inter[cols t;cols schema];    metsch:exec "C"^first t by c from meta schema;    mett:exec "C"^first t by c from meta t;    ?[t;();0b;c!{[y;z;x](colConv[y[x];z[x]];x)}[mett;metsch] each c]    };

genFixMsgs:{[]  
  //read fix message file  
  fixMsgs:read0 hsym `$"fixMsgs.txt";
  // extract each tag, map to name and convert to table  
  fixTbl:(uj/){flip fixTagToName[key d]!value enlist each d:getAllTags x} each fixMsgs;  
  // cast fixTbl to correct types  
  t:matchToSchema[fixTbl;fixmsgs];  
  // Add the original fix message as a column  
  t:update FixMessage:fixMsgs from t;  
  :t;  
  } 
 
runFIXFeed:{[]  
  t:genFixMsgs[];  
  / tick_handle["upd";`fixmsgs;t];  
  } 

fixorders:genFixMsgs[];
fixorders:update TransactTime:?[not null SendingTime;SendingTime;.z.Z] from fixorders;




\c 1000 2000

