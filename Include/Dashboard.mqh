//+------------------------------------------------------------------+
//|                                                    Dashboard.mqh |
//|                                                       gcmishra7  |
//|                                      https://github.com/gcmishra7 |
//+------------------------------------------------------------------+
#property copyright "gcmishra7"
#property version   "1.00"
#property strict

// Dashboard object name prefix
string dashboard_prefix = "MTF_Dashboard_";

//+------------------------------------------------------------------+
//| Create individual label                                          |
//+------------------------------------------------------------------+
void CreateLabel(string name, ENUM_BASE_CORNER corner, int x, int y, string text, color clr, int size, string font)
{
    ObjectDelete(0, name);
    ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
    ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
    ObjectSetString(0, name, OBJPROP_TEXT, text);
    ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
    ObjectSetInteger(0, name, OBJPROP_FONTSIZE, size);
    ObjectSetString(0, name, OBJPROP_FONT, font);
    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
    ObjectSetInteger(0, name, OBJPROP_BACK, false);
}

//+------------------------------------------------------------------+
//| Create dashboard panel                                           |
//+------------------------------------------------------------------+
void CreateDashboard(ENUM_BASE_CORNER corner, int x_offset, int y_offset)
{
    int x = x_offset;
    int y = y_offset;
    int line_height = 18;
    
    // Create background rectangle (optional, if supported)
    // Most terminals don't support filled rectangles for labels, so we use labels only
    
    // Title
    CreateLabel(dashboard_prefix + "Title", corner, x, y, "MTF Strategy", clrWhite, 10, "Arial Bold");
    y += line_height;
    
    CreateLabel(dashboard_prefix + "Line1", corner, x, y, "─────────────────", clrDarkGray, 8, "Arial");
    y += line_height;
    
    // Status
    CreateLabel(dashboard_prefix + "Status", corner, x, y, "Status: --", clrWhite, 9, "Arial");
    y += line_height + 5;
    
    // ATR Info
    CreateLabel(dashboard_prefix + "ATR", corner, x, y, "ATR: --", clrWhite, 9, "Arial");
    y += line_height;
    
    CreateLabel(dashboard_prefix + "Volatility", corner, x, y, "Volatility: --", clrWhite, 9, "Arial");
    y += line_height + 5;
    
    // Timeframe Bias
    CreateLabel(dashboard_prefix + "HTF", corner, x, y, "HTF: --", clrWhite, 9, "Arial");
    y += line_height;
    
    CreateLabel(dashboard_prefix + "MTF", corner, x, y, "MTF: --", clrWhite, 9, "Arial");
    y += line_height;
    
    CreateLabel(dashboard_prefix + "LTF", corner, x, y, "LTF: --", clrWhite, 9, "Arial");
    y += line_height + 5;
    
    // Last Signal
    CreateLabel(dashboard_prefix + "Signal", corner, x, y, "Signal: NONE", clrWhite, 9, "Arial");
    y += line_height;
    
    CreateLabel(dashboard_prefix + "Time", corner, x, y, "Time: --", clrWhite, 9, "Arial");
}

//+------------------------------------------------------------------+
//| Update dashboard with current data                               |
//+------------------------------------------------------------------+
void UpdateDashboard(string status, double atr, string volatility, 
                     string htfBias, string mtfStatus, string ltfStatus,
                     string lastSignal, string lastTime, color signalColor)
{
    ObjectSetString(0, dashboard_prefix + "Status", OBJPROP_TEXT, "Status: " + status);
    ObjectSetString(0, dashboard_prefix + "ATR", OBJPROP_TEXT, "ATR: " + DoubleToString(atr, 5));
    ObjectSetString(0, dashboard_prefix + "Volatility", OBJPROP_TEXT, "Volatility: " + volatility);
    ObjectSetString(0, dashboard_prefix + "HTF", OBJPROP_TEXT, "HTF: " + htfBias);
    ObjectSetString(0, dashboard_prefix + "MTF", OBJPROP_TEXT, "MTF: " + mtfStatus);
    ObjectSetString(0, dashboard_prefix + "LTF", OBJPROP_TEXT, "LTF: " + ltfStatus);
    ObjectSetString(0, dashboard_prefix + "Signal", OBJPROP_TEXT, "Signal: " + lastSignal);
    ObjectSetInteger(0, dashboard_prefix + "Signal", OBJPROP_COLOR, signalColor);
    ObjectSetString(0, dashboard_prefix + "Time", OBJPROP_TEXT, "Time: " + lastTime);
}

//+------------------------------------------------------------------+
//| Delete dashboard                                                 |
//+------------------------------------------------------------------+
void DeleteDashboard()
{
    ObjectDelete(0, dashboard_prefix + "Title");
    ObjectDelete(0, dashboard_prefix + "Line1");
    ObjectDelete(0, dashboard_prefix + "Status");
    ObjectDelete(0, dashboard_prefix + "ATR");
    ObjectDelete(0, dashboard_prefix + "Volatility");
    ObjectDelete(0, dashboard_prefix + "HTF");
    ObjectDelete(0, dashboard_prefix + "MTF");
    ObjectDelete(0, dashboard_prefix + "LTF");
    ObjectDelete(0, dashboard_prefix + "Signal");
    ObjectDelete(0, dashboard_prefix + "Time");
}
//+------------------------------------------------------------------+
