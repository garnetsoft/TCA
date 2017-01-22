colConv:{[intype;outtype] $[(intype in ("C";"c"))&(outtype in ("C";"c"));eval'; (intype in ("C";"c"));upper[outtype]$; (outtype in ("C";"c"));string; upper[outtype]$string ]}; 
matchToSchema:{[t;schema]    c:inter[cols t;cols schema];    metsch:exec "C"^first t by c from meta schema;    mett:exec "C"^first t by c from meta t;    ?[t;();0b;c!{[y;z;x](colConv[y[x];z[x]];x)}[mett;metsch] each c]    };

genFixMsgs:{[]  
  //read fix message file  
  fixMsgs:read0 hsym "fixMsgs.txt";  
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
  / tick_handle[“upd”;`fixmsgs;t];  
  } 
 




