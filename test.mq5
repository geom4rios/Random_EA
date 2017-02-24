//+------------------------------------------------------------------+
//|                                              Moving Averages.mq5 |
//|                   Copyright 2009-2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2009-2016, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>

int stat;

#define EXPERT_MAGIC 1234501
//+------------------------------------------------------------------+
//| Calculate optimal lot size                                       |
//+------------------------------------------------------------------+

void CHECK_STAT(){
   if(stat<=0)
   {
       Print("An error occured, error = ",GetLastError());
       return;
   }
}


//+------------------------------------------------------------------+
//| On start function                                                |
//+------------------------------------------------------------------+
//void OnStart(){
//--- declare and initialize the trade request and result of trade request
   /*MqlTradeRequest request={0};
   MqlTradeResult  result={0};
//--- parameters of request
   request.action   =TRADE_ACTION_DEAL;                     // type of trade operation
   request.symbol   =Symbol();                              // symbol
   request.volume   =0.1;                                   // volume of 0.1 lot
   request.type     =ORDER_TYPE_BUY;                        // order type
   request.price    =SymbolInfoDouble(Symbol(),SYMBOL_ASK); // price for opening
   request.deviation=5;                                     // allowed deviation from the price
   request.magic    =EXPERT_MAGIC;                          // MagicNumber of the order
   //--- send the request
   if(!OrderSend(request,result))
      PrintFormat("OrderSend error %d",GetLastError());     // if unable to send the request, output the error code
   //--- information about the operation
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   
   
   //get all open positions
   int open_positions = PositionsTotal();
   printf("\n all open positions are %d", open_positions);
   
   Sleep(5000);
   
   */
   //--- iterate over all open positions
   /*for(int i=open_positions-1; i>=0; i--)
     {
      //--- parameters of the order
      ulong  position_ticket=PositionGetTicket(i);  
      printf("position_ticket is %ld", position_ticket); // ticket of the position
      
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // symbol 
      printf("\n position symbol is %s", position_symbol);
      
      int    digits=(int)SymbolInfoInteger(position_symbol,SYMBOL_DIGITS);              // number of decimal places
      printf("\n digits are %d", digits);
      
      ulong  magic=PositionGetInteger(POSITION_MAGIC);                                  // MagicNumber of the position
      
      double volume=PositionGetDouble(POSITION_VOLUME);                                 // volume of the position
      
      ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);    // type of the position
      //--- output information about the position
      PrintFormat("#%I64u %s  %s  %.2f  %s [%I64d]",
                  position_ticket,
                  position_symbol,
                  EnumToString(type),
                  volume,
                  DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),digits),
                  magic);
      //--- if the MagicNumber matches
      if(magic==EXPERT_MAGIC)
        {
         //--- zeroing the request and result values
         ZeroMemory(request);
         ZeroMemory(result);
         //--- setting the operation parameters
         request.action   =TRADE_ACTION_DEAL;        // type of trade operation
         request.position =position_ticket;          // ticket of the position
         request.symbol   =position_symbol;          // symbol 
         request.volume   =volume;                   // volume of the position
         request.deviation=5;                        // allowed deviation from the price
         request.magic    =EXPERT_MAGIC;             // MagicNumber of the position
         
         request.type =ORDER_TYPE_BUY_STOP;
         //--- set the price and order type depending on the position type
         if(type==POSITION_TYPE_BUY)
           {
            request.price=SymbolInfoDouble(position_symbol,SYMBOL_BID);
            request.type =ORDER_TYPE_SELL;
           }
         else
           {
            request.price=SymbolInfoDouble(position_symbol,SYMBOL_ASK);
            request.type =ORDER_TYPE_BUY;
           }
         //--- output information about the closure
         PrintFormat("Close #%I64d %s %s",position_ticket,position_symbol,EnumToString(type));
         //--- send the request
         if(!OrderSend(request,result))
            PrintFormat("OrderSend error %d",GetLastError());  // if unable to send the request, output the error code
         //--- information about the operation   
         PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
         
         double account_balance = AccountInfoDouble(ACCOUNT_BALANCE);
         printf("\n account balance is %f", account_balance);
   
         //---
        }
     }*/
  

