# MQL5 Multi-Timeframe ATR/EMA Cloud Indicator

## Overview
This indicator implements a multi-timeframe trading strategy using EMA cloud alignment and ATR volatility filtering for manual verification. It's designed as Phase 1 of a comprehensive trading system that will eventually include automated Expert Advisors and Python implementations.

The indicator provides visual confirmation of:
- **EMA Cloud Alignment** across multiple timeframes (H1, M10, M3)
- **ATR Volatility Filter** to ensure sufficient market movement
- **Entry Signal Detection** with arrow markers on valid setups
- **Real-time Dashboard** showing current market conditions

## Installation

1. Copy `MTF_ATR_EMA_Cloud.mq5` to your MetaTrader 5 `MQL5/Indicators/` folder
2. Copy `EMACloud.mqh` and `ATRFilter.mqh` to your MetaTrader 5 `MQL5/Include/` folder
3. Restart MetaTrader 5 or refresh the Navigator window (F4)
4. Locate the indicator in Navigator under "Indicators"
5. Drag and drop onto your chart to activate

## Strategy Logic

### Multi-Timeframe Approach

This indicator uses a three-timeframe approach for high-probability trade setups:

#### 1. Higher Timeframe Bias (H1 - Default)
- **Purpose**: Defines the overall market direction
- **Method**: EMA stack alignment analysis
- **Bullish Bias**: EMAs in ascending order (5 > 8 > 13 > 21 > 34 > 55)
- **Bearish Bias**: EMAs in descending order (5 < 8 < 13 < 21 < 34 < 55)
- **Neutral**: EMAs are intertwined (choppy/ranging market)

#### 2. Medium Timeframe Filter (M10 - Default)
- **Purpose**: Confirms HTF bias and filters out low-volatility periods
- **Method**: EMA alignment + ATR volatility filter
- **Requirements**:
  - EMA alignment must match HTF bias direction
  - ATR must be above its moving average (threshold check)
  - Filters out choppy/ranging conditions

#### 3. Lower Timeframe Entry (M3 - Default)
- **Purpose**: Precise entry timing with minimal risk
- **Method**: EMA cloud breaks with HTF/MTF confirmation
- **Entry Conditions**:
  - Price breaks through EMA cloud (3 fast EMAs)
  - All three timeframes aligned in same direction
  - ATR threshold confirmation active
  - Visual arrow signals generated on valid setups

### EMA Cloud Structure

The indicator uses 6 EMAs to form a "cloud":
- **Fast EMAs** (5, 8, 13): Entry timing and immediate trend
- **Medium EMAs** (21, 34): Trend confirmation
- **Slow EMA** (55): Overall trend filter

**Color Coding**:
- **Green**: Bullish alignment (all EMAs in proper ascending order)
- **Red**: Bearish alignment (all EMAs in proper descending order)
- **Gray**: Neutral/choppy (EMAs intertwined)

### ATR Volatility Filter

The ATR (Average True Range) filter ensures trades are taken only when:
- Market volatility is sufficient for profitable moves
- Current ATR exceeds its moving average (threshold multiplier)
- Avoids choppy, low-volatility periods that produce false signals

**ATR Filter Status**:
- **Active**: ATR >= (ATR_MA × Threshold_Multiplier)
- **Inactive**: ATR < (ATR_MA × Threshold_Multiplier)

## Parameters

### EMA Settings
| Parameter | Default | Description |
|-----------|---------|-------------|
| `EMA_Period_1` | 5 | Fastest EMA (most responsive) |
| `EMA_Period_2` | 8 | Fast EMA |
| `EMA_Period_3` | 13 | Fast EMA |
| `EMA_Period_4` | 21 | Medium EMA |
| `EMA_Period_5` | 34 | Medium EMA |
| `EMA_Period_6` | 55 | Slowest EMA (trend filter) |

### ATR Filter Settings
| Parameter | Default | Description |
|-----------|---------|-------------|
| `ATR_Period` | 14 | ATR calculation period |
| `ATR_MA_Period` | 14 | Moving average period for ATR smoothing |
| `ATR_Threshold_Multiplier` | 1.0 | ATR must be >= (ATR_MA × this value) |

**Threshold Examples**:
- `1.0`: ATR must equal or exceed its average (standard)
- `1.2`: ATR must be 20% above average (more selective)
- `0.8`: ATR can be 20% below average (less selective)

### Timeframe Settings
| Parameter | Default | Description |
|-----------|---------|-------------|
| `HTF_Timeframe` | PERIOD_H1 | Higher timeframe for bias (H1) |
| `MTF_Timeframe` | PERIOD_M10 | Medium timeframe for filter (M10) |
| `LTF_Timeframe` | PERIOD_M3 | Lower timeframe for entry (M3) |

**Available Timeframes**:
- M1, M2, M3, M4, M5, M6, M10, M12, M15, M20, M30
- H1, H2, H3, H4, H6, H8, H12
- D1, W1, MN1

### Visual Settings
| Parameter | Default | Description |
|-----------|---------|-------------|
| `Color_Bullish` | LimeGreen | Color for bullish alignment |
| `Color_Bearish` | Red | Color for bearish alignment |
| `Color_Neutral` | Gray | Color for neutral/choppy markets |
| `Show_Arrows` | true | Display entry signal arrows |
| `Show_Dashboard` | true | Display information dashboard |
| `Enable_Alerts` | true | Enable popup/sound alerts |

## Signals

### Entry Signals

#### Buy Signal (Green Arrow ↑)
- **HTF Bias**: Bullish (EMAs ascending)
- **MTF Trend**: Bullish alignment confirmed
- **ATR Filter**: Active (volatility sufficient)
- **LTF Entry**: Price breaks above EMA cloud
- **Arrow Position**: Below the entry bar

