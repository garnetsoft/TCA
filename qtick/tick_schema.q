/ init schema for trade table
trade:([] 
  time:`time$();
  sym:`g#`$();
  price:`float$();
  size:`int$()
  );

/ init schema for quote table
quote:([] 
  time:`time$();
  sym:`g#`$();
  bid:`float$();
  ask:`float$(); 
  bsize:`int$();
  asize:`int$()
 );

/ tick table
tick:([]time:`time$();sym:`symbol$();QID:`symbol$();MATID:`symbol$();PX:`float$();QTY:`int$();EXC:`symbol$();TRD:`int$();SRC:`symbol$();TZ:`symbol$();SRCSYM:`symbol$();EXCDT:`timestamp$();RECDT:`timestamp$();DISDT:`timestamp$())

/ order table
qorders:([] time:`time$();sym:`symbol$();Account:`symbol$();AvgPx:`float$();ClOrdID:`symbol$();Commission:`float$();CommType:`$();CumQty:`float$();Currency:`$();ExecID:`symbol$();ExecRefID:`symbol$();HandlInst:`symbol$();LastCapacity:`$();LastMkt:`$();LastPx:`float$();LastQty:`int$();LeavesQty:`float$();MsgType:`$();OrdType:`$();OrderID:`$();OrderQty:`int$();OrdStatus:`$();OrigClOrdID:`$();Price:`float$();SecurityID:`$();SenderSubID:`$();SendingTime:`timestamp$();Side:`$();Text:`$();TimeInForce:`$();TransactTime:`timestamp$(); Payload:`$());
 