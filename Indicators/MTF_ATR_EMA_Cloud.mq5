//+------------------------------------------------------------------+
//|                                          MTF_ATR_EMA_Cloud.mq5   |
//|                                    Copyright 2026, gcmishra7     |
//|                           Multi-Timeframe ATR/EMA Cloud Indicator|
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, gcmishra7"
#property link      ""
#property version   "1.00"
#property description "Multi-Timeframe ATR/EMA Cloud Indicator for Manual Strategy Verification"
#property description "Phase 1: Visual confirmation of multi-timeframe alignment and entry signals"
#property indicator_chart_window
#property indicator_buffers 10
#property indicator_plots   8

// Include helper files
#include <EMACloud.mqh>
#include <ATRFilter.mqh>

//--- Input Parameters

// EMA Settings
input int EMA_Period_1 = 5;      // EMA Period 1 (Fastest)
input int EMA_Period_2 = 8;      // EMA Period 2
input int EMA_Period_3 = 13;     // EMA Period 3
input int EMA_Period_4 = 21;     // EMA Period 4
input int EMA_Period_5 = 34;     // EMA Period 5
input int EMA_Period_6 = 55;     // EMA Period 6 (Slowest)

// ATR Filter Settings
input int ATR_Period = 14;                      // ATR Period
input int ATR_MA_Period = 14;                   // ATR Moving Average Period
input double ATR_Threshold_Multiplier = 1.0;    // ATR Threshold Multiplier

// Timeframe Settings
input ENUM_TIMEFRAMES HTF_Timeframe = PERIOD_H1;  // Higher Timeframe (Bias)
input ENUM_TIMEFRAMES MTF_Timeframe = PERIOD_M10; // Medium Timeframe (Filter)
input ENUM_TIMEFRAMES LTF_Timeframe = PERIOD_M3;  // Lower Timeframe (Entry)

// Visual Settings
input color Color_Bullish = clrLimeGreen;  // Bullish Color
input color Color_Bearish = clrRed;        // Bearish Color
input color Color_Neutral = clrGray;       // Neutral Color
input bool Show_Arrows = true;             // Show Entry Arrows
input bool Show_Dashboard = true;          // Show Info Dashboard
input bool Enable_Alerts = true;           // Enable Alerts

//--- Indicator Buffers
double EMA1_Buffer[];  // EMA 5
double EMA2_Buffer[];  // EMA 8
double EMA3_Buffer[];  // EMA 13
double EMA4_Buffer[];  // EMA 21
double EMA5_Buffer[];  // EMA 34
double EMA6_Buffer[];  // EMA 55
double BuyArrow_Buffer[];   // Buy signals
double SellArrow_Buffer[];  // Sell signals
double ATR_Buffer[];        // ATR values
double ATR_MA_Buffer[];     // ATR MA values

//--- Indicator Handles
int ema1_handle, ema2_handle, ema3_handle;
int ema4_handle, ema5_handle, ema6_handle;
int atr_handle, atr_ma_handle;

// Multi-timeframe handles
int htf_ema1_handle, htf_ema2_handle, htf_ema3_handle;
int htf_ema4_handle, htf_ema5_handle, htf_ema6_handle;
int mtf_ema1_handle, mtf_ema2_handle, mtf_ema3_handle;
int mtf_ema4_handle, mtf_ema5_handle, mtf_ema6_handle;
int mtf_atr_handle, mtf_atr_ma_handle;