#### Sell Signal (Red Arrow ↓)
- **HTF Bias**: Bearish (EMAs descending)
- **MTF Trend**: Bearish alignment confirmed
- **ATR Filter**: Active (volatility sufficient)
- **LTF Entry**: Price breaks below EMA cloud
- **Arrow Position**: Above the entry bar

### Dashboard Information

The dashboard (top-left corner) displays:

1. **HTF Bias**: Current higher timeframe trend direction
   - BULLISH (Green)
   - BEARISH (Red)
   - NEUTRAL (Gray)

2. **MTF Trend**: Medium timeframe alignment status
   - ALIGNED (Bullish) - Green
   - ALIGNED (Bearish) - Red
   - NOT ALIGNED - Gray

3. **ATR Filter**: Volatility filter status
   - ACTIVE (Green) - Sufficient volatility
   - INACTIVE (Red) - Low volatility period

4. **ATR Value**: Current ATR reading

5. **Last Signal**: Most recent entry signal with timestamp
   - BUY @ [time]
   - SELL @ [time]

## Usage Guide

### Manual Trading Workflow

1. **Analyze HTF Bias**
   - Open your H1 chart
   - Look at the dashboard or EMA alignment
   - Identify the dominant trend direction

2. **Wait for MTF Confirmation**
   - Check M10 timeframe alignment
   - Ensure ATR filter shows "ACTIVE"
   - Both HTF and MTF must align

3. **Watch for LTF Entry**
   - Monitor M3 chart for arrow signals
   - Green arrow = potential long entry
   - Red arrow = potential short entry

4. **Execute Trade**
   - Enter on signal arrow appearance
   - Set stop loss using ATR-based distance
   - Target based on risk-reward ratio

5. **Monitor Dashboard**
   - Keep dashboard visible
   - Watch for trend changes
   - Exit if alignment breaks

### Optimization Tips

- **Conservative**: Increase `ATR_Threshold_Multiplier` to 1.2-1.5
- **Aggressive**: Decrease to 0.8-0.9 (more signals, less selective)
- **Different Markets**: Adjust EMA periods for faster/slower markets
- **Timeframe Combinations**: Experiment with different HTF/MTF/LTF ratios

## Testing Checklist

This is Phase 1 for manual verification. Use this indicator to:

- [x] Compile without errors or warnings
- [x] Display all EMA lines correctly with color coding
- [x] Generate arrow signals at valid setups
- [x] Display dashboard with accurate real-time information
- [ ] Verify on different symbols (forex, indices, commodities)
- [ ] Test on different timeframe combinations
- [ ] Validate signal accuracy during trending markets
- [ ] Validate signal filtering during ranging markets
- [ ] Confirm ATR filter effectiveness
- [ ] Collect data for backtesting parameters
- [ ] Document win rate and risk-reward ratios

## Files Structure

```
mql5-indicators/
├── Indicators/
│   └── MTF_ATR_EMA_Cloud.mq5    # Main indicator file
├── Include/
│   ├── EMACloud.mqh              # EMA cloud helper functions
│   └── ATRFilter.mqh             # ATR filter helper functions
└── README.md                     # This documentation
```

## Technical Details

### Multi-Timeframe Data Handling
- Uses `iMA()` function with specified timeframes for EMA calculations
- Uses `iATR()` for ATR calculations on multiple timeframes
- Properly syncs data across timeframes using indicator handles
- Handles edge cases where higher timeframe data isn't available

### Performance Optimization
- Calculates indicators using efficient buffer copying
- Uses indicator handles for multi-timeframe access
- Minimizes redundant calculations
- Dashboard updates on each tick for real-time feedback

### Code Quality
- MQL5 coding conventions followed
- Comprehensive inline comments
- Meaningful variable names
- Error handling for indicator handle creation
- Input parameter validation

## Known Limitations

1. **First Bar Data**: Initial bars may not have complete multi-timeframe data
2. **Weekend Gaps**: Signals near market open/close may need manual verification
3. **News Events**: High-impact news can create false signals
4. **Manual Verification**: This is Phase 1 - requires human oversight

## Next Phases

### Phase 2: Expert Advisor (EA)
- Automated trading based on indicator signals
- Position sizing and risk management
- Multiple entry/exit strategies
- Full backtesting on MT5 Strategy Tester
- Optimization of parameters

### Phase 3: Python Implementation
- Live trading integration
- Advanced analytics and reporting
- Machine learning signal enhancement
- Portfolio management across multiple symbols
- Cloud-based deployment options

## Troubleshooting

### Indicator Not Showing
- Ensure all files are in correct folders
- Restart MetaTrader 5
- Check compilation errors in MetaEditor

### No Signals Generated
- Verify all three timeframes are aligned
- Check if ATR filter is active (dashboard)
- Ensure sufficient historical data is available
- Try different symbol or timeframe

### Dashboard Not Visible
- Check `Show_Dashboard` parameter is set to `true`
- Verify chart window has space (not covered by other objects)
- Try refreshing the chart (F5)

### Arrows Not Showing
- Check `Show_Arrows` parameter is set to `true`
- Ensure signal conditions are being met
- Wait for complete bar formation

## Support and Contributions

This is an open-source project. Feel free to:
- Report issues or bugs
- Suggest improvements
- Submit pull requests
- Share your results and modifications

## Disclaimer

This indicator is for educational and research purposes. Trading financial markets involves risk. Past performance does not guarantee future results. Always use proper risk management and never risk more than you can afford to lose.

## License

Copyright 2026, gcmishra7. All rights reserved.

---

**Version**: 1.00  
**Last Updated**: February 2026  
**Status**: Phase 1 - Manual Verification