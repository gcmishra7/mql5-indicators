//+------------------------------------------------------------------+
//|                                         MTF_Strategy_Visual.mq5 |
//|                                                       gcmishra7  |
//|                                      https://github.com/gcmishra7 |
//+------------------------------------------------------------------+
#property copyright "gcmishra7"
#property link      "https://github.com/gcmishra7"
#property version   "1.00"
#property description "Multi-Timeframe Strategy Visual Indicator"
#property description "Displays EMA clouds, entry signals, and sideways market detection"
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_plots 0  // No visible plots, all drawing via objects

// Include custom libraries
#include <EMACloud.mqh>
#include <ATRFilter.mqh>
#include <SignalDetector.mqh>
#include <Dashboard.mqh>

//--- Input Parameters

//--- EMA Settings
input group "═══════ EMA Settings ═══════"
input int    EMA1_Period = 5;
input int    EMA2_Period = 8;
input int    EMA3_Period = 13;
input int    EMA4_Period = 21;
input int    EMA5_Period = 34;
input int    EMA6_Period = 55;
input double EMA_Convergence_Threshold = 0.5;  // EMA convergence % for sideways detection

//--- ATR Settings
input group "═══════ ATR Settings ═══════"
input int    ATR_Period = 14;
input int    ATR_MA_Period = 14;
input double ATR_Threshold = 1.0;  // ATR > ATR_MA * threshold for active filter
input double ATR_Sideways_Threshold = 0.8;  // ATR < ATR_MA * threshold for sideways

//--- Timeframes
input group "═══════ Timeframe Settings ═══════"
input ENUM_TIMEFRAMES HTF_Timeframe = PERIOD_H1;   // Higher Timeframe (Bias)
input ENUM_TIMEFRAMES MTF_Timeframe = PERIOD_M10;  // Medium Timeframe (Confirmation)
input ENUM_TIMEFRAMES LTF_Timeframe = PERIOD_M3;   // Lower Timeframe (Entry)

//--- Visual Settings
input group "═══════ Visual Settings ═══════"
input color  Bullish_Zone_Color = clrPaleGreen;
input color  Bearish_Zone_Color = clrMistyRose;
input color  Sideways_Zone_Color = clrLightGray;
input color  Buy_Signal_Color = clrLimeGreen;
input color  Sell_Signal_Color = clrCrimson;
input int    Zone_Transparency = 90;  // 0-255, higher = more transparent

//--- Signal Box Settings
input group "═══════ Signal Box Settings ═══════"
input int    Signal_Box_Height = 30;  // Height in pixels
input int    Signal_Box_Width = 60;   // Width in pixels

//--- Risk Management
input group "═══════ Risk Management ═══════"
input double TP1_Multiplier = 1.5;
input double TP2_Multiplier = 2.5;
input double TP3_Multiplier = 4.0;
input double SL_ATR_Multiplier = 1.5;

//--- Display Options
input group "═══════ Display Options ═══════"
input bool   Show_Dashboard = true;
input bool   Show_TP_Levels = true;
input bool   Show_EMA_Zones = true;
input bool   Show_Sideways_Zones = true;
input bool   Enable_Alerts = true;
input ENUM_BASE_CORNER Dashboard_Corner = CORNER_RIGHT_UPPER;
input int    Dashboard_X_Offset = 10;
input int    Dashboard_Y_Offset = 20;

//--- Indicator Buffers (for internal calculations)
double EMA5Buffer[];
double EMA8Buffer[];
double EMA13Buffer[];
double EMA21Buffer[];
double EMA34Buffer[];
double EMA55Buffer[];

//--- Indicator Handles
int ema5_handle, ema8_handle, ema13_handle, ema21_handle, ema34_handle, ema55_handle;

