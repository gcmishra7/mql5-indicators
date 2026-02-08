//+------------------------------------------------------------------+
//|                                                    ATRFilter.mqh |
//|                                    Copyright 2026, gcmishra7     |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, gcmishra7"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| ATR Volatility Filter Functions                                  |
//| Purpose: ATR-based volatility filtering for trading signals      |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Check if ATR filter is active (sufficient volatility)            |
//| Returns: true if volatility is sufficient, false otherwise       |
//| Parameters:                                                       |
//|   atr - current ATR value                                        |
//|   atr_ma - ATR moving average value                             |
//|   threshold - multiplier threshold (e.g., 1.0 = ATR >= ATR_MA)  |
//+------------------------------------------------------------------+
bool IsATRFilterActive(double atr, double atr_ma, double threshold)
{
   // Check for invalid data
   if(atr <= 0 || atr_ma <= 0 || threshold <= 0)
      return false;
   
   // ATR filter is active when current ATR exceeds threshold
   // threshold = 1.0 means ATR must be >= ATR_MA
   // threshold = 1.5 means ATR must be >= 1.5 * ATR_MA
   return (atr >= (atr_ma * threshold));
}

//+------------------------------------------------------------------+
//| Get ATR-based stop loss distance                                 |
//| Returns: Stop loss distance in price units                       |
//| Parameters:                                                       |
//|   atr - current ATR value                                        |
//|   multiplier - ATR multiplier for stop distance (e.g., 2.0)     |
//+------------------------------------------------------------------+
double GetATRStopDistance(double atr, double multiplier)
{
   // Check for invalid data
   if(atr <= 0 || multiplier <= 0)
      return 0.0;
   
   // Stop loss distance = ATR * multiplier
   return (atr * multiplier);
}

//+------------------------------------------------------------------+
//| Check ATR trend (expansion/contraction)                          |
//| Returns: 1 for expanding, -1 for contracting, 0 for neutral     |
//| Parameters:                                                       |
//|   atr - current ATR value                                        |
//|   atr_ma - ATR moving average value                             |
//+------------------------------------------------------------------+
int GetATRTrend(double atr, double atr_ma)
{
   // Check for invalid data
   if(atr <= 0 || atr_ma <= 0)
      return 0;
   
   // Calculate the ratio
   double ratio = atr / atr_ma;
   
   // Expansion: ATR significantly above MA (>5% above)
   if(ratio > 1.05)
      return 1;
   
   // Contraction: ATR significantly below MA (>5% below)
   if(ratio < 0.95)
      return -1;
   
   // Neutral: ATR close to MA
   return 0;
}

//+------------------------------------------------------------------+