//}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(void)
  {
    
     //printf("trading on %s", _Symbol);
     
     //printf("INITIALIZED succesfully");
     //printf("\n %s ", Symbol());
     
   double Ups[],Downs[], Ups_1[], Downs_1[];
   datetime Time[];
   //--- Set the arrays as timeseries
   ArraySetAsSeries(Ups,true);
   ArraySetAsSeries(Downs,true);
   ArraySetAsSeries(Ups_1,true);
   ArraySetAsSeries(Downs_1,true);
   ArraySetAsSeries(Time,true);
     
   //--- Try to copy the values of the indicator
   datetime  mytime = TimeCurrent();
   string myStr = TimeToString(mytime, TIME_DATE);
   printf("local time is %s", myStr);
   
   MqlDateTime str2;
   TimeToStruct(mytime, str2);
   
   printf("%02d.%02d.%4d, day of year = %d",str2.day,str2.mon,
          str2.year,str2.day_of_year);
   
   
   //check for EURUSD, GBPUSD, EURGBP
   
   stat=CopyOpen("EURUSD", PERIOD_M5, mytime, 1, Ups); 
   CHECK_STAT();
   
   printf("UP prices for eurusd");
   ArrayPrint(Ups);
     
   stat=CopyClose("EURUSD",PERIOD_M5, mytime, 1, Downs);  
   CHECK_STAT();
   
   printf("DOWN PRICES for eurusd");
   ArrayPrint(Downs);
   
   stat=CopyOpen("GBPUSD", PERIOD_M5, mytime, 1, Ups_1); 
   CHECK_STAT();
   
   printf("UP prices for gbp usd");
   ArrayPrint(Ups_1);
     
   stat=CopyClose("GBPUSD",PERIOD_M5, mytime, 1, Downs_1);  
   CHECK_STAT();
   
   printf("DOWN PRICES for gbp usd");
   ArrayPrint(Downs_1);
   
   
   double up_eurusd = Ups[0];
   double down_eurusd = Downs[0];
   double up_gbpusd = Ups_1[0];
   double down_gbpusd = Downs_1[0];
   
   double account_balance = AccountInfoDouble(ACCOUNT_BALANCE);
   printf("\n account balance is %f", account_balance);
   
   MqlTradeRequest request={0};
   MqlTradeResult  result={0};
   //--- parameters of request
   request.action   =TRADE_ACTION_DEAL;                     // type of trade operation
   request.symbol   =Symbol();                              // symbol
   request.volume   =0.1;                                   // volume of 0.1 lot
   request.type     =ORDER_TYPE_BUY;                        // order type
   request.price    =SymbolInfoDouble(Symbol(),SYMBOL_ASK); // price for opening
   request.deviation=5;                                     // allowed deviation from the price
   request.magic    =EXPERT_MAGIC;                          // MagicNumber of the order
   //--- send the request
   if(!OrderSend(request,result))
      PrintFormat("OrderSend error %d",GetLastError());     // if unable to send the request, output the error code
   //--- information about the operation
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   
   
   //get all open positions
   int open_positions = PositionsTotal();
   printf("\n all open positions are %d", open_positions);
   
   Sleep(5000);
   
   
   //--- iterate over all open positions
   for(int i=open_positions-1; i>=0; i--)
     {
      //--- parameters of the order
      ulong  position_ticket=PositionGetTicket(i);  
      printf("position_ticket is %ld", position_ticket); // ticket of the position
      
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // symbol 
      printf("\n position symbol is %s", position_symbol);
      
      int    digits=(int)SymbolInfoInteger(position_symbol,SYMBOL_DIGITS);              // number of decimal places
      printf("\n digits are %d", digits);
      
      ulong  magic=PositionGetInteger(POSITION_MAGIC);                                  // MagicNumber of the position
      
      double volume=PositionGetDouble(POSITION_VOLUME);                                 // volume of the position
      
      ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);    // type of the position
      //--- output information about the position
      PrintFormat("#%I64u %s  %s  %.2f  %s [%I64d]",
                  position_ticket,
                  position_symbol,
                  EnumToString(type),
                  volume,
                  DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),digits),
                  magic);
      //--- if the MagicNumber matches
      if(magic==EXPERT_MAGIC)
        {
         //--- zeroing the request and result values
         ZeroMemory(request);
         ZeroMemory(result);
         //--- setting the operation parameters
         request.action   =TRADE_ACTION_DEAL;        // type of trade operation
         request.position =position_ticket;          // ticket of the position
         request.symbol   =position_symbol;          // symbol 
         request.volume   =volume;                   // volume of the position
         request.deviation=5;                        // allowed deviation from the price
         request.magic    =EXPERT_MAGIC;             // MagicNumber of the position
         
         //request.type =ORDER_TYPE_BUY_STOP;
         //--- set the price and order type depending on the position type
         if(type==POSITION_TYPE_BUY)
           {
            request.price=SymbolInfoDouble(position_symbol,SYMBOL_BID);
            request.type =ORDER_TYPE_SELL;
           }
         else
           {
            request.price=SymbolInfoDouble(position_symbol,SYMBOL_ASK);
            request.type =ORDER_TYPE_BUY;
           }
         //--- output information about the closure
         PrintFormat("Close #%I64d %s %s",position_ticket,position_symbol,EnumToString(type));
         //--- send the request
         if(!OrderSend(request,result))
            PrintFormat("OrderSend error %d",GetLastError());  // if unable to send the request, output the error code
         //--- information about the operation   
         PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
         
         double account_balance = AccountInfoDouble(ACCOUNT_BALANCE);
         printf("\n account balance is %f", account_balance);
   
         //---
        }
     }
  

    
     
//--- ok
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(void)
  {
//
      
      //double Price = SymbolInfoDouble(_Symbol,SYMBOL_BID);
      //printf("\n current price is: %f", Price);
      
      //double gbpusd=SymbolInfoDouble("GBPUSD",SYMBOL_ASK);
      //printf("\n gbpusd is %f", gbpusd);
//---
    

  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