//--- Global Variables
datetime lastSignalTime = 0;
int lastSignalDirection = 0;
string lastSignalType = "NONE";

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    // Set indicator buffers
    SetIndexBuffer(0, EMA5Buffer, INDICATOR_CALCULATIONS);
    SetIndexBuffer(1, EMA8Buffer, INDICATOR_CALCULATIONS);
    SetIndexBuffer(2, EMA13Buffer, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, EMA21Buffer, INDICATOR_CALCULATIONS);
    SetIndexBuffer(4, EMA34Buffer, INDICATOR_CALCULATIONS);
    SetIndexBuffer(5, EMA55Buffer, INDICATOR_CALCULATIONS);
    
    // Set arrays as series
    ArraySetAsSeries(EMA5Buffer, true);
    ArraySetAsSeries(EMA8Buffer, true);
    ArraySetAsSeries(EMA13Buffer, true);
    ArraySetAsSeries(EMA21Buffer, true);
    ArraySetAsSeries(EMA34Buffer, true);
    ArraySetAsSeries(EMA55Buffer, true);
    
    // Create EMA indicator handles for current chart timeframe
    ema5_handle = iMA(_Symbol, PERIOD_CURRENT, EMA1_Period, 0, MODE_EMA, PRICE_CLOSE);
    ema8_handle = iMA(_Symbol, PERIOD_CURRENT, EMA2_Period, 0, MODE_EMA, PRICE_CLOSE);
    ema13_handle = iMA(_Symbol, PERIOD_CURRENT, EMA3_Period, 0, MODE_EMA, PRICE_CLOSE);
    ema21_handle = iMA(_Symbol, PERIOD_CURRENT, EMA4_Period, 0, MODE_EMA, PRICE_CLOSE);
    ema34_handle = iMA(_Symbol, PERIOD_CURRENT, EMA5_Period, 0, MODE_EMA, PRICE_CLOSE);
    ema55_handle = iMA(_Symbol, PERIOD_CURRENT, EMA6_Period, 0, MODE_EMA, PRICE_CLOSE);
    
    // Check if handles are valid
    if(ema5_handle == INVALID_HANDLE || ema8_handle == INVALID_HANDLE ||
       ema13_handle == INVALID_HANDLE || ema21_handle == INVALID_HANDLE ||
       ema34_handle == INVALID_HANDLE || ema55_handle == INVALID_HANDLE)
    {
        Print("Error creating EMA indicator handles");
        return(INIT_FAILED);
    }
    
    // Create dashboard if enabled
    if(Show_Dashboard)
    {
        CreateDashboard(Dashboard_Corner, Dashboard_X_Offset, Dashboard_Y_Offset);
    }
    
    Print("MTF Strategy Visual Indicator initialized successfully");
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Release indicator handles
    IndicatorRelease(ema5_handle);
    IndicatorRelease(ema8_handle);
    IndicatorRelease(ema13_handle);
    IndicatorRelease(ema21_handle);
    IndicatorRelease(ema34_handle);
    IndicatorRelease(ema55_handle);
    
    // Delete dashboard
    if(Show_Dashboard)
    {
        DeleteDashboard();
    }
    
    // Delete all indicator objects
    ClearAllObjects();
    
    Print("MTF Strategy Visual Indicator deinitialized");
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
    // Set arrays as series
    ArraySetAsSeries(time, true);
    ArraySetAsSeries(close, true);
    ArraySetAsSeries(high, true);
    ArraySetAsSeries(low, true);
    
    // Copy EMA data
    if(CopyBuffer(ema5_handle, 0, 0, rates_total, EMA5Buffer) <= 0) return(0);
    if(CopyBuffer(ema8_handle, 0, 0, rates_total, EMA8Buffer) <= 0) return(0);
    if(CopyBuffer(ema13_handle, 0, 0, rates_total, EMA13Buffer) <= 0) return(0);
    if(CopyBuffer(ema21_handle, 0, 0, rates_total, EMA21Buffer) <= 0) return(0);
    if(CopyBuffer(ema34_handle, 0, 0, rates_total, EMA34Buffer) <= 0) return(0);
    if(CopyBuffer(ema55_handle, 0, 0, rates_total, EMA55Buffer) <= 0) return(0);
    
    // Calculate only on new bar
    int limit = rates_total - prev_calculated;
    if(limit > 100) limit = 100;  // Limit processing for performance
    
    // Process recent bars
    for(int i = limit; i >= 0; i--)
    {
        if(i >= rates_total - 1) continue;
        
        // Draw EMA zones if enabled
        if(Show_EMA_Zones)
        {
            DrawEMAZones(i, time, high, low);
        }
        
        // Detect and draw sideways zones
        if(Show_Sideways_Zones)
        {
            DetectAndDrawSidewaysZone(i, time, high, low);
        }
    }
    
    // Check for new signals on the most recent bar
    if(rates_total > 0)
    {
        CheckAndDrawSignals(time[0], close[0]);
    }
    
    // Update dashboard
    if(Show_Dashboard)
    {
        UpdateDashboardInfo();
    }
    
    return(rates_total);
}

