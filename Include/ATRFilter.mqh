//+------------------------------------------------------------------+
//|                                                    ATRFilter.mqh |
//|                                                       gcmishra7  |
//|                                      https://github.com/gcmishra7 |
//+------------------------------------------------------------------+
#property copyright "gcmishra7"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Calculate ATR for any timeframe                                  |
//| Uses MQL5's built-in iATR function                              |
//+------------------------------------------------------------------+
double CalculateATR(string symbol, ENUM_TIMEFRAMES timeframe, int period, int shift)
{
    double atr_array[];
    ArraySetAsSeries(atr_array, true);
    
    int atr_handle = iATR(symbol, timeframe, period);
    if(atr_handle == INVALID_HANDLE)
    {
        Print("Error creating ATR indicator handle: ", GetLastError());
        return 0;
    }
    
    if(CopyBuffer(atr_handle, 0, shift, 1, atr_array) <= 0)
    {
        Print("Error copying ATR buffer: ", GetLastError());
        IndicatorRelease(atr_handle);
        return 0;
    }
    
    IndicatorRelease(atr_handle);
    return atr_array[0];
}

//+------------------------------------------------------------------+
//| Calculate Simple Moving Average of ATR values                    |
//| Computes average of ATR over maPeriod bars                      |
//+------------------------------------------------------------------+
double CalculateATR_MA(string symbol, ENUM_TIMEFRAMES timeframe, int atrPeriod, int maPeriod, int shift)
{
    double atr_array[];
    ArraySetAsSeries(atr_array, true);
    
    int atr_handle = iATR(symbol, timeframe, atrPeriod);
    if(atr_handle == INVALID_HANDLE)
    {
        Print("Error creating ATR indicator handle for MA: ", GetLastError());
        return 0;
    }
    
    // Copy enough data to calculate MA
    if(CopyBuffer(atr_handle, 0, shift, maPeriod, atr_array) <= 0)
    {
        Print("Error copying ATR buffer for MA: ", GetLastError());
        IndicatorRelease(atr_handle);
        return 0;
    }
    
    // Calculate simple average
    double sum = 0;
    for(int i = 0; i < maPeriod; i++)
    {
        sum += atr_array[i];
    }
    
    IndicatorRelease(atr_handle);
    return sum / maPeriod;
}

//+------------------------------------------------------------------+
//| Check if ATR filter allows trading                               |
//| Returns true if ATR > ATR_MA * threshold                        |
//+------------------------------------------------------------------+
bool IsATRActive(string symbol, ENUM_TIMEFRAMES timeframe, int atrPeriod, int maPeriod, double threshold, int shift)
{
    double atr = CalculateATR(symbol, timeframe, atrPeriod, shift);
    double atr_ma = CalculateATR_MA(symbol, timeframe, atrPeriod, maPeriod, shift);
    
    if(atr_ma == 0)
        return false;
    
    return (atr > atr_ma * threshold);
}

//+------------------------------------------------------------------+
//| Check if market is in sideways mode (ATR contraction)            |
//| Returns true if ATR < ATR_MA * threshold                        |
//+------------------------------------------------------------------+
bool IsATRContracted(string symbol, ENUM_TIMEFRAMES timeframe, int atrPeriod, int maPeriod, double threshold, int shift)
{
    double atr = CalculateATR(symbol, timeframe, atrPeriod, shift);
    double atr_ma = CalculateATR_MA(symbol, timeframe, atrPeriod, maPeriod, shift);
    
    if(atr_ma == 0)
        return false;
    
    return (atr < atr_ma * threshold);
}

//+------------------------------------------------------------------+
//| Get ATR trend: 1=expanding, -1=contracting, 0=stable            |
//| Compares current ATR with previous ATR                          |
//+------------------------------------------------------------------+
int GetATRTrend(string symbol, ENUM_TIMEFRAMES timeframe, int atrPeriod, int shift)
{
    double atr_current = CalculateATR(symbol, timeframe, atrPeriod, shift);
    double atr_previous = CalculateATR(symbol, timeframe, atrPeriod, shift + 1);
    
    if(atr_previous == 0)
        return 0;
    
    if(atr_current > atr_previous * 1.05)  // 5% increase
        return 1;
    else if(atr_current < atr_previous * 0.95)  // 5% decrease
        return -1;
    else
        return 0;
}

//+------------------------------------------------------------------+
//| Calculate stop loss distance based on ATR                        |
//| Returns distance in price units (not points)                     |
//+------------------------------------------------------------------+
double GetATRStopDistance(string symbol, ENUM_TIMEFRAMES timeframe, int atrPeriod, double multiplier, int shift)
{
    double atr = CalculateATR(symbol, timeframe, atrPeriod, shift);
    return atr * multiplier;
}
//+------------------------------------------------------------------+
