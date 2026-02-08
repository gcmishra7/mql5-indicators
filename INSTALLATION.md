# Installation Guide - MTF Strategy Visual Indicator

## Prerequisites

- MetaTrader 5 platform (build 3802 or later)
- Basic understanding of MT5 indicator installation
- Windows, macOS (with Wine), or Linux (with Wine)

## Step-by-Step Installation

### Method 1: Direct Installation (Recommended)

1. **Download the Repository**
   - Click the green "Code" button on GitHub
   - Select "Download ZIP"
   - Extract the ZIP file to a temporary location

2. **Locate MT5 Data Folder**
   - Open MetaTrader 5
   - Click `File` → `Open Data Folder`
   - This opens your MT5 data directory (typically: `C:\Users\[YourName]\AppData\Roaming\MetaQuotes\Terminal\[ID]\`)

3. **Copy Indicator Files**
   
   Copy files to these exact locations:
   ```
   Source                          → Destination
   ────────────────────────────────────────────────────
   Indicators/MTF_Strategy_Visual.mq5  → MQL5/Indicators/
   Include/EMACloud.mqh            → MQL5/Include/
   Include/ATRFilter.mqh           → MQL5/Include/
   Include/SignalDetector.mqh      → MQL5/Include/
   Include/Dashboard.mqh           → MQL5/Include/
   ```

4. **Compile the Indicator**
   - Open MetaEditor (press `F4` in MT5 or click the MetaEditor icon)
   - In MetaEditor Navigator, find: `Indicators → MTF_Strategy_Visual.mq5`
   - Double-click to open it
   - Press `F7` or click "Compile" button
   - Check the "Errors" tab at the bottom:
     - ✅ **Success**: "0 error(s), 0 warning(s)"
     - ❌ **Failed**: See troubleshooting section below

5. **Add to Chart**
   - Return to MT5
   - Open any chart (e.g., EURUSD, BTCUSD)
   - In Navigator panel (press `Ctrl+N` if not visible)
   - Expand: `Indicators → Custom`
   - Drag `MTF_Strategy_Visual` onto your chart
   - Configure settings in the dialog box
   - Click "OK"

### Method 2: Git Clone (For Developers)

1. **Clone Repository**
   ```bash
   git clone https://github.com/gcmishra7/mql5-indicators.git
   cd mql5-indicators
   ```

2. **Create Symbolic Links** (Advanced)
   
   On Windows (run as Administrator):
   ```cmd
   mklink /D "C:\Users\[YourName]\AppData\Roaming\MetaQuotes\Terminal\[ID]\MQL5\Indicators\MTF" "%CD%\Indicators"
   mklink /D "C:\Users\[YourName]\AppData\Roaming\MetaQuotes\Terminal\[ID]\MQL5\Include\MTF" "%CD%\Include"
   ```

   On Linux/macOS:
   ```bash
   ln -s "$(pwd)/Indicators" "$HOME/.wine/drive_c/Program Files/MetaTrader 5/MQL5/Indicators/MTF"
   ln -s "$(pwd)/Include" "$HOME/.wine/drive_c/Program Files/MetaTrader 5/MQL5/Include/MTF"
   ```

3. **Follow steps 4-5 from Method 1**

## Verification

### Test on Demo Account

1. Open a new chart (M5 or M15 timeframe recommended)
2. Add the indicator
3. Verify these elements appear:
   - ✅ Background EMA zones (colored areas)
   - ✅ Dashboard in corner (shows HTF/MTF/LTF status)
   - ✅ No compilation errors in "Experts" log tab

### Expected Visual Elements

After installation, you should see:
- Colored background zones (green/red/gray)
- Dashboard panel in top-right corner
- Signal boxes appear when conditions are met
- TP/SL lines when signals trigger

## Troubleshooting

### Error: "Cannot open include file 'EMACloud.mqh'"

**Cause**: Include files not in correct folder

**Solution**:
```
1. Verify all .mqh files are in: MQL5/Include/
2. Check file paths in main indicator:
   #include <../Include/EMACloud.mqh>  ← Should be this
   
   If error persists, try:
   #include <EMACloud.mqh>
```

### Error: "Undeclared identifier"

**Cause**: Syntax error or missing function

**Solution**:
1. Re-download all files
2. Ensure no modifications to original code
3. Check MT5 build number (needs 3802+)

### Error: "Array index out of range"

**Cause**: Insufficient historical data

**Solution**:
1. Load more history: Right-click chart → Properties → Max bars in chart → 10000
2. Wait for MT5 to download historical data
3. Restart MT5

### Indicator Loads But Nothing Shows

**Cause**: Settings misconfigured or timeframe issue

**Solution**:
1. Check input parameters:
   - HTF/MTF/LTF timeframes are valid
   - Display options are enabled (Show_EMA_Zones, Show_Dashboard)
2. Try default settings first
3. Check "Common" tab → "Allow DLL imports" is NOT needed for this indicator

### Signal Boxes Not Appearing

**Cause**: Conditions not met or timeframe mismatch

**Solution**:
1. Verify HTF shows clear trend (H1 bullish/bearish)
2. Check ATR is active (Dashboard shows "Status: Active")
3. Wait for LTF cloud break
4. Try on trending pairs (EURUSD, GBPUSD)

### Dashboard Not Visible

**Cause**: Off-screen or hidden

**Solution**:
1. Check "Show_Dashboard" = true in settings
2. Adjust Dashboard_Corner setting
3. Try different corner positions:
   - CORNER_RIGHT_UPPER
   - CORNER_LEFT_UPPER
   - CORNER_RIGHT_LOWER
   - CORNER_LEFT_LOWER
4. Adjust X/Y offsets (start with 10, 20)

### Performance Issues / Lag

**Cause**: Too many objects on chart

**Solution**:
1. Reduce historical processing:
   - In OnCalculate, limit is set to 100 bars
   - Can reduce to 50 for better performance
2. Disable unnecessary visuals:
   - Show_EMA_Zones = false
   - Show_TP_Levels = false
3. Clear old objects manually:
   - Press Ctrl+B → Objects tab
   - Delete old MTF_* objects

## Updating the Indicator

### When New Version Released

1. Download new version files
2. **Important**: Remove old indicator first:
   - Remove from all charts
   - Delete compiled file: `MQL5/Indicators/MTF_Strategy_Visual.ex5`
3. Copy new files (overwrite old ones)
4. Recompile in MetaEditor
5. Add back to charts

## Advanced Configuration

### Custom Include Path

If you prefer custom organization:

1. Edit main indicator file:
   ```cpp
   // Change from:
   #include <../Include/EMACloud.mqh>
   
   // To:
   #include <MyFolder/EMACloud.mqh>
   ```

2. Place .mqh files in: `MQL5/Include/MyFolder/`

### Multiple Instances

You can run multiple instances with different settings:

1. Add indicator to chart 3-4 times
2. Each instance with different timeframes:
   - Instance 1: H4/H1/M15 (swing)
   - Instance 2: H1/M15/M5 (intraday)
   - Instance 3: M15/M5/M1 (scalping)
3. Use different colors for each instance

## Uninstallation

### Complete Removal

1. Remove from all charts
2. Delete files:
   ```
   MQL5/Indicators/MTF_Strategy_Visual.mq5
   MQL5/Indicators/MTF_Strategy_Visual.ex5
   MQL5/Include/EMACloud.mqh
   MQL5/Include/ATRFilter.mqh
   MQL5/Include/SignalDetector.mqh
   MQL5/Include/Dashboard.mqh
   ```
3. Restart MT5

## Support

If issues persist after troubleshooting:

1. Check GitHub Issues: https://github.com/gcmishra7/mql5-indicators/issues
2. Provide these details:
   - MT5 build number
   - Operating system
   - Exact error message
   - Screenshot if possible
3. Check MetaTrader logs: `Experts` tab and `Journal` tab

## Additional Resources

- MQL5 Documentation: https://www.mql5.com/en/docs
- MT5 User Guide: https://www.metatrader5.com/en/terminal/help
- MQL5 Community: https://www.mql5.com/en/forum

---

**Installation successful?** → Proceed to README.md for usage guide and strategy explanation.