//+------------------------------------------------------------------+
//| Draw EMA cloud zones                                             |
//+------------------------------------------------------------------+
void DrawEMAZones(int shift, const datetime &time[], const double &high[], const double &low[])
{
    if(shift >= ArraySize(EMA5Buffer) - 1) return;
    
    // Determine zone color based on EMA alignment
    bool isBullish = IsEMABullish(EMA5Buffer[shift], EMA8Buffer[shift], EMA13Buffer[shift],
                                  EMA21Buffer[shift], EMA34Buffer[shift], EMA55Buffer[shift]);
    
    bool isBearish = IsEMABearish(EMA5Buffer[shift], EMA8Buffer[shift], EMA13Buffer[shift],
                                  EMA21Buffer[shift], EMA34Buffer[shift], EMA55Buffer[shift]);
    
    bool isSideways = !isBullish && !isBearish;
    
    color zoneColor;
    if(isBullish)
        zoneColor = Bullish_Zone_Color;
    else if(isBearish)
        zoneColor = Bearish_Zone_Color;
    else
        zoneColor = Sideways_Zone_Color;
    
    // Create rectangle for EMA cloud zone
    string zoneName = "MTF_Zone_" + IntegerToString(shift);
    
    // Get min and max EMA values for zone boundaries
    double maxEMA = MathMax(MathMax(MathMax(EMA5Buffer[shift], EMA8Buffer[shift]), 
                           MathMax(EMA13Buffer[shift], EMA21Buffer[shift])),
                           MathMax(EMA34Buffer[shift], EMA55Buffer[shift]));
    
    double minEMA = MathMin(MathMin(MathMin(EMA5Buffer[shift], EMA8Buffer[shift]), 
                           MathMin(EMA13Buffer[shift], EMA21Buffer[shift])),
                           MathMin(EMA34Buffer[shift], EMA55Buffer[shift]));
    
    // Create zone rectangle
    if(ObjectFind(0, zoneName) < 0)
    {
        ObjectCreate(0, zoneName, OBJ_RECTANGLE, 0, time[shift], minEMA, time[shift], maxEMA);
        ObjectSetInteger(0, zoneName, OBJPROP_COLOR, zoneColor);
        ObjectSetInteger(0, zoneName, OBJPROP_STYLE, STYLE_SOLID);
        ObjectSetInteger(0, zoneName, OBJPROP_WIDTH, 1);
        ObjectSetInteger(0, zoneName, OBJPROP_FILL, true);
        ObjectSetInteger(0, zoneName, OBJPROP_BACK, true);
        ObjectSetInteger(0, zoneName, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, zoneName, OBJPROP_SELECTED, false);
        ObjectSetInteger(0, zoneName, OBJPROP_HIDDEN, true);
    }
}

//+------------------------------------------------------------------+
//| Detect and draw sideways market zones                            |
//+------------------------------------------------------------------+
void DetectAndDrawSidewaysZone(int shift, const datetime &time[], const double &high[], const double &low[])
{
    if(shift >= ArraySize(EMA5Buffer) - 1) return;
    
    // Check if EMAs are converged
    bool emaConverged = IsEMAConverged(EMA5Buffer[shift], EMA55Buffer[shift], EMA_Convergence_Threshold);
    
    // Check if ATR is contracted
    bool atrContracted = IsATRContracted(_Symbol, PERIOD_CURRENT, ATR_Period, ATR_MA_Period, 
                                         ATR_Sideways_Threshold, shift);
    
    // If both conditions met, it's a sideways market
    if(emaConverged && atrContracted)
    {
        string sidewaysName = "MTF_Sideways_" + IntegerToString(shift);
        string sidewaysLabel = "MTF_Sideways_Label_" + IntegerToString(shift);
        
        // Create sideways zone rectangle
        if(ObjectFind(0, sidewaysName) < 0)
        {
            ObjectCreate(0, sidewaysName, OBJ_RECTANGLE, 0, time[shift], low[shift], time[shift], high[shift]);
            ObjectSetInteger(0, sidewaysName, OBJPROP_COLOR, clrMistyRose);
            ObjectSetInteger(0, sidewaysName, OBJPROP_STYLE, STYLE_SOLID);
            ObjectSetInteger(0, sidewaysName, OBJPROP_WIDTH, 1);
            ObjectSetInteger(0, sidewaysName, OBJPROP_FILL, true);
            ObjectSetInteger(0, sidewaysName, OBJPROP_BACK, true);
            ObjectSetInteger(0, sidewaysName, OBJPROP_SELECTABLE, false);
            
            // Add label
            ObjectCreate(0, sidewaysLabel, OBJ_TEXT, 0, time[shift], high[shift]);
            ObjectSetString(0, sidewaysLabel, OBJPROP_TEXT, "Sideways Market Signal");
            ObjectSetInteger(0, sidewaysLabel, OBJPROP_COLOR, clrDarkRed);
            ObjectSetInteger(0, sidewaysLabel, OBJPROP_FONTSIZE, 8);
            ObjectSetInteger(0, sidewaysLabel, OBJPROP_BACK, false);
        }
    }
}

