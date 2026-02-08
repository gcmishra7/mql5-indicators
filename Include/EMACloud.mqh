//+------------------------------------------------------------------+
//|                                                     EMACloud.mqh |
//|                                                       gcmishra7  |
//|                                      https://github.com/gcmishra7 |
//+------------------------------------------------------------------+
#property copyright "gcmishra7"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Check if all EMAs are in bullish alignment                       |
//| Returns true if EMAs are ordered: 5>8>13>21>34>55               |
//+------------------------------------------------------------------+
bool IsEMABullish(double ema5, double ema8, double ema13, double ema21, double ema34, double ema55)
{
    return (ema5 > ema8 && ema8 > ema13 && ema13 > ema21 && ema21 > ema34 && ema34 > ema55);
}

//+------------------------------------------------------------------+
//| Check if all EMAs are in bearish alignment                       |
//| Returns true if EMAs are ordered: 5<8<13<21<34<55               |
//+------------------------------------------------------------------+
bool IsEMABearish(double ema5, double ema8, double ema13, double ema21, double ema34, double ema55)
{
    return (ema5 < ema8 && ema8 < ema13 && ema13 < ema21 && ema21 < ema34 && ema34 < ema55);
}

//+------------------------------------------------------------------+
//| Check if EMAs are converged (sideways market)                    |
//| Compares the range between fastest and slowest EMA               |
//| threshold: percentage threshold (e.g., 0.5 for 0.5%)            |
//+------------------------------------------------------------------+
bool IsEMAConverged(double ema5, double ema55, double threshold)
{
    double range = MathAbs(ema5 - ema55);
    double avgPrice = (ema5 + ema55) / 2.0;
    
    // Avoid division by zero
    if(avgPrice == 0)
        return false;
    
    double percentRange = (range / avgPrice) * 100.0;
    
    return (percentRange < threshold);  // threshold in percentage, e.g., 0.5%
}

//+------------------------------------------------------------------+
//| Get EMA cloud strength (0-100)                                   |
//| Measures the spacing between EMAs - higher = stronger trend      |
//+------------------------------------------------------------------+
double GetEMAStrength(double ema5, double ema8, double ema13, double ema21, double ema34, double ema55)
{
    double spacing = 0;
    spacing += MathAbs(ema5 - ema8);
    spacing += MathAbs(ema8 - ema13);
    spacing += MathAbs(ema13 - ema21);
    spacing += MathAbs(ema21 - ema34);
    spacing += MathAbs(ema34 - ema55);
    
    // Normalize to 0-100 (implementation depends on symbol characteristics)
    // Adjust multiplier as needed based on the price scale of the symbol
    double strength = MathMin(spacing * 10000.0, 100.0);
    
    return strength;
}

//+------------------------------------------------------------------+
//| Detect EMA cloud break                                           |
//| price: current price, prevPrice: previous price                  |
//| ema5: current EMA5, prevEma5: previous EMA5                     |
//| checkBullish: true for bullish break, false for bearish break   |
//+------------------------------------------------------------------+
bool DetectCloudBreak(double price, double prevPrice, double ema5, double prevEma5, bool checkBullish)
{
    if(checkBullish)
    {
        // Bullish break: price crosses above EMA5 from below
        return (prevPrice <= prevEma5 && price > ema5);
    }
    else
    {
        // Bearish break: price crosses below EMA5 from above
        return (prevPrice >= prevEma5 && price < ema5);
    }
}
//+------------------------------------------------------------------+
