//+------------------------------------------------------------------+
//|                                                     EMACloud.mqh |
//|                                    Copyright 2026, gcmishra7     |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, gcmishra7"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| EMA Cloud Helper Functions                                        |
//| Purpose: Calculations and analysis for EMA cloud trading         |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Check EMA cloud alignment                                         |
//| Returns: 1 for bullish, -1 for bearish, 0 for neutral           |
//| Parameters:                                                       |
//|   ema1-ema6 - EMA values in ascending period order (5,8,13,21,34,55)|
//+------------------------------------------------------------------+
int GetEMACloudAlignment(double ema1, double ema2, double ema3, 
                         double ema4, double ema5, double ema6)
{
   // Check for invalid data
   if(ema1 <= 0 || ema2 <= 0 || ema3 <= 0 || 
      ema4 <= 0 || ema5 <= 0 || ema6 <= 0)
      return 0;
   
   // Bullish alignment: EMAs in ascending order (shorter > longer)
   // 5 > 8 > 13 > 21 > 34 > 55
   bool bullish = (ema1 > ema2) && (ema2 > ema3) && 
                  (ema3 > ema4) && (ema4 > ema5) && 
                  (ema5 > ema6);
   
   // Bearish alignment: EMAs in descending order (shorter < longer)
   // 5 < 8 < 13 < 21 < 34 < 55
   bool bearish = (ema1 < ema2) && (ema2 < ema3) && 
                  (ema3 < ema4) && (ema4 < ema5) && 
                  (ema5 < ema6);
   
   if(bullish)
      return 1;
   else if(bearish)
      return -1;
   else
      return 0;
}

//+------------------------------------------------------------------+
//| Check if EMA cloud has quality spacing (avoid choppy conditions) |
//| Returns: true if spacing is adequate, false otherwise            |
//| Parameters:                                                       |
//|   ema1-ema6 - EMA values in ascending period order               |
//|   minSpacing - minimum spacing between EMAs (in points)          |
//+------------------------------------------------------------------+
bool IsEMACloudQuality(double ema1, double ema2, double ema3, 
                       double ema4, double ema5, double ema6, 
                       double minSpacing)
{
   // Check for invalid data
   if(ema1 <= 0 || ema2 <= 0 || ema3 <= 0 || 
      ema4 <= 0 || ema5 <= 0 || ema6 <= 0)
      return false;
   
   // Check minimum spacing between consecutive EMAs
   double spacing1 = MathAbs(ema1 - ema2);
   double spacing2 = MathAbs(ema2 - ema3);
   double spacing3 = MathAbs(ema3 - ema4);
   double spacing4 = MathAbs(ema4 - ema5);
   double spacing5 = MathAbs(ema5 - ema6);
   
   // Average spacing across all EMA pairs
   double avgSpacing = (spacing1 + spacing2 + spacing3 + spacing4 + spacing5) / 5.0;
   
   // Quality check: average spacing should meet minimum threshold
   return (avgSpacing >= minSpacing);
}

//+------------------------------------------------------------------+
//| Detect EMA cloud break by price                                  |
//| Returns: true if price breaks through cloud, false otherwise     |
//| Parameters:                                                       |
//|   price - current price to check                                 |
//|   ema1-ema3 - Fast EMAs to check for break                      |
//|   isBullish - direction to check (true=bullish break)           |
//+------------------------------------------------------------------+
bool DetectEMACloudBreak(double price, double ema1, double ema2, 
                         double ema3, bool isBullish)
{
   // Check for invalid data
   if(price <= 0 || ema1 <= 0 || ema2 <= 0 || ema3 <= 0)
      return false;
   
   if(isBullish)
   {
      // Bullish break: price crosses above fast EMAs
      return (price > ema1 && price > ema2 && price > ema3);
   }
   else
   {
      // Bearish break: price crosses below fast EMAs
      return (price < ema1 && price < ema2 && price < ema3);
   }
}

//+------------------------------------------------------------------+
//| Calculate EMA cloud trend strength                               |
//| Returns: Strength value (0-100, higher = stronger trend)         |
//| Parameters:                                                       |
//|   ema1-ema6 - EMA values in ascending period order               |
//+------------------------------------------------------------------+
double GetEMACloudStrength(double ema1, double ema2, double ema3, 
                           double ema4, double ema5, double ema6)
{
   // Check for invalid data
   if(ema1 <= 0 || ema2 <= 0 || ema3 <= 0 || 
      ema4 <= 0 || ema5 <= 0 || ema6 <= 0)
      return 0.0;
   
   // Calculate relative spacing between EMAs
   double range = MathAbs(ema1 - ema6); // Total spread
   double avgEMA = (ema1 + ema2 + ema3 + ema4 + ema5 + ema6) / 6.0;
   
   // Strength based on relative spread (normalized to percentage)
   double strength = 0.0;
   if(avgEMA > 0)
   {
      strength = (range / avgEMA) * 100.0;
   }
   
   // Clamp to 0-100 range
   if(strength > 100.0)
      strength = 100.0;
   if(strength < 0.0)
      strength = 0.0;
   
   return strength;
}

//+------------------------------------------------------------------+