//+------------------------------------------------------------------+
//| Check for signals and draw signal boxes                          |
//+------------------------------------------------------------------+
void CheckAndDrawSignals(datetime currentTime, double currentPrice)
{
    // Get EMA values for all timeframes
    double ema5_htf = GetEMAValue(HTF_Timeframe, EMA1_Period, 0);
    double ema8_htf = GetEMAValue(HTF_Timeframe, EMA2_Period, 0);
    double ema13_htf = GetEMAValue(HTF_Timeframe, EMA3_Period, 0);
    double ema21_htf = GetEMAValue(HTF_Timeframe, EMA4_Period, 0);
    double ema34_htf = GetEMAValue(HTF_Timeframe, EMA5_Period, 0);
    double ema55_htf = GetEMAValue(HTF_Timeframe, EMA6_Period, 0);
    
    double ema5_mtf = GetEMAValue(MTF_Timeframe, EMA1_Period, 0);
    double ema8_mtf = GetEMAValue(MTF_Timeframe, EMA2_Period, 0);
    double ema13_mtf = GetEMAValue(MTF_Timeframe, EMA3_Period, 0);
    double ema21_mtf = GetEMAValue(MTF_Timeframe, EMA4_Period, 0);
    double ema34_mtf = GetEMAValue(MTF_Timeframe, EMA5_Period, 0);
    double ema55_mtf = GetEMAValue(MTF_Timeframe, EMA6_Period, 0);
    
    double ema5_ltf = GetEMAValue(LTF_Timeframe, EMA1_Period, 0);
    double prevEma5_ltf = GetEMAValue(LTF_Timeframe, EMA1_Period, 1);
    
    // Get previous price for LTF
    MqlRates ltf_rates[];
    ArraySetAsSeries(ltf_rates, true);
    if(CopyRates(_Symbol, LTF_Timeframe, 0, 2, ltf_rates) < 2)
        return;
    
    double price_ltf = ltf_rates[0].close;
    double prevPrice_ltf = ltf_rates[1].close;
    
    // Detect signal
    SignalInfo signal = DetectSignal(_Symbol,
                                     HTF_Timeframe, MTF_Timeframe, LTF_Timeframe,
                                     ATR_Period, ATR_MA_Period, ATR_Threshold,
                                     ema5_htf, ema8_htf, ema13_htf, ema21_htf, ema34_htf, ema55_htf,
                                     ema5_mtf, ema8_mtf, ema13_mtf, ema21_mtf, ema34_mtf, ema55_mtf,
                                     price_ltf, prevPrice_ltf, ema5_ltf, prevEma5_ltf,
                                     TP1_Multiplier, TP2_Multiplier, TP3_Multiplier, SL_ATR_Multiplier);
    
    // If valid signal and not duplicate
    if(signal.isValid && signal.time != lastSignalTime)
    {
        lastSignalTime = signal.time;
        lastSignalDirection = signal.direction;
        lastSignalType = (signal.direction == 1) ? "BUY" : "SELL";
        
        // Draw signal box
        DrawSignalBox(signal.time, signal.entryPrice, (signal.direction == 1));
        
        // Draw TP/SL levels if enabled
        if(Show_TP_Levels)
        {
            DrawTPSLLevels(signal);
        }
        
        // Send alert if enabled
        if(Enable_Alerts)
        {
            string alertMsg = "MTF Strategy: " + lastSignalType + " Signal at " + 
                            DoubleToString(signal.entryPrice, _Digits);
            Alert(alertMsg);
        }
    }
}