//--- Global Variables
string dashboard_prefix = "MTF_Dashboard_";
datetime lastSignalTime = 0;
int lastSignalType = 0; // 1=buy, -1=sell, 0=none

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Validate input parameters
   if(EMA_Period_1 <= 0 || EMA_Period_2 <= 0 || EMA_Period_3 <= 0 ||
      EMA_Period_4 <= 0 || EMA_Period_5 <= 0 || EMA_Period_6 <= 0)
   {
      Print("Error: EMA periods must be positive");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(ATR_Period <= 0 || ATR_MA_Period <= 0)
   {
      Print("Error: ATR periods must be positive");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   //--- Set indicator buffers
   SetIndexBuffer(0, EMA1_Buffer, INDICATOR_DATA);
   SetIndexBuffer(1, EMA2_Buffer, INDICATOR_DATA);
   SetIndexBuffer(2, EMA3_Buffer, INDICATOR_DATA);
   SetIndexBuffer(3, EMA4_Buffer, INDICATOR_DATA);
   SetIndexBuffer(4, EMA5_Buffer, INDICATOR_DATA);
   SetIndexBuffer(5, EMA6_Buffer, INDICATOR_DATA);
   SetIndexBuffer(6, BuyArrow_Buffer, INDICATOR_DATA);
   SetIndexBuffer(7, SellArrow_Buffer, INDICATOR_DATA);
   SetIndexBuffer(8, ATR_Buffer, INDICATOR_CALCULATIONS);
   SetIndexBuffer(9, ATR_MA_Buffer, INDICATOR_CALCULATIONS);
   
   //--- Set indicator properties
   PlotIndexSetInteger(0, PLOT_DRAW_TYPE, DRAW_LINE);
   PlotIndexSetInteger(0, PLOT_LINE_WIDTH, 1);
   PlotIndexSetString(0, PLOT_LABEL, "EMA " + IntegerToString(EMA_Period_1));
   
   PlotIndexSetInteger(1, PLOT_DRAW_TYPE, DRAW_LINE);
   PlotIndexSetInteger(1, PLOT_LINE_WIDTH, 1);
   PlotIndexSetString(1, PLOT_LABEL, "EMA " + IntegerToString(EMA_Period_2));
   
   PlotIndexSetInteger(2, PLOT_DRAW_TYPE, DRAW_LINE);
   PlotIndexSetInteger(2, PLOT_LINE_WIDTH, 1);
   PlotIndexSetString(2, PLOT_LABEL, "EMA " + IntegerToString(EMA_Period_3));
   
   PlotIndexSetInteger(3, PLOT_DRAW_TYPE, DRAW_LINE);
   PlotIndexSetInteger(3, PLOT_LINE_WIDTH, 2);
   PlotIndexSetString(3, PLOT_LABEL, "EMA " + IntegerToString(EMA_Period_4));
   
   PlotIndexSetInteger(4, PLOT_DRAW_TYPE, DRAW_LINE);
   PlotIndexSetInteger(4, PLOT_LINE_WIDTH, 2);
   PlotIndexSetString(4, PLOT_LABEL, "EMA " + IntegerToString(EMA_Period_5));
   
   PlotIndexSetInteger(5, PLOT_DRAW_TYPE, DRAW_LINE);
   PlotIndexSetInteger(5, PLOT_LINE_WIDTH, 2);
   PlotIndexSetString(5, PLOT_LABEL, "EMA " + IntegerToString(EMA_Period_6));
   
   //--- Setup arrow plots for signals
   PlotIndexSetInteger(6, PLOT_DRAW_TYPE, DRAW_ARROW);
   PlotIndexSetInteger(6, PLOT_ARROW, 233); // Up arrow
   PlotIndexSetInteger(6, PLOT_LINE_COLOR, Color_Bullish);
   PlotIndexSetInteger(6, PLOT_LINE_WIDTH, 3);
   PlotIndexSetString(6, PLOT_LABEL, "Buy Signal");
   
   PlotIndexSetInteger(7, PLOT_DRAW_TYPE, DRAW_ARROW);
   PlotIndexSetInteger(7, PLOT_ARROW, 234); // Down arrow
   PlotIndexSetInteger(7, PLOT_LINE_COLOR, Color_Bearish);
   PlotIndexSetInteger(7, PLOT_LINE_WIDTH, 3);
   PlotIndexSetString(7, PLOT_LABEL, "Sell Signal");
   
   //--- Initialize indicator handles for current timeframe (LTF)
   ema1_handle = iMA(_Symbol, LTF_Timeframe, EMA_Period_1, 0, MODE_EMA, PRICE_CLOSE);
   ema2_handle = iMA(_Symbol, LTF_Timeframe, EMA_Period_2, 0, MODE_EMA, PRICE_CLOSE);
   ema3_handle = iMA(_Symbol, LTF_Timeframe, EMA_Period_3, 0, MODE_EMA, PRICE_CLOSE);
   ema4_handle = iMA(_Symbol, LTF_Timeframe, EMA_Period_4, 0, MODE_EMA, PRICE_CLOSE);
   ema5_handle = iMA(_Symbol, LTF_Timeframe, EMA_Period_5, 0, MODE_EMA, PRICE_CLOSE);
   ema6_handle = iMA(_Symbol, LTF_Timeframe, EMA_Period_6, 0, MODE_EMA, PRICE_CLOSE);
   
   atr_handle = iATR(_Symbol, LTF_Timeframe, ATR_Period);
   
   // Create a custom ATR MA using iMA on ATR values
   atr_ma_handle = iMA(_Symbol, LTF_Timeframe, ATR_MA_Period, 0, MODE_SMA, PRICE_CLOSE);
   
   //--- Initialize HTF indicator handles
   htf_ema1_handle = iMA(_Symbol, HTF_Timeframe, EMA_Period_1, 0, MODE_EMA, PRICE_CLOSE);
   htf_ema2_handle = iMA(_Symbol, HTF_Timeframe, EMA_Period_2, 0, MODE_EMA, PRICE_CLOSE);
   htf_ema3_handle = iMA(_Symbol, HTF_Timeframe, EMA_Period_3, 0, MODE_EMA, PRICE_CLOSE);
   htf_ema4_handle = iMA(_Symbol, HTF_Timeframe, EMA_Period_4, 0, MODE_EMA, PRICE_CLOSE);
   htf_ema5_handle = iMA(_Symbol, HTF_Timeframe, EMA_Period_5, 0, MODE_EMA, PRICE_CLOSE);
   htf_ema6_handle = iMA(_Symbol, HTF_Timeframe, EMA_Period_6, 0, MODE_EMA, PRICE_CLOSE);
   
   //--- Initialize MTF indicator handles
   mtf_ema1_handle = iMA(_Symbol, MTF_Timeframe, EMA_Period_1, 0, MODE_EMA, PRICE_CLOSE);
   mtf_ema2_handle = iMA(_Symbol, MTF_Timeframe, EMA_Period_2, 0, MODE_EMA, PRICE_CLOSE);
   mtf_ema3_handle = iMA(_Symbol, MTF_Timeframe, EMA_Period_3, 0, MODE_EMA, PRICE_CLOSE);
   mtf_ema4_handle = iMA(_Symbol, MTF_Timeframe, EMA_Period_4, 0, MODE_EMA, PRICE_CLOSE);
   mtf_ema5_handle = iMA(_Symbol, MTF_Timeframe, EMA_Period_5, 0, MODE_EMA, PRICE_CLOSE);
   mtf_ema6_handle = iMA(_Symbol, MTF_Timeframe, EMA_Period_6, 0, MODE_EMA, PRICE_CLOSE);
   
   mtf_atr_handle = iATR(_Symbol, MTF_Timeframe, ATR_Period);
   mtf_atr_ma_handle = iMA(_Symbol, MTF_Timeframe, ATR_MA_Period, 0, MODE_SMA, PRICE_CLOSE);
   
   //--- Check handles
   if(ema1_handle == INVALID_HANDLE || ema2_handle == INVALID_HANDLE || 
      ema3_handle == INVALID_HANDLE || ema4_handle == INVALID_HANDLE ||
      ema5_handle == INVALID_HANDLE || ema6_handle == INVALID_HANDLE ||
      atr_handle == INVALID_HANDLE)
   {
      Print("Error creating indicator handles");
      return(INIT_FAILED);
   }
   
   //--- Set empty values for arrow buffers
   PlotIndexSetDouble(6, PLOT_EMPTY_VALUE, 0);
   PlotIndexSetDouble(7, PLOT_EMPTY_VALUE, 0);
   
   ArraySetAsSeries(EMA1_Buffer, true);
   ArraySetAsSeries(EMA2_Buffer, true);
   ArraySetAsSeries(EMA3_Buffer, true);
   ArraySetAsSeries(EMA4_Buffer, true);
   ArraySetAsSeries(EMA5_Buffer, true);
   ArraySetAsSeries(EMA6_Buffer, true);
   ArraySetAsSeries(BuyArrow_Buffer, true);
   ArraySetAsSeries(SellArrow_Buffer, true);
   ArraySetAsSeries(ATR_Buffer, true);
   ArraySetAsSeries(ATR_MA_Buffer, true);
   
   //--- Indicator short name
   IndicatorSetString(INDICATOR_SHORTNAME, "MTF ATR/EMA Cloud");
   
   //--- Set precision
   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Release indicator handles
   if(ema1_handle != INVALID_HANDLE) IndicatorRelease(ema1_handle);
   if(ema2_handle != INVALID_HANDLE) IndicatorRelease(ema2_handle);
   if(ema3_handle != INVALID_HANDLE) IndicatorRelease(ema3_handle);
   if(ema4_handle != INVALID_HANDLE) IndicatorRelease(ema4_handle);
   if(ema5_handle != INVALID_HANDLE) IndicatorRelease(ema5_handle);
   if(ema6_handle != INVALID_HANDLE) IndicatorRelease(ema6_handle);
   if(atr_handle != INVALID_HANDLE) IndicatorRelease(atr_handle);
   if(atr_ma_handle != INVALID_HANDLE) IndicatorRelease(atr_ma_handle);
   
   if(htf_ema1_handle != INVALID_HANDLE) IndicatorRelease(htf_ema1_handle);
   if(htf_ema2_handle != INVALID_HANDLE) IndicatorRelease(htf_ema2_handle);
   if(htf_ema3_handle != INVALID_HANDLE) IndicatorRelease(htf_ema3_handle);
   if(htf_ema4_handle != INVALID_HANDLE) IndicatorRelease(htf_ema4_handle);
   if(htf_ema5_handle != INVALID_HANDLE) IndicatorRelease(htf_ema5_handle);
   if(htf_ema6_handle != INVALID_HANDLE) IndicatorRelease(htf_ema6_handle);
   
   if(mtf_ema1_handle != INVALID_HANDLE) IndicatorRelease(mtf_ema1_handle);
   if(mtf_ema2_handle != INVALID_HANDLE) IndicatorRelease(mtf_ema2_handle);
   if(mtf_ema3_handle != INVALID_HANDLE) IndicatorRelease(mtf_ema3_handle);
   if(mtf_ema4_handle != INVALID_HANDLE) IndicatorRelease(mtf_ema4_handle);
   if(mtf_ema5_handle != INVALID_HANDLE) IndicatorRelease(mtf_ema5_handle);
   if(mtf_ema6_handle != INVALID_HANDLE) IndicatorRelease(mtf_ema6_handle);
   if(mtf_atr_handle != INVALID_HANDLE) IndicatorRelease(mtf_atr_handle);
   if(mtf_atr_ma_handle != INVALID_HANDLE) IndicatorRelease(mtf_atr_ma_handle);
   
   //--- Delete dashboard objects
   DeleteDashboard();
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   //--- Check if we have enough bars
   if(rates_total < EMA_Period_6)
      return(0);
   
   //--- Set arrays as series
   ArraySetAsSeries(close, true);
   ArraySetAsSeries(time, true);
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   
   //--- Calculate starting position
   int limit;
   if(prev_calculated == 0)
      limit = rates_total - EMA_Period_6 - 1;
   else
      limit = rates_total - prev_calculated;
   
   //--- Main calculation loop
   for(int i = limit; i >= 0; i--)
   {
      //--- Copy EMA values
      double ema1_val[], ema2_val[], ema3_val[];
      double ema4_val[], ema5_val[], ema6_val[];
      
      if(CopyBuffer(ema1_handle, 0, i, 1, ema1_val) <= 0) continue;
      if(CopyBuffer(ema2_handle, 0, i, 1, ema2_val) <= 0) continue;
      if(CopyBuffer(ema3_handle, 0, i, 1, ema3_val) <= 0) continue;
      if(CopyBuffer(ema4_handle, 0, i, 1, ema4_val) <= 0) continue;
      if(CopyBuffer(ema5_handle, 0, i, 1, ema5_val) <= 0) continue;
      if(CopyBuffer(ema6_handle, 0, i, 1, ema6_val) <= 0) continue;
      
      //--- Store EMA values in buffers
      EMA1_Buffer[i] = ema1_val[0];
      EMA2_Buffer[i] = ema2_val[0];
      EMA3_Buffer[i] = ema3_val[0];
      EMA4_Buffer[i] = ema4_val[0];
      EMA5_Buffer[i] = ema5_val[0];
      EMA6_Buffer[i] = ema6_val[0];
      
      //--- Copy ATR values
      double atr_val[];
      if(CopyBuffer(atr_handle, 0, i, 1, atr_val) > 0)
      {
         ATR_Buffer[i] = atr_val[0];
      }
      
      //--- Initialize arrow buffers
      BuyArrow_Buffer[i] = 0;
      SellArrow_Buffer[i] = 0;
      
      //--- Update EMA line colors based on alignment
      int alignment = GetEMACloudAlignment(ema1_val[0], ema2_val[0], ema3_val[0],
                                          ema4_val[0], ema5_val[0], ema6_val[0]);
      
      color lineColor = Color_Neutral;
      if(alignment == 1)
         lineColor = Color_Bullish;
      else if(alignment == -1)
         lineColor = Color_Bearish;
      
      // Set colors for all EMA plots
      PlotIndexSetInteger(0, PLOT_LINE_COLOR, lineColor);
      PlotIndexSetInteger(1, PLOT_LINE_COLOR, lineColor);
      PlotIndexSetInteger(2, PLOT_LINE_COLOR, lineColor);
      PlotIndexSetInteger(3, PLOT_LINE_COLOR, lineColor);
      PlotIndexSetInteger(4, PLOT_LINE_COLOR, lineColor);
      PlotIndexSetInteger(5, PLOT_LINE_COLOR, lineColor);
   }
   
   //--- Check for new signals on current bar (bar 0)
   if(Show_Arrows)
   {
      CheckAndGenerateSignals(close, time);
   }
   
   //--- Update dashboard
   if(Show_Dashboard)
   {
      UpdateDashboard();
   }
   
   //--- Return value of prev_calculated for next call
   return(rates_total);
}

//+------------------------------------------------------------------+
//| Check multi-timeframe alignment and generate signals             |
//+------------------------------------------------------------------+
void CheckAndGenerateSignals(const double &close[], const datetime &time[])
{
   //--- Get current bar data
   double htf_ema_vals[6], mtf_ema_vals[6], ltf_ema_vals[6];
   double mtf_atr, mtf_atr_ma;
   
   //--- Copy HTF EMA values
   double temp_val[];
   if(CopyBuffer(htf_ema1_handle, 0, 0, 1, temp_val) > 0) htf_ema_vals[0] = temp_val[0]; else return;
   if(CopyBuffer(htf_ema2_handle, 0, 0, 1, temp_val) > 0) htf_ema_vals[1] = temp_val[0]; else return;
   if(CopyBuffer(htf_ema3_handle, 0, 0, 1, temp_val) > 0) htf_ema_vals[2] = temp_val[0]; else return;
   if(CopyBuffer(htf_ema4_handle, 0, 0, 1, temp_val) > 0) htf_ema_vals[3] = temp_val[0]; else return;
   if(CopyBuffer(htf_ema5_handle, 0, 0, 1, temp_val) > 0) htf_ema_vals[4] = temp_val[0]; else return;
   if(CopyBuffer(htf_ema6_handle, 0, 0, 1, temp_val) > 0) htf_ema_vals[5] = temp_val[0]; else return;
   
   //--- Copy MTF EMA values
   if(CopyBuffer(mtf_ema1_handle, 0, 0, 1, temp_val) > 0) mtf_ema_vals[0] = temp_val[0]; else return;
   if(CopyBuffer(mtf_ema2_handle, 0, 0, 1, temp_val) > 0) mtf_ema_vals[1] = temp_val[0]; else return;
   if(CopyBuffer(mtf_ema3_handle, 0, 0, 1, temp_val) > 0) mtf_ema_vals[2] = temp_val[0]; else return;
   if(CopyBuffer(mtf_ema4_handle, 0, 0, 1, temp_val) > 0) mtf_ema_vals[3] = temp_val[0]; else return;
   if(CopyBuffer(mtf_ema5_handle, 0, 0, 1, temp_val) > 0) mtf_ema_vals[4] = temp_val[0]; else return;
   if(CopyBuffer(mtf_ema6_handle, 0, 0, 1, temp_val) > 0) mtf_ema_vals[5] = temp_val[0]; else return;
   
   //--- Copy LTF EMA values
   ltf_ema_vals[0] = EMA1_Buffer[0];
   ltf_ema_vals[1] = EMA2_Buffer[0];
   ltf_ema_vals[2] = EMA3_Buffer[0];
   ltf_ema_vals[3] = EMA4_Buffer[0];
   ltf_ema_vals[4] = EMA5_Buffer[0];
   ltf_ema_vals[5] = EMA6_Buffer[0];
   
   //--- Copy ATR values
   if(CopyBuffer(mtf_atr_handle, 0, 0, 1, temp_val) > 0) mtf_atr = temp_val[0]; else return;
   
   // For ATR MA, we need to calculate it manually from ATR values
   double atr_ma_vals[];
   ArrayResize(atr_ma_vals, ATR_MA_Period);
   if(CopyBuffer(mtf_atr_handle, 0, 0, ATR_MA_Period, atr_ma_vals) <= 0) return;
   
   mtf_atr_ma = 0;
   for(int j = 0; j < ATR_MA_Period; j++)
      mtf_atr_ma += atr_ma_vals[j];
   mtf_atr_ma /= ATR_MA_Period;
   
   //--- Check HTF bias
   int htf_alignment = GetEMACloudAlignment(htf_ema_vals[0], htf_ema_vals[1], htf_ema_vals[2],
                                           htf_ema_vals[3], htf_ema_vals[4], htf_ema_vals[5]);
   
   //--- Check MTF trend
   int mtf_alignment = GetEMACloudAlignment(mtf_ema_vals[0], mtf_ema_vals[1], mtf_ema_vals[2],
                                           mtf_ema_vals[3], mtf_ema_vals[4], mtf_ema_vals[5]);
   
   //--- Check ATR filter
   bool atr_active = IsATRFilterActive(mtf_atr, mtf_atr_ma, ATR_Threshold_Multiplier);
   
   //--- Check LTF alignment
   int ltf_alignment = GetEMACloudAlignment(ltf_ema_vals[0], ltf_ema_vals[1], ltf_ema_vals[2],
                                           ltf_ema_vals[3], ltf_ema_vals[4], ltf_ema_vals[5]);
   
   //--- Generate signals
   // Bullish signal: HTF bullish, MTF bullish, ATR active, LTF showing bullish structure
   if(htf_alignment == 1 && mtf_alignment == 1 && atr_active && ltf_alignment == 1)
   {
      // Check for price break above EMA cloud
      bool bullish_break = DetectEMACloudBreak(close[0], ltf_ema_vals[0], 
                                               ltf_ema_vals[1], ltf_ema_vals[2], true);
      
      if(bullish_break && time[0] != lastSignalTime)
      {
         BuyArrow_Buffer[0] = low[0] - (10 * _Point);
         lastSignalTime = time[0];
         lastSignalType = 1;
         
         if(Enable_Alerts)
         {
            Alert("MTF ATR/EMA Cloud: BUY Signal on ", _Symbol, " @ ", TimeToString(time[0]));
         }
      }
   }
   
   // Bearish signal: HTF bearish, MTF bearish, ATR active, LTF showing bearish structure
   if(htf_alignment == -1 && mtf_alignment == -1 && atr_active && ltf_alignment == -1)
   {
      // Check for price break below EMA cloud
      bool bearish_break = DetectEMACloudBreak(close[0], ltf_ema_vals[0], 
                                               ltf_ema_vals[1], ltf_ema_vals[2], false);
      
      if(bearish_break && time[0] != lastSignalTime)
      {
         SellArrow_Buffer[0] = high[0] + (10 * _Point);
         lastSignalTime = time[0];
         lastSignalType = -1;
         
         if(Enable_Alerts)
         {
            Alert("MTF ATR/EMA Cloud: SELL Signal on ", _Symbol, " @ ", TimeToString(time[0]));
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Update dashboard display                                          |
//+------------------------------------------------------------------+
void UpdateDashboard()
{
   //--- Dashboard coordinates (top-right corner)
   int x_pos = 20;
   int y_pos = 20;
   int line_height = 18;
   
   //--- Get current data for dashboard
   double htf_ema_vals[6], mtf_ema_vals[6];
   double mtf_atr, mtf_atr_ma;
   
   double temp_val[];
   
   //--- Copy HTF EMA values
   if(CopyBuffer(htf_ema1_handle, 0, 0, 1, temp_val) > 0) htf_ema_vals[0] = temp_val[0]; else return;
   if(CopyBuffer(htf_ema2_handle, 0, 0, 1, temp_val) > 0) htf_ema_vals[1] = temp_val[0]; else return;
   if(CopyBuffer(htf_ema3_handle, 0, 0, 1, temp_val) > 0) htf_ema_vals[2] = temp_val[0]; else return;
   if(CopyBuffer(htf_ema4_handle, 0, 0, 1, temp_val) > 0) htf_ema_vals[3] = temp_val[0]; else return;
   if(CopyBuffer(htf_ema5_handle, 0, 0, 1, temp_val) > 0) htf_ema_vals[4] = temp_val[0]; else return;
   if(CopyBuffer(htf_ema6_handle, 0, 0, 1, temp_val) > 0) htf_ema_vals[5] = temp_val[0]; else return;
   
   //--- Copy MTF EMA values
   if(CopyBuffer(mtf_ema1_handle, 0, 0, 1, temp_val) > 0) mtf_ema_vals[0] = temp_val[0]; else return;
   if(CopyBuffer(mtf_ema2_handle, 0, 0, 1, temp_val) > 0) mtf_ema_vals[1] = temp_val[0]; else return;
   if(CopyBuffer(mtf_ema3_handle, 0, 0, 1, temp_val) > 0) mtf_ema_vals[2] = temp_val[0]; else return;
   if(CopyBuffer(mtf_ema4_handle, 0, 0, 1, temp_val) > 0) mtf_ema_vals[3] = temp_val[0]; else return;
   if(CopyBuffer(mtf_ema5_handle, 0, 0, 1, temp_val) > 0) mtf_ema_vals[4] = temp_val[0]; else return;
   if(CopyBuffer(mtf_ema6_handle, 0, 0, 1, temp_val) > 0) mtf_ema_vals[5] = temp_val[0]; else return;
   
   //--- Copy ATR values
   if(CopyBuffer(mtf_atr_handle, 0, 0, 1, temp_val) > 0) mtf_atr = temp_val[0]; else return;
   
   double atr_ma_vals[];
   ArrayResize(atr_ma_vals, ATR_MA_Period);
   if(CopyBuffer(mtf_atr_handle, 0, 0, ATR_MA_Period, atr_ma_vals) <= 0) return;
   
   mtf_atr_ma = 0;
   for(int j = 0; j < ATR_MA_Period; j++)
      mtf_atr_ma += atr_ma_vals[j];
   mtf_atr_ma /= ATR_MA_Period;
   
   //--- Calculate alignments
   int htf_alignment = GetEMACloudAlignment(htf_ema_vals[0], htf_ema_vals[1], htf_ema_vals[2],
                                           htf_ema_vals[3], htf_ema_vals[4], htf_ema_vals[5]);
   
   int mtf_alignment = GetEMACloudAlignment(mtf_ema_vals[0], mtf_ema_vals[1], mtf_ema_vals[2],
                                           mtf_ema_vals[3], mtf_ema_vals[4], mtf_ema_vals[5]);
   
   bool atr_active = IsATRFilterActive(mtf_atr, mtf_atr_ma, ATR_Threshold_Multiplier);
   
   //--- Create/Update dashboard labels
   string htf_text = "HTF Bias: ";
   color htf_color = Color_Neutral;
   if(htf_alignment == 1)
   {
      htf_text += "BULLISH";
      htf_color = Color_Bullish;
   }
   else if(htf_alignment == -1)
   {
      htf_text += "BEARISH";
      htf_color = Color_Bearish;
   }
   else
   {
      htf_text += "NEUTRAL";
   }
   
   CreateLabel(dashboard_prefix + "HTF", x_pos, y_pos, htf_text, htf_color);
   
   string mtf_text = "MTF Trend: ";
   color mtf_color = Color_Neutral;
   if(mtf_alignment == 1 && htf_alignment == 1)
   {
      mtf_text += "ALIGNED (Bullish)";
      mtf_color = Color_Bullish;
   }
   else if(mtf_alignment == -1 && htf_alignment == -1)
   {
      mtf_text += "ALIGNED (Bearish)";
      mtf_color = Color_Bearish;
   }
   else
   {
      mtf_text += "NOT ALIGNED";
   }
   
   CreateLabel(dashboard_prefix + "MTF", x_pos, y_pos + line_height, mtf_text, mtf_color);
   
   string atr_text = "ATR Filter: ";
   color atr_color = Color_Neutral;
   if(atr_active)
   {
      atr_text += "ACTIVE";
      atr_color = Color_Bullish;
   }
   else
   {
      atr_text += "INACTIVE";
      atr_color = Color_Bearish;
   }
   
   CreateLabel(dashboard_prefix + "ATR", x_pos, y_pos + (line_height * 2), atr_text, atr_color);
   
   string atr_value_text = "ATR Value: " + DoubleToString(mtf_atr, _Digits);
   CreateLabel(dashboard_prefix + "ATR_VAL", x_pos, y_pos + (line_height * 3), atr_value_text, clrWhite);
   
   if(lastSignalTime > 0)
   {
      string signal_text = "Last Signal: ";
      color signal_color = Color_Neutral;
      if(lastSignalType == 1)
      {
         signal_text += "BUY @ " + TimeToString(lastSignalTime, TIME_MINUTES);
         signal_color = Color_Bullish;
      }
      else if(lastSignalType == -1)
      {
         signal_text += "SELL @ " + TimeToString(lastSignalTime, TIME_MINUTES);
         signal_color = Color_Bearish;
      }
      
      CreateLabel(dashboard_prefix + "SIGNAL", x_pos, y_pos + (line_height * 4), signal_text, signal_color);
   }
   
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Create or update text label                                      |
//+------------------------------------------------------------------+
void CreateLabel(string name, int x, int y, string text, color clr)
{
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 10);
      ObjectSetString(0, name, OBJPROP_FONT, "Arial");
   }
   
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
}

//+------------------------------------------------------------------+
//| Delete dashboard objects                                          |
//+------------------------------------------------------------------+
void DeleteDashboard()
{
   ObjectDelete(0, dashboard_prefix + "HTF");
   ObjectDelete(0, dashboard_prefix + "MTF");
   ObjectDelete(0, dashboard_prefix + "ATR");
   ObjectDelete(0, dashboard_prefix + "ATR_VAL");
   ObjectDelete(0, dashboard_prefix + "SIGNAL");
}

//+------------------------------------------------------------------+
//| Get low value from array                                         |
//+------------------------------------------------------------------+
double low[];

//+------------------------------------------------------------------+
//| Get high value from array                                        |
//+------------------------------------------------------------------+
double high[];
//+------------------------------------------------------------------+
