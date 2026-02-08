# MQL5 Indicators

Collection of custom MQL5 indicators for multi-timeframe trading strategies.

## 📊 Multi-Timeframe Strategy Visual Indicator

A professional MQL5 indicator that provides comprehensive multi-timeframe analysis with clean visual design. The indicator helps traders identify high-probability trade setups by analyzing EMA cloud alignments across different timeframes combined with ATR-based volatility filtering.

### ✨ Features

- **EMA Cloud Zones**: Visual background zones showing market bias
  - Bullish zones (pale green) when EMAs are aligned upward
  - Bearish zones (misty rose) when EMAs are aligned downward
  - Sideways zones (light gray) when EMAs are converged
  
- **Multi-Timeframe Analysis**:
  - Higher Timeframe (HTF): Determines overall market bias
  - Medium Timeframe (MTF): Confirms HTF direction with ATR filter
  - Lower Timeframe (LTF): Triggers precise entry signals

- **Entry Signal Boxes**:
  - Green boxes with "BUY" text for long entries
  - Red boxes with "SELL" text for short entries
  - Positioned at exact entry price levels

- **Sideways Market Detection**:
  - Automatically detects low volatility periods
  - Displays "Sideways Market Signal" warnings
  - Prevents trading during choppy markets

- **Real-Time Dashboard**:
  - Shows current ATR and volatility status
  - Displays bias for all timeframes
  - Tracks last signal and timing
  - Customizable position (corners)

- **Take Profit & Stop Loss Levels**:
  - TP1: 1.5x ATR from entry
  - TP2: 2.5x ATR from entry
  - TP3: 4.0x ATR from entry
  - SL: 1.5x ATR from entry

### 📥 Installation

1. **Download the files**:
   ```
   Clone or download this repository
   ```

2. **Copy to MetaTrader 5 data folder**:
   - Open MetaTrader 5
   - Go to: `File → Open Data Folder`
   - Copy the files to appropriate directories:
     - `Indicators/MTF_Strategy_Visual.mq5` → `MQL5/Indicators/`
     - `Include/*.mqh` files → `MQL5/Include/`

3. **Compile the indicator**:
   - Open MetaEditor (press F4 in MT5)
   - Open `MTF_Strategy_Visual.mq5`
   - Press F7 to compile
   - Verify no errors in the "Errors" tab

4. **Add to chart**:
   - In MT5, go to: `Insert → Indicators → Custom → MTF_Strategy_Visual`
   - Or drag from Navigator panel onto chart

### ⚙️ Configuration

#### EMA Settings
- **EMA Periods**: 5, 8, 13, 21, 34, 55 (default - Fibonacci sequence)
- **Convergence Threshold**: 0.5% - Controls sideways detection sensitivity

#### ATR Settings
- **ATR Period**: 14 bars (default)
- **ATR MA Period**: 14 bars (default)
- **ATR Threshold**: 1.0 - Minimum ATR/ATR_MA ratio for active trading
- **Sideways Threshold**: 0.8 - Maximum ATR/ATR_MA ratio for sideways detection

#### Timeframe Settings
- **HTF (Higher Timeframe)**: H1 - Determines overall trend
- **MTF (Medium Timeframe)**: M10 - Confirms trend with volatility
- **LTF (Lower Timeframe)**: M3 - Triggers entry signals

💡 **Tip**: Use timeframes with 3-4x ratio between them for best results

#### Visual Settings
- **Bullish Zone Color**: Pale green (default)
- **Bearish Zone Color**: Misty rose (default)
- **Sideways Zone Color**: Light gray (default)
- **Buy Signal Color**: Lime green (default)
- **Sell Signal Color**: Crimson (default)
- **Zone Transparency**: 90 (0-255, higher = more transparent)

#### Signal Box Settings
- **Height**: 30 pixels
- **Width**: 60 pixels

#### Risk Management
- **TP1 Multiplier**: 1.5x ATR
- **TP2 Multiplier**: 2.5x ATR
- **TP3 Multiplier**: 4.0x ATR
- **SL Multiplier**: 1.5x ATR

#### Display Options
- **Show Dashboard**: true/false
- **Show TP Levels**: true/false
- **Show EMA Zones**: true/false
- **Show Sideways Zones**: true/false
- **Enable Alerts**: true/false
- **Dashboard Corner**: Choose position (CORNER_RIGHT_UPPER, etc.)

### 🎯 Strategy Logic

#### Signal Generation Process

1. **Higher Timeframe Analysis (HTF)**:
   - Checks if all 6 EMAs are aligned
   - Bullish: 5>8>13>21>34>55
   - Bearish: 5<8<13<21<34<55
   - Sideways: EMAs tangled/converged

2. **Medium Timeframe Confirmation (MTF)**:
   - MTF EMA alignment must match HTF bias
   - ATR filter must be active (ATR > ATR_MA × threshold)
   - Ensures sufficient market volatility