//+------------------------------------------------------------------+
//| Get EMA value for specified timeframe                            |
//+------------------------------------------------------------------+
double GetEMAValue(ENUM_TIMEFRAMES tf, int period, int shift)
{
    double ema_array[];
    ArraySetAsSeries(ema_array, true);
    
    int handle = iMA(_Symbol, tf, period, 0, MODE_EMA, PRICE_CLOSE);
    if(handle == INVALID_HANDLE)
        return 0;
    
    if(CopyBuffer(handle, 0, shift, 1, ema_array) <= 0)
    {
        IndicatorRelease(handle);
        return 0;
    }
    
    IndicatorRelease(handle);
    return ema_array[0];
}

//+------------------------------------------------------------------+
//| Draw signal box (BUY or SELL)                                    |
//+------------------------------------------------------------------+
void DrawSignalBox(datetime signalTime, double price, bool isBuy)
{
    string boxName = "MTF_Signal_Box_" + TimeToString(signalTime);
    string textName = "MTF_Signal_Text_" + TimeToString(signalTime);
    
    color boxColor = isBuy ? Buy_Signal_Color : Sell_Signal_Color;
    string signalText = isBuy ? "BUY" : "SELL";
    
    // Calculate box dimensions
    datetime time2 = signalTime + Signal_Box_Width * PeriodSeconds(PERIOD_CURRENT);
    double priceRange = (Signal_Box_Height * _Point);
    double price2 = price + priceRange;
    
    // Create signal box
    if(ObjectFind(0, boxName) < 0)
    {
        ObjectCreate(0, boxName, OBJ_RECTANGLE, 0, signalTime, price, time2, price2);
        ObjectSetInteger(0, boxName, OBJPROP_COLOR, boxColor);
        ObjectSetInteger(0, boxName, OBJPROP_STYLE, STYLE_SOLID);
        ObjectSetInteger(0, boxName, OBJPROP_WIDTH, 2);
        ObjectSetInteger(0, boxName, OBJPROP_FILL, true);
        ObjectSetInteger(0, boxName, OBJPROP_BACK, false);
        ObjectSetInteger(0, boxName, OBJPROP_SELECTABLE, false);
    }
    
    // Create signal text
    if(ObjectFind(0, textName) < 0)
    {
        ObjectCreate(0, textName, OBJ_TEXT, 0, signalTime, price + priceRange/2);
        ObjectSetString(0, textName, OBJPROP_TEXT, signalText);
        ObjectSetInteger(0, textName, OBJPROP_COLOR, clrWhite);
        ObjectSetInteger(0, textName, OBJPROP_FONTSIZE, 9);
        ObjectSetString(0, textName, OBJPROP_FONT, "Arial Bold");
        ObjectSetInteger(0, textName, OBJPROP_BACK, false);
    }
}

//+------------------------------------------------------------------+
//| Draw TP and SL levels                                            |
//+------------------------------------------------------------------+
void DrawTPSLLevels(SignalInfo &signal)
{
    string prefix = "MTF_TP_" + TimeToString(signal.time) + "_";
    
    bool isLong = (signal.direction == 1);
    
    // Draw TP1
    DrawHorizontalLine(prefix + "TP1", signal.time, signal.tp1, clrLimeGreen, STYLE_DASH, 1);
    
    // Draw TP2
    DrawHorizontalLine(prefix + "TP2", signal.time, signal.tp2, clrLimeGreen, STYLE_DASH, 1);
    
    // Draw TP3
    DrawHorizontalLine(prefix + "TP3", signal.time, signal.tp3, clrLimeGreen, STYLE_DASH, 1);
    
    // Draw SL
    DrawHorizontalLine(prefix + "SL", signal.time, signal.stopLoss, clrRed, STYLE_DASH, 1);
}

//+------------------------------------------------------------------+
//| Draw horizontal line                                             |
//+------------------------------------------------------------------+
void DrawHorizontalLine(string name, datetime time, double price, color clr, ENUM_LINE_STYLE style, int width)
{
    if(ObjectFind(0, name) < 0)
    {
        datetime time2 = time + 20 * PeriodSeconds(PERIOD_CURRENT);
        ObjectCreate(0, name, OBJ_TREND, 0, time, price, time2, price);
        ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
        ObjectSetInteger(0, name, OBJPROP_STYLE, style);
        ObjectSetInteger(0, name, OBJPROP_WIDTH, width);
        ObjectSetInteger(0, name, OBJPROP_BACK, false);
        ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, name, OBJPROP_RAY_RIGHT, true);
    }
}

