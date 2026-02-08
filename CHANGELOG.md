# Changelog

All notable changes to the MTF Strategy Visual Indicator will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-02-08

### Added
- Initial release of MTF Strategy Visual Indicator
- Multi-timeframe EMA analysis (6 EMAs: 5, 8, 13, 21, 34, 55)
- EMA cloud zone visualization with color-coded backgrounds
  - Bullish zones (pale green)
  - Bearish zones (misty rose)  
  - Sideways zones (light gray)
- ATR-based volatility filtering system
  - ATR threshold for active trading
  - ATR contraction detection for sideways markets
- Signal generation system
  - BUY signal boxes (green with text)
  - SELL signal boxes (red with text)
- Sideways market detection and warnings
  - EMA convergence analysis
  - ATR contraction monitoring
  - Visual "Sideways Market Signal" labels
- Real-time dashboard display
  - Shows ATR and volatility status
  - Displays bias for all timeframes (HTF/MTF/LTF)
  - Tracks last signal type and timing
  - Customizable corner position
- Take Profit and Stop Loss levels
  - TP1: 1.5x ATR (default)
  - TP2: 2.5x ATR (default)
  - TP3: 4.0x ATR (default)
  - SL: 1.5x ATR from entry (default)
- Comprehensive input parameters
  - EMA period customization
  - ATR settings (period, MA period, thresholds)
  - Timeframe selection (HTF/MTF/LTF)
  - Visual customization (colors, transparency, box sizes)
  - Display toggles for all visual elements
  - Risk management multipliers
- Alert system for new signals
- Include library system
  - EMACloud.mqh: EMA alignment detection and cloud break analysis
  - ATRFilter.mqh: ATR calculation and volatility filtering
  - SignalDetector.mqh: Complete signal generation logic
  - Dashboard.mqh: Dashboard creation and update functions

### Features
- Multi-timeframe strategy logic
  - HTF: Determines overall market bias
  - MTF: Confirms trend with volatility check
  - LTF: Triggers precise entry signals
- Professional visual design
  - Clean, non-cluttering background zones
  - Clear signal boxes with labels
  - Organized dashboard layout
- Performance optimizations
  - Efficient object management
  - Calculation limiting (100 bars default)
  - Smart object reuse
- Error handling
  - Indicator handle validation
  - Data availability checks
  - Safe array operations

### Documentation
- Comprehensive README.md with:
  - Feature overview
  - Installation instructions
  - Configuration guide
  - Strategy logic explanation
  - Usage examples
  - Troubleshooting guide
  - Best practices
- Detailed INSTALLATION.md guide
- MIT License file
- Changelog (this file)

### Technical Details
- MQL5 build compatibility: 3802+
- Indicator buffers: 6 (for EMA calculations)
- Object naming convention: MTF_* prefix
- Maximum historical bars processed: 100 (configurable)

## [Unreleased]

### Planned Features
- [ ] Backtesting mode with signal statistics
- [ ] Multi-symbol scanning dashboard
- [ ] Sound alerts with customizable sounds
- [ ] Email/push notification support
- [ ] Trade management panel (close positions, modify TP/SL)
- [ ] Signal strength indicator (0-100 scale)
- [ ] Historical signal performance tracking
- [ ] Custom alert conditions
- [ ] Export signals to CSV/JSON
- [ ] Mobile notification support

### Potential Improvements
- [ ] Optimize object creation for better performance
- [ ] Add more EMA convergence detection methods
- [ ] Implement dynamic ATR threshold adjustment
- [ ] Add support for other moving average types (SMA, SMMA, LWMA)
- [ ] Enhanced dashboard with more metrics
- [ ] Color themes (dark mode, light mode, custom)
- [ ] Interactive elements (clickable to hide/show)
- [ ] Support for drawing channels and trendlines

### Known Issues
- None reported yet

---

## Version History

- **v1.0.0** (2024-02-08): Initial release with complete functionality

---

**Note**: For migration guides between versions, see [MIGRATION.md] (coming in future releases)
