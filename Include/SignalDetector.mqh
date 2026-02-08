//+------------------------------------------------------------------+
//|                                               SignalDetector.mqh |
//|                                                       gcmishra7  |
//|                                      https://github.com/gcmishra7 |
//+------------------------------------------------------------------+
#property copyright "gcmishra7"
#property version   "1.00"
#property strict

#include "EMACloud.mqh"
#include "ATRFilter.mqh"

//+------------------------------------------------------------------+
//| Structure to hold signal information                             |
//+------------------------------------------------------------------+
struct SignalInfo
{
    bool isValid;           // Whether signal is valid
    int direction;          // 1=long, -1=short, 0=none
    double entryPrice;      // Entry price for the signal
    double stopLoss;        // Stop loss level
    double tp1;             // Take profit level 1
    double tp2;             // Take profit level 2
    double tp3;             // Take profit level 3
    datetime time;          // Signal time
};

//+------------------------------------------------------------------+
//| Detect complete trading signal                                   |
//| Analyzes HTF, MTF, and LTF to generate trade signals            |
//+------------------------------------------------------------------+
SignalInfo DetectSignal(string symbol, 
                        ENUM_TIMEFRAMES htf, ENUM_TIMEFRAMES mtf, ENUM_TIMEFRAMES ltf,
                        int atrPeriod, int atrMAPeriod, double atrThreshold,
                        double ema5_htf, double ema8_htf, double ema13_htf, 
                        double ema21_htf, double ema34_htf, double ema55_htf,
                        double ema5_mtf, double ema8_mtf, double ema13_mtf,
                        double ema21_mtf, double ema34_mtf, double ema55_mtf,
                        double price_ltf, double prevPrice_ltf, 
                        double ema5_ltf, double prevEma5_ltf,
                        double tp1Mult, double tp2Mult, double tp3Mult, double slMult)
{
    SignalInfo signal;
    signal.isValid = false;
    signal.direction = 0;
    signal.entryPrice = 0;
    signal.stopLoss = 0;
    signal.tp1 = 0;
    signal.tp2 = 0;
    signal.tp3 = 0;
    signal.time = 0;
    
    // Step 1: Check HTF bias
    bool htfBullish = IsEMABullish(ema5_htf, ema8_htf, ema13_htf, ema21_htf, ema34_htf, ema55_htf);
    bool htfBearish = IsEMABearish(ema5_htf, ema8_htf, ema13_htf, ema21_htf, ema34_htf, ema55_htf);
    
    if(!htfBullish && !htfBearish)
        return signal;  // HTF sideways, no trading
    
    // Step 2: Check MTF alignment
    bool mtfBullish = IsEMABullish(ema5_mtf, ema8_mtf, ema13_mtf, ema21_mtf, ema34_mtf, ema55_mtf);
    bool mtfBearish = IsEMABearish(ema5_mtf, ema8_mtf, ema13_mtf, ema21_mtf, ema34_mtf, ema55_mtf);
    
    if(htfBullish && !mtfBullish)
        return signal;  // MTF not aligned with HTF bullish
    if(htfBearish && !mtfBearish)
        return signal;  // MTF not aligned with HTF bearish
    
    // Step 3: Check ATR filter
    if(!IsATRActive(symbol, mtf, atrPeriod, atrMAPeriod, atrThreshold, 0))
        return signal;  // Insufficient volatility
    
    // Step 4: Check LTF entry trigger
    bool bullishBreak = DetectCloudBreak(price_ltf, prevPrice_ltf, ema5_ltf, prevEma5_ltf, true);
    bool bearishBreak = DetectCloudBreak(price_ltf, prevPrice_ltf, ema5_ltf, prevEma5_ltf, false);
    
    if(htfBullish && mtfBullish && bullishBreak)
    {
        signal.direction = 1;  // Long signal
    }
    else if(htfBearish && mtfBearish && bearishBreak)
    {
        signal.direction = -1;  // Short signal
    }
    else
    {
        return signal;  // No entry trigger
    }
    
    // Signal is valid, calculate levels
    signal.isValid = true;
    signal.entryPrice = price_ltf;
    
    // Get current time for LTF
    MqlRates rates[];
    ArraySetAsSeries(rates, true);
    if(CopyRates(symbol, ltf, 0, 1, rates) > 0)
    {
        signal.time = rates[0].time;
    }
    
    double atr = CalculateATR(symbol, ltf, atrPeriod, 0);
    
    if(signal.direction == 1)  // Long
    {
        signal.stopLoss = signal.entryPrice - (atr * slMult);
        signal.tp1 = signal.entryPrice + (atr * tp1Mult);
        signal.tp2 = signal.entryPrice + (atr * tp2Mult);
        signal.tp3 = signal.entryPrice + (atr * tp3Mult);
    }
    else  // Short
    {
        signal.stopLoss = signal.entryPrice + (atr * slMult);
        signal.tp1 = signal.entryPrice - (atr * tp1Mult);
        signal.tp2 = signal.entryPrice - (atr * tp2Mult);
        signal.tp3 = signal.entryPrice - (atr * tp3Mult);
    }
    
    return signal;
}
//+------------------------------------------------------------------+