//+------------------------------------------------------------------+
//| Update dashboard information                                     |
//+------------------------------------------------------------------+
void UpdateDashboardInfo()
{
    // Get current ATR
    double atr = CalculateATR(_Symbol, PERIOD_CURRENT, ATR_Period, 0);
    double atr_ma = CalculateATR_MA(_Symbol, PERIOD_CURRENT, ATR_Period, ATR_MA_Period, 0);
    
    // Determine volatility status
    string volatility = "Normal";
    if(atr > atr_ma * 1.2)
        volatility = "High";
    else if(atr < atr_ma * 0.8)
        volatility = "Low";
    
    // Get HTF bias
    double ema5_htf = GetEMAValue(HTF_Timeframe, EMA1_Period, 0);
    double ema8_htf = GetEMAValue(HTF_Timeframe, EMA2_Period, 0);
    double ema13_htf = GetEMAValue(HTF_Timeframe, EMA3_Period, 0);
    double ema21_htf = GetEMAValue(HTF_Timeframe, EMA4_Period, 0);
    double ema34_htf = GetEMAValue(HTF_Timeframe, EMA5_Period, 0);
    double ema55_htf = GetEMAValue(HTF_Timeframe, EMA6_Period, 0);
    
    bool htfBullish = IsEMABullish(ema5_htf, ema8_htf, ema13_htf, ema21_htf, ema34_htf, ema55_htf);
    bool htfBearish = IsEMABearish(ema5_htf, ema8_htf, ema13_htf, ema21_htf, ema34_htf, ema55_htf);
    
    string htfBias = "Sideways";
    if(htfBullish) htfBias = "Bullish";
    else if(htfBearish) htfBias = "Bearish";
    
    // Get MTF status
    double ema5_mtf = GetEMAValue(MTF_Timeframe, EMA1_Period, 0);
    double ema8_mtf = GetEMAValue(MTF_Timeframe, EMA2_Period, 0);
    double ema13_mtf = GetEMAValue(MTF_Timeframe, EMA3_Period, 0);
    double ema21_mtf = GetEMAValue(MTF_Timeframe, EMA4_Period, 0);
    double ema34_mtf = GetEMAValue(MTF_Timeframe, EMA5_Period, 0);
    double ema55_mtf = GetEMAValue(MTF_Timeframe, EMA6_Period, 0);
    
    bool mtfBullish = IsEMABullish(ema5_mtf, ema8_mtf, ema13_mtf, ema21_mtf, ema34_mtf, ema55_mtf);
    bool mtfBearish = IsEMABearish(ema5_mtf, ema8_mtf, ema13_mtf, ema21_mtf, ema34_mtf, ema55_mtf);
    
    string mtfStatus = "Sideways";
    if(mtfBullish) mtfStatus = "Bullish";
    else if(mtfBearish) mtfStatus = "Bearish";
    
    // Determine overall status
    string status = "Active";
    bool atrActive = IsATRActive(_Symbol, MTF_Timeframe, ATR_Period, ATR_MA_Period, ATR_Threshold, 0);
    if(!atrActive)
        status = "Waiting";
    
    // Format last signal time
    string lastTime = "--";
    if(lastSignalTime > 0)
    {
        MqlDateTime dt;
        TimeToStruct(lastSignalTime, dt);
        lastTime = StringFormat("%02d:%02d", dt.hour, dt.min);
    }
    
    // Determine signal color
    color signalColor = clrWhite;
    if(lastSignalType == "BUY")
        signalColor = clrLimeGreen;
    else if(lastSignalType == "SELL")
        signalColor = clrCrimson;
    
    // Update dashboard
    UpdateDashboard(status, atr, volatility, htfBias, mtfStatus, "Entry", 
                    lastSignalType, lastTime, signalColor);
}

//+------------------------------------------------------------------+
//| Clear all indicator objects                                      |
//+------------------------------------------------------------------+
void ClearAllObjects()
{
    int total = ObjectsTotal(0);
    for(int i = total - 1; i >= 0; i--)
    {
        string name = ObjectName(0, i);
        if(StringFind(name, "MTF_") == 0)
        {
            ObjectDelete(0, name);
        }
    }
}
//+------------------------------------------------------------------+
