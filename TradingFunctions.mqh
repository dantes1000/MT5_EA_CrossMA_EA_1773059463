// TradingFunctions.mqh - Fonctions de trading et gestion des positions
#ifndef TRADINGFUNCTIONS_MQH
#define TRADINGFUNCTIONS_MQH

#include "RiskManager.mqh"

// Fonction pour ouvrir une position d'achat
bool OpenBuyPosition()
{
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_DEAL;
    request.symbol = _Symbol;
    request.volume = GetLotSize();
    request.type = ORDER_TYPE_BUY;
    request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    request.sl = request.price - CalculateStopLossPoints() * _Point;
    request.tp = request.price + CalculateTakeProfitPoints() * _Point;
    request.deviation = 10;
    request.magic = 12345;
    request.comment = "CrossMA_EA Buy";
    
    if(OrderSend(request, result))
    {
        Print("Position d'achat ouverte. Ticket: ", result.order);
        return true;
    }
    else
    {
        Print("Erreur ouverture achat. Code: ", result.retcode);
        return false;
    }
}

// Fonction pour ouvrir une position de vente
bool OpenSellPosition()
{
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_DEAL;
    request.symbol = _Symbol;
    request.volume = GetLotSize();
    request.type = ORDER_TYPE_SELL;
    request.price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    request.sl = request.price + CalculateStopLossPoints() * _Point;
    request.tp = request.price - CalculateTakeProfitPoints() * _Point;
    request.deviation = 10;
    request.magic = 12345;
    request.comment = "CrossMA_EA Sell";
    
    if(OrderSend(request, result))
    {
        Print("Position de vente ouverte. Ticket: ", result.order);
        return true;
    }
    else
    {
        Print("Erreur ouverture vente. Code: ", result.retcode);
        return false;
    }
}

// Fonction pour vérifier s'il y a une position ouverte
bool HasOpenPosition()
{
    return PositionsTotal() > 0;
}

// Fonction pour fermer toutes les positions
void CloseAllPositions()
{
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        if(PositionSelectByTicket(PositionGetTicket(i)))
        {
            if(PositionGetInteger(POSITION_MAGIC) == 12345)
            {
                MqlTradeRequest request = {};
                MqlTradeResult result = {};
                
                request.action = TRADE_ACTION_DEAL;
                request.symbol = PositionGetString(POSITION_SYMBOL);
                request.volume = PositionGetDouble(POSITION_VOLUME);
                request.type = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
                request.price = SymbolInfoDouble(request.symbol, (request.type == ORDER_TYPE_SELL) ? SYMBOL_BID : SYMBOL_ASK);
                request.deviation = 10;
                request.magic = 12345;
                
                OrderSend(request, result);
            }
        }
    }
}

#endif