3. **Lower Timeframe Entry (LTF)**:
   - **BUY Signal**: Price breaks above EMA5 cloud
   - **SELL Signal**: Price breaks below EMA5 cloud
   - Only triggered when HTF and MTF conditions are met

4. **Sideways Market Filter**:
   - EMA convergence: All EMAs within 0.5% range
   - ATR contraction: ATR < ATR_MA × 0.8
   - Signals disabled during sideways periods

### 📈 Usage Examples

#### Example 1: Trending Market (Bullish)
```
HTF (H1): Bullish - All EMAs aligned upward
MTF (M10): Bullish - Confirms HTF + ATR active
LTF (M3): Price breaks above EMA5
→ BUY signal generated with TP/SL levels
```

#### Example 2: Sideways Market
```
HTF (H1): Sideways - EMAs converged
ATR: Contracted (< 0.8 × ATR_MA)
→ No signals, "Sideways Market" warning displayed
```

#### Example 3: Conflicting Timeframes
```
HTF (H1): Bullish
MTF (M10): Bearish - Not aligned
→ No signal generated (waiting for MTF confirmation)
```

### 📊 Dashboard Information

The real-time dashboard displays:
```
MTF Strategy
─────────────────
Status: Active/Waiting
ATR: 0.00045
Volatility: Normal/High/Low
HTF: Bullish/Bearish/Sideways
MTF: Bullish/Bearish/Sideways
LTF: Entry
Signal: BUY/SELL/NONE
Time: HH:MM
```

### 🔧 Troubleshooting

#### Issue: Indicator not loading
**Solution**: 
- Ensure all `.mqh` files are in `MQL5/Include/` folder
- Recompile the indicator in MetaEditor
- Check for compilation errors

#### Issue: No signals appearing
**Solution**:
- Verify timeframe settings are appropriate for your symbol
- Check ATR threshold - may be too restrictive
- Ensure chart has enough historical data (100+ bars)
- Verify EMA cloud alignment on higher timeframes

#### Issue: Too many signals
**Solution**:
- Increase ATR threshold (e.g., from 1.0 to 1.2)
- Use higher timeframes for more selective signals
- Enable sideways detection to filter choppy periods

#### Issue: Dashboard not visible
**Solution**:
- Check "Show Dashboard" is enabled in settings
- Verify Dashboard Corner setting
- Adjust X/Y offset if behind other indicators

#### Issue: Objects cluttering chart
**Solution**:
- Reduce number of historical bars processed
- Disable unnecessary visual elements (EMA zones, TP levels)
- Use ClearAllObjects() function via script

### 📝 Best Practices

1. **Timeframe Selection**:
   - For scalping: H1 / M5 / M1
   - For intraday: H4 / H1 / M15
   - For swing: D1 / H4 / H1

2. **Symbol Selection**:
   - Works best on liquid markets (major forex pairs, BTC, indices)
   - Adjust EMA periods for different instruments
   - Test on demo account first

3. **Risk Management**:
   - Use TP levels as guidelines, not absolutes
   - Adjust SL multiplier based on your risk tolerance
   - Consider trailing stops after TP1 is hit

4. **Signal Confirmation**:
   - Don't rely solely on indicator signals
   - Confirm with price action and support/resistance
   - Wait for full candle close before entering

5. **Optimization**:
   - Backtest on historical data
   - Optimize EMA periods for your trading style
   - Adjust ATR thresholds based on market volatility

### 🏗️ File Structure

```
mql5-indicators/
├── Indicators/
│   └── MTF_Strategy_Visual.mq5    # Main indicator file
├── Include/
│   ├── EMACloud.mqh               # EMA alignment detection
│   ├── ATRFilter.mqh              # ATR volatility filtering
│   ├── SignalDetector.mqh         # Signal generation logic
│   └── Dashboard.mqh              # Dashboard creation/updates
└── README.md                      # This file
```

### 🔄 Version History

**v1.00** (Current)
- Initial release
- Multi-timeframe EMA analysis
- ATR-based volatility filtering
- Visual signal boxes and zones
- Real-time dashboard
- Sideways market detection
- TP/SL level calculation

### 📜 License & Credits

- **Author**: gcmishra7
- **Copyright**: © 2024 gcmishra7
- **Repository**: https://github.com/gcmishra7/mql5-indicators
- **License**: MIT License

### 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### ⚠️ Disclaimer

This indicator is provided for educational purposes only. Trading forex, cryptocurrencies, and other financial instruments carries a high level of risk and may not be suitable for all investors. Past performance is not indicative of future results. Always do your own research and consult with a licensed financial advisor before making any investment decisions.

### 📧 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check existing issues for solutions
- Review troubleshooting guide above

---

**Happy Trading! 📈**