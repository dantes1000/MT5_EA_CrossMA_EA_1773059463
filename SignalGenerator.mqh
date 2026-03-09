// SignalGenerator.mqh - Génération des signaux de trading
#ifndef SIGNALGENERATOR_MQH
#define SIGNALGENERATOR_MQH

#include "Indicators.mqh"

// Énumération des signaux
enum ENUM_SIGNAL
{
    SIGNAL_NONE,    // Pas de signal
    SIGNAL_BUY,     // Signal d'achat
    SIGNAL_SELL     // Signal de vente
};

// Fonction pour générer un signal basé sur le croisement des MA
ENUM_SIGNAL GenerateSignal()
{
    double fastMA[3];
    double slowMA[3];
    
    if(!GetMAValues(fastMA, slowMA))
        return SIGNAL_NONE;
    
    // Vérifier le croisement haussier (MA rapide > MA lente)
    if(fastMA[1] <= slowMA[1] && fastMA[0] > slowMA[0])
    {
        return SIGNAL_BUY;
    }
    // Vérifier le croisement baissier (MA rapide < MA lente)
    else if(fastMA[1] >= slowMA[1] && fastMA[0] < slowMA[0])
    {
        return SIGNAL_SELL;
    }
    
    return SIGNAL_NONE;
}

#endif