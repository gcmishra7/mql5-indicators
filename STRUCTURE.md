# Project Structure

```
mql5-indicators/
│
├── 📄 README.md                    # Main documentation (285 lines)
├── 📄 QUICKSTART.md               # Quick start guide for beginners
├── 📄 INSTALLATION.md             # Detailed installation instructions
├── 📄 CHANGELOG.md                # Version history and changes
├── 📄 LICENSE                     # MIT License
├── 📄 .gitignore                  # Git ignore rules
│
├── 📁 Indicators/                 # Main indicator files
│   └── 🎯 MTF_Strategy_Visual.mq5  # Main indicator (581 lines)
│       │
│       ├── Uses: EMACloud.mqh
│       ├── Uses: ATRFilter.mqh
│       ├── Uses: SignalDetector.mqh
│       └── Uses: Dashboard.mqh
│
└── 📁 Include/                    # Library/helper files
    ├── 📚 EMACloud.mqh            # EMA calculations (86 lines)
    │   ├── IsEMABullish()
    │   ├── IsEMABearish()
    │   ├── IsEMAConverged()
    │   ├── GetEMAStrength()
    │   └── DetectCloudBreak()
    │
    ├── 📚 ATRFilter.mqh           # ATR calculations (131 lines)
    │   ├── CalculateATR()
    │   ├── CalculateATR_MA()
    │   ├── IsATRActive()
    │   ├── IsATRContracted()
    │   ├── GetATRTrend()
    │   └── GetATRStopDistance()
    │
    ├── 📚 SignalDetector.mqh      # Signal logic (121 lines)
    │   ├── struct SignalInfo
    │   └── DetectSignal()
    │       ├── Depends on: EMACloud.mqh
    │       └── Depends on: ATRFilter.mqh
    │
    └── 📚 Dashboard.mqh           # UI dashboard (112 lines)
        ├── CreateDashboard()
        ├── CreateLabel()
        ├── UpdateDashboard()
        └── DeleteDashboard()
```

## Component Relationships

```
┌─────────────────────────────────────────────────────────────────┐
│                    MTF_Strategy_Visual.mq5                      │
│                    (Main Indicator)                             │
└────────────┬────────────────────────────────────────────────────┘
             │
             ├──► EMACloud.mqh
             │    • EMA alignment detection
             │    • Cloud break detection
             │    • Trend strength calculation
             │
             ├──► ATRFilter.mqh
             │    • ATR calculation
             │    • Volatility filtering
             │    • Sideways detection
             │
             ├──► SignalDetector.mqh ───┐
             │    • Multi-timeframe analysis  │
             │    • Signal generation          ├──► Uses EMACloud.mqh
             │    • TP/SL calculation          │
             │                                  └──► Uses ATRFilter.mqh
             │
             └──► Dashboard.mqh
                  • UI creation
                  • Real-time updates
                  • Label management
```

## Data Flow

```
1. OnInit()
   └──► Create EMA handles
   └──► Initialize dashboard

2. OnCalculate() [Every tick/bar]
   │
   ├──► Copy EMA buffers
   │    └──► Store in indicator buffers
   │
   ├──► Process recent bars
   │    ├──► DrawEMAZones()
   │    │    └──► Uses: IsEMABullish/Bearish()
   │    │
   │    └──► DetectAndDrawSidewaysZone()
   │         └──► Uses: IsEMAConverged() + IsATRContracted()
   │
   ├──► CheckAndDrawSignals()
   │    ├──► Get EMA values for HTF/MTF/LTF
   │    ├──► DetectSignal()
   │    │    ├──► Check HTF bias
   │    │    ├──► Check MTF alignment
   │    │    ├──► Check ATR filter
   │    │    └──► Check LTF entry trigger
   │    │
   │    └──► If valid signal:
   │         ├──► DrawSignalBox()
   │         ├──► DrawTPSLLevels()
   │         └──► Send alert
   │
   └──► UpdateDashboardInfo()
        └──► Update all dashboard labels

3. OnDeinit()
   └──► Release handles
   └──► Clear objects
   └──► Delete dashboard
```

## Key Features per File

### MTF_Strategy_Visual.mq5
- **Main indicator logic**
- EMA buffer management
- Visual object creation (zones, boxes, lines)
- Multi-timeframe coordination
- Signal validation and display

### EMACloud.mqh
- **Pure EMA calculations**
- No external dependencies
- Stateless functions
- Fast execution

### ATRFilter.mqh
- **Volatility analysis**
- ATR calculation with handles
- Moving average of ATR
- Trend detection

### SignalDetector.mqh
- **Decision-making hub**
- Combines EMA + ATR logic
- Complete signal validation
- TP/SL calculation

### Dashboard.mqh
- **User interface**
- Label creation/management
- Real-time display updates
- No trading logic

## Object Naming Convention

All visual objects use prefixes to avoid conflicts:

- `MTF_Zone_*` - EMA cloud zones
- `MTF_Signal_Box_*` - Signal boxes
- `MTF_Signal_Text_*` - Signal labels
- `MTF_TP_*` - Take profit lines
- `MTF_Sideways_*` - Sideways zones
- `MTF_Sideways_Label_*` - Sideways labels
- `MTF_Dashboard_*` - Dashboard elements

## Input Parameters Structure

```
EMA Settings (7 parameters)
├── 6 EMA periods (5, 8, 13, 21, 34, 55)
└── Convergence threshold

ATR Settings (4 parameters)
├── ATR period
├── ATR MA period
├── Active threshold
└── Sideways threshold

Timeframes (3 parameters)
├── HTF (Higher Timeframe)
├── MTF (Medium Timeframe)
└── LTF (Lower Timeframe)

Visual Settings (6 parameters)
├── Bullish zone color
├── Bearish zone color
├── Sideways zone color
├── Buy signal color
├── Sell signal color
└── Transparency

Signal Box Settings (2 parameters)
├── Height
└── Width

Risk Management (4 parameters)
├── TP1 multiplier
├── TP2 multiplier
├── TP3 multiplier
└── SL multiplier

Display Options (7 parameters)
├── Show dashboard
├── Show TP levels
├── Show EMA zones
├── Show sideways zones
├── Enable alerts
├── Dashboard corner
└── Dashboard X/Y offsets
```

## Total Lines of Code

- **Total**: ~1,962 lines
- **Code**: ~1,250 lines
- **Documentation**: ~712 lines
- **Comments**: Extensive inline documentation

## Memory & Performance

- **Indicator Buffers**: 6 (for EMA calculations)
- **Visual Objects**: Dynamic (created/destroyed as needed)
- **Handles**: 6 permanent EMA handles + temporary handles
- **Processing**: Limited to 100 recent bars (configurable)
- **Updates**: On every tick (dashboard) + new bar (signals)

## Installation Locations

For MetaTrader 5:

```
MQL5/
├── Indicators/
│   └── MTF_Strategy_Visual.mq5  ← Copy here
│
└── Include/
    ├── EMACloud.mqh              ← Copy here
    ├── ATRFilter.mqh             ← Copy here
    ├── SignalDetector.mqh        ← Copy here
    └── Dashboard.mqh             ← Copy here
```

---

**Architecture Notes**:
- Modular design for easy maintenance
- Separation of concerns (EMA logic, ATR logic, UI)
- Reusable components
- Clear data flow
- Comprehensive error handling
