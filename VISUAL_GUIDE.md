# Visual Representation Guide

## What You'll See After Installation

### Chart Display Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│ EURUSD, M15                                                  [=] [□] [X] │
├─────────────────────────────────────────────────────────────────────────┤
│                                                       ┌──────────────────┐│
│  1.0950 ├─────────────────────────────────────────│ MTF Strategy     ││
│         │                                          │ ───────────────  ││
│  1.0945 │   ╔════════╗                           │ Status: Active   ││
│         │   ║  BUY   ║ ← Green signal box         │                  ││
│  1.0940 │   ╚════════╝                           │ ATR: 0.00045     ││
│         │░░░░░░░░░░░░░░░░░░░░░░░░░░░              │ Volatility: Normal││
│  1.0935 │░░░Bullish Zone (Light Green)░░          │                  ││
│         │░░░░░░░░░░░░░░░░░░░░░░░░░░░              │ HTF: Bullish     ││
│  1.0930 │                                          │ MTF: Bullish     ││
│         │-- - - - TP1 (Green dashed)              │ LTF: Entry       ││
│  1.0925 │                                          │                  ││
│         │-- - - - TP2 (Green dashed)              │ Signal: BUY      ││
│  1.0920 │                                          │ Time: 14:35      ││
│         │-- - - - TP3 (Green dashed)              └──────────────────┘│
│  1.0915 │                                                              │
│         │-- - - - SL (Red dashed)                                      │
│  1.0910 │                                                              │
│         ├──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬─────│
│         14:00  14:15  14:30  14:45  15:00  15:15  15:30  15:45  16:00 │
└─────────────────────────────────────────────────────────────────────────┘
```

### Visual Elements Breakdown

#### 1. EMA Cloud Zones (Background)
```
Bullish Trend:
┌─────────────────────┐
│░░░░░░░░░░░░░░░░░░░░ │  ← Pale Green fill
│░ EMA 5 ─────────── ░│    (semi-transparent)
│░ EMA 8 ─────────── ░│
│░ EMA 13 ────────── ░│
│░ EMA 21 ────────── ░│
│░ EMA 34 ────────── ░│
│░ EMA 55 ────────── ░│
│░░░░░░░░░░░░░░░░░░░░ │
└─────────────────────┘

Bearish Trend:
┌─────────────────────┐
│▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │  ← Misty Rose fill
│▓ EMA 55 ────────── ▓│    (semi-transparent)
│▓ EMA 34 ────────── ▓│
│▓ EMA 21 ────────── ▓│
│▓ EMA 13 ────────── ▓│
│▓ EMA 8 ─────────── ▓│
│▓ EMA 5 ─────────── ▓│
│▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │
└─────────────────────┘

Sideways Market:
┌─────────────────────┐
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ │  ← Light Gray fill
│▒ EMAs Converged   ▒│    (all EMAs close together)
│▒ Low Volatility   ▒│
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ │
│  "Sideways Market Signal"
└─────────────────────┘
```

#### 2. Signal Boxes

**BUY Signal:**
```
At Entry Price (1.0940):
╔═══════════╗
║           ║  ← Green box
║    BUY    ║  ← White text, centered
║           ║
╚═══════════╝
```

**SELL Signal:**
```
At Entry Price (1.0890):
╔═══════════╗
║           ║  ← Red box
║   SELL    ║  ← White text, centered
║           ║
╚═══════════╝
```

#### 3. TP/SL Levels

```
Entry: 1.0940 ═══════════════════════ (BUY box)
                ↑
                | 1.5x ATR
                ↓
TP1:   1.0965 ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  (Green dashed)
                ↑
                | 1.0x ATR
                ↓
TP2:   1.0990 ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  (Green dashed)
                ↑
                | 1.5x ATR
                ↓
TP3:   1.1020 ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  (Green dashed)

                ↑
                | 1.5x ATR down
                ↓
