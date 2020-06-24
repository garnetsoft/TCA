/ tick table
/ tick:([]time:`time$();sym:`symbol$();QID:`symbol$();MATID:`symbol$();PX:`float$();QTY:`int$();EXC:`symbol$();TRD:`int$();SRC:`symbol$();TZ:`symbol$();SRCSYM:`symbol$();EXCDT:`timestamp$();RECDT:`timestamp$();DISDT:`timestamp$())

/ qorders
/ qorders:([] time:`time$();sym:`symbol$();Account:`symbol$();AvgPx:`float$();ClOrdID:`symbol$();Commission:`float$();CommType:`$();CumQty:`float$();Currency:`$();ExecID:`symbol$();ExecRefID:`symbol$();HandlInst:`symbol$();LastCapacity:`$();LastMkt:`$();LastPx:`float$();LastQty:`int$();LeavesQty:`float$();MsgType:`$();OrdType:`$();OrderID:`$();OrderQty:`int$();OrdStatus:`$();OrigClOrdID:`$();Price:`float$();SecurityID:`$();SenderSubID:`$();SendingTime:`timestamp$();Side:`$();Text:`$();TimeInForce:`$();TransactTime:`timestamp$(); Payload:());

/ alpaca market data

raw:([]qtm:();seq:();json:());
evt:([]qtm:();stream:();data:());

/ trade:flip `ev`T`i`x`p`s`t`c`z!"**fffff*f"$\:();
/ quote:flip `ev`T`x`p`s`X`P`S`c`t!"**ffffff*f"$\:();

trade:flip `qtm`evt`sym`id`ex`price`size`tms`cond`tape!"***fffff*f"$\:();
quote:flip `qtm`evt`sym`exbid`bid`bsize`exask`ask`asize`cond`tms!"***ffffff*f"$\:();

td:{update "p"$1970.01.01D+tms from select by sym from trade}
qt:{update "p"$1970.01.01D+tms from select by sym from quote}


/ iex tables
iextops:flip `symbol`sector`securityType`bidPrice`bidSize`askPrice`askSize`lastUpdated`lastSalePrice`lastSaleSize`lastSaleTime`volume`lastSaleTimez`lastUpdatedz`sym!"***fifijfijjzzs"$\()

/ iexquote:flip `symbol`companyName`primaryExchange`calculationPrice`open`openTime`openSource`latestPrice`latestSource`latestTime`latestUpdate`latestVolume`iexRealtimePrice`iexRealtimeSize`iexLastUpdated`iexMarketPercent`iexVolume`avgTotalVolume`iexBidPrice`iexBidSize`iexAskPrice`iexAskSize`iexOpen`iexOpenTime`iexClose`iexCloseTime`marketCap`peRatio`week52High`week52Low`ytdChange`lastTradeTime`isUSMarketOpen!"****ff*f**fffffffffffffffffffffjb"$\();

/ iexquote:flip `symbol`companyName`primaryExchange`calculationPrice`open`openTime`openSource`close`closeTime`closeSource`high`highTime`highSource`low`lowTime`lowSource`latestPrice`latestSource`latestTime`latestUpdate`latestVolume`iexRealtimePrice`iexRealtimeSize`iexLastUpdated`delayedPrice`delayedPriceTime`oddLotDelayedPrice`oddLotDelayedPriceTime`extendedPrice`extendedChange`extendedChangePercent`extendedPriceTime`previousClose`previousVolume`change`changePercent`volume`iexMarketPercent`iexVolume`avgTotalVolume`iexBidPrice`iexBidSize`iexAskPrice`iexAskSize`iexOpen`iexOpenTime`iexClose`iexCloseTime`marketCap`peRatio`week52High`week52Low`ytdChange`lastTradeTime`isUSMarketOpen`latestUpdatez`lastTradeTimez!"****ff**********f**ffffff************jffffffffffffffffjbzz"$\();

/ iexquote:flip `symbol`companyName`primaryExchange`calculationPrice`open`openTime`openSource`latestPrice`latestSource`latestTime`latestUpdate`latestVolume`previousClose`previousVolume`change`changePercent`volume`avgTotalVolume`iexBidPrice`iexBidSize`iexAskPrice`iexAskSize`marketCap`peRatio`week52High`week52Low`ytdChange`lastTradeTime`isUSMarketOpen`latestUpdatez`lastTradeTimez`sym!"ssssfjsfssffffffffffffffffffbzzs"$\();

iexquote:flip `symbol`companyName`primaryExchange`calculationPrice`openSource`latestPrice`latestSource`latestTime`latestUpdate`latestVolume`previousClose`previousVolume`change`changePercent`volume`avgTotalVolume`iexBidPrice`iexBidSize`iexAskPrice`iexAskSize`marketCap`peRatio`week52High`week52Low`ytdChange`lastTradeTime`isUSMarketOpen`latestUpdatez`lastTradeTimez`sym!"sssssfssffffffffffffffffffbzzs"$\();

