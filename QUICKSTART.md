# Quick Start Guide

Get started with MTF Strategy Visual Indicator in 5 minutes!

## 🚀 Quick Setup

### 1. Install (2 minutes)

1. Download repository → Extract files
2. Copy files to MT5 data folder:
   - `Indicators/MTF_Strategy_Visual.mq5` → `MQL5/Indicators/`
   - All `Include/*.mqh` files → `MQL5/Include/`
3. Open MetaEditor (F4) → Compile (F7)
4. Add to chart from Navigator panel

📖 **Detailed instructions**: See [INSTALLATION.md](INSTALLATION.md)

### 2. First Run (1 minute)

**Recommended Settings for Beginners:**

Open any liquid pair (EURUSD, BTCUSD, GBPUSD) on M5 or M15 chart.

Use **Default Settings** first:
```
EMA Periods: 5, 8, 13, 21, 34, 55 ✓
ATR Period: 14 ✓
Timeframes: H1/M10/M3 ✓
All Display Options: Enabled ✓
```

Click OK → Wait 5-10 seconds for indicator to load.

### 3. Understanding the Display (2 minutes)

After loading, you'll see:

#### ① Background Colors (EMA Zones)
- 🟢 **Green** = Bullish trend (all EMAs aligned upward)
- 🔴 **Red** = Bearish trend (all EMAs aligned downward)
- ⚪ **Gray** = Sideways (EMAs tangled/converged)

#### ② Signal Boxes
- 🟩 **Green Box with "BUY"** = Long entry signal
- 🟥 **Red Box with "SELL"** = Short entry signal

#### ③ Dashboard (Top-Right Corner)
```
MTF Strategy
─────────────────
Status: Active      ← Trading conditions OK
ATR: 0.00045       ← Current volatility
Volatility: Normal ← Market state
HTF: Bullish       ← H1 trend direction
MTF: Bullish       ← M10 confirmation
LTF: Entry         ← M3 entry trigger
Signal: BUY        ← Last signal type
Time: 14:35        ← When it occurred
```

#### ④ TP/SL Lines (When Signal Occurs)
- Green dashed lines = Take Profit levels (TP1, TP2, TP3)
- Red dashed line = Stop Loss level

## 📊 Reading Signals

### BUY Signal Appears When:
1. ✅ HTF (H1) shows bullish trend
2. ✅ MTF (M10) confirms bullish + ATR is active
3. ✅ LTF (M3) price breaks above EMA cloud
4. 🟩 **Green box appears at entry price**

### SELL Signal Appears When:
1. ✅ HTF (H1) shows bearish trend
2. ✅ MTF (M10) confirms bearish + ATR is active
3. ✅ LTF (M3) price breaks below EMA cloud
4. 🟥 **Red box appears at entry price**

### No Signal Appears When:
1. ⚪ Gray zones = Market is sideways (too choppy to trade)
2. ⚠️ Dashboard shows "Status: Waiting" = ATR too low
3. ❌ Timeframes don't align = Need HTF/MTF agreement

## 🎯 Taking Your First Trade (Example)

### Scenario: BUY Signal

1. **Green box appears** at price 1.0950
2. Dashboard shows:
   - Status: Active ✓
   - HTF: Bullish ✓
   - MTF: Bullish ✓
   - Signal: BUY ✓

3. **Entry**: Place buy order at 1.0950 (signal price)

4. **TP Levels** (3 options):
   - TP1: 1.0965 (quick profit, 1.5x ATR)
   - TP2: 1.0975 (medium profit, 2.5x ATR)
   - TP3: 1.0990 (big profit, 4.0x ATR)

5. **Stop Loss**: 1.0935 (1.5x ATR below entry)

6. **Trade Management**:
   - **Conservative**: Exit at TP1 (full position)
   - **Moderate**: Exit 50% at TP1, 50% at TP2
   - **Aggressive**: Exit 33% at each TP level

## ⚙️ Adjusting for Your Trading Style

### For Scalping (Quick Trades)
```
HTF: H1
MTF: M15
LTF: M1
Chart: M1 or M5
ATR Threshold: 1.2 (stricter)
```

### For Day Trading (Intraday)
```
HTF: H4
MTF: H1
LTF: M15
Chart: M15 or M30
ATR Threshold: 1.0 (default)
```

### For Swing Trading (Hold Days)
```
HTF: D1
MTF: H4
LTF: H1
Chart: H1 or H4
ATR Threshold: 0.9 (more relaxed)
```

## 🔧 Common Adjustments

### Too Many Signals?
```
Increase ATR Threshold: 1.0 → 1.2
Use higher LTF: M3 → M5 → M10
```

### Too Few Signals?
```
Decrease ATR Threshold: 1.0 → 0.8
Use lower LTF: M10 → M5 → M3
Enable on trending pairs (GBPJPY, GBPUSD)
```

### Dashboard Too Small?
```
Right-click indicator → Properties
Dashboard: Increase font sizes (9 → 11)
Or use labels separately for key metrics
```

### Too Many Objects on Chart?
```
Disable:
- Show_EMA_Zones = false (removes backgrounds)
- Show_TP_Levels = false (removes TP/SL lines)
Keep only: Dashboard + Signal Boxes
```

## ⚠️ Important Tips

### ✅ DO:
- ✅ Wait for full candle close before entering
- ✅ Check higher timeframe trend before trading
- ✅ Use proper risk management (1-2% per trade)
- ✅ Test on demo account first
- ✅ Combine with support/resistance levels

### ❌ DON'T:
- ❌ Trade every signal blindly
- ❌ Ignore "Sideways Market" warnings
- ❌ Trade when dashboard shows "Waiting"
- ❌ Use on illiquid or exotic pairs
- ❌ Overtrade - be patient for quality setups

## 📈 Next Steps

1. **Practice**: Run on demo for 1-2 weeks
2. **Optimize**: Adjust settings for your symbols
3. **Backtest**: Review historical signals on chart
4. **Refine**: Find your preferred TP exit strategy
5. **Go Live**: Start with small position sizes

## 📚 Learn More

- **Full Documentation**: [README.md](README.md)
- **Installation Help**: [INSTALLATION.md](INSTALLATION.md)
- **Updates**: [CHANGELOG.md](CHANGELOG.md)
- **Troubleshooting**: See README.md troubleshooting section

## 🆘 Need Help?

**Indicator not working?**
1. Check: `Indicators/MTF_Strategy_Visual.mq5` compiled successfully
2. Check: All `.mqh` files in `MQL5/Include/`
3. Check: MT5 build 3802+ (`Help → About`)
4. See: [INSTALLATION.md](INSTALLATION.md) troubleshooting section

**Still stuck?**
- GitHub Issues: https://github.com/gcmishra7/mql5-indicators/issues
- Include: MT5 version, error message, screenshot

---

**Ready to trade smarter?** 🎯

Good luck and happy trading! 📈

*Remember: This is a tool to assist your trading, not a guaranteed profit system. Always manage your risk properly.*