SL:    1.0915 ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  (Red dashed)
```

#### 4. Dashboard (Top-Right Corner)

```
┌─────────────────────┐
│ MTF Strategy        │ ← Title (White, Bold)
│ ─────────────────── │ ← Separator (Gray)
│ Status: Active      │ ← White text
│                     │
│ ATR: 0.00045        │ ← Current ATR value
│ Volatility: Normal  │ ← High/Normal/Low
│                     │
│ HTF: Bullish        │ ← H1 bias
│ MTF: Bullish        │ ← M10 status
│ LTF: Entry          │ ← M3 status
│                     │
│ Signal: BUY         │ ← Last signal (Green if BUY)
│ Time: 14:35         │ ← Signal time
└─────────────────────┘
```

**Dashboard States:**

Status Field:
- "Active" = ATR filter passed, ready to trade
- "Waiting" = ATR too low, no trading

Volatility Field:
- "High" = ATR > 1.2 × ATR_MA (very volatile)
- "Normal" = 0.8 < ATR ≤ 1.2 × ATR_MA (typical)
- "Low" = ATR ≤ 0.8 × ATR_MA (quiet market)

Timeframe Bias Fields:
- "Bullish" = All EMAs aligned upward
- "Bearish" = All EMAs aligned downward
- "Sideways" = EMAs tangled or converged

Signal Field:
- "BUY" in green = Last signal was long entry
- "SELL" in red = Last signal was short entry
- "NONE" in white = No recent signals

### 5. Sideways Detection Visual

```
When market is sideways:

┌───────────────────────────────────┐
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│ ← Light pink/red zone
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│
└───────────────────────────────────┘
     "Sideways Market Signal" ← Red label
```

## Color Scheme

### Default Colors (Customizable)

| Element              | Color           | RGB/Hex    |
|----------------------|-----------------|------------|
| Bullish Zone         | Pale Green      | #98FB98    |
| Bearish Zone         | Misty Rose      | #FFE4E1    |
| Sideways Zone        | Light Gray      | #D3D3D3    |
| BUY Signal Box       | Lime Green      | #32CD32    |
| SELL Signal Box      | Crimson         | #DC143C    |
| TP Lines             | Lime Green      | #32CD32    |
| SL Line              | Red             | #FF0000    |
| Dashboard Text       | White           | #FFFFFF    |
| Dashboard Labels     | Dark Gray       | #696969    |

## Interactive Elements

### What Happens On Each Timeframe

**H1 Chart (HTF):**
```
- Shows overall trend direction
- Bullish/Bearish zones very clear
- Fewer signals (major trend changes only)
```

**M10 Chart (MTF):**
```
- Shows trend confirmation
- Medium number of signals
- Good balance of zones and signals
```

**M3 Chart (LTF):**
```
- Shows precise entry points
- Most signals appear here
- Best for watching entries
```

### Alert Behavior

When new signal appears:
```
┌─────────────────────────────────────┐
│ MetaTrader 5 Alert                  │
├─────────────────────────────────────┤
│ MTF Strategy: BUY Signal at 1.0940  │
│                                     │
│ [ OK ]                              │
└─────────────────────────────────────┘
```

## Display Settings Impact

### Show_EMA_Zones = true
- Background colors visible
- Easy to see trend at a glance
- Chart looks colorful

### Show_EMA_Zones = false
- Clean white background
- Only signals and dashboard show
- Minimal visual clutter

### Show_TP_Levels = true
- Dashed lines for each TP and SL
- Easy to plan exits
- Lines extend to the right

### Show_TP_Levels = false
- No TP/SL lines
- Cleaner chart
- Focus on entries only

### Show_Dashboard = true
- Info panel visible
- Real-time status updates
- Takes small corner space

### Show_Dashboard = false
- Maximum chart space
- No info panel
- Rely on signals only

## Multi-Instance Setup

Can run 3 different timeframe setups simultaneously:

```
┌────────────────────────────────┐
│ Instance 1: H4/H1/M15 (Swing)  │  ← Blue colors
│ Instance 2: H1/M15/M5 (Intraday)│  ← Green colors
│ Instance 3: M15/M5/M1 (Scalping)│  ← Orange colors
└────────────────────────────────┘

Each shows different signals based on their timeframe settings
```

## Tips for Best Visual Experience

1. **Chart Background**: Use dark or medium background for better contrast
2. **Zoom Level**: Adjust to show 100-200 bars for clear zones
3. **Transparency**: Default 90 is good, increase to 120 for more subtle zones
4. **Dashboard Position**: Try all corners to find what works for your screen
5. **Signal Box Size**: Adjust height/width if text doesn't fit properly

## Mobile/Web Terminal Display

The indicator works on desktop MT5. For mobile:
- Dashboard may be small (increase font sizes)
- Touch to select signal boxes
- Zones still visible but may need zoom
- All functionality remains the same

---

**Note**: Actual colors and appearance may vary slightly based on:
- MT5 theme (light/dark)
- Monitor/screen settings
- Graphics card rendering
- MT5 version and build
