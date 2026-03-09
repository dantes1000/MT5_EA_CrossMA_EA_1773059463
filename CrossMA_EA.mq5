// CrossMA_EA.mq5 - Expert Advisor basé sur croisement de moyennes mobiles
// Version: 1.0
// Auteur: Expert MQL5

#property copyright "Expert MQL5"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

// Inclusion des fichiers d'en-tête
#include "RiskManager.mqh"
#include "Indicators.mqh"
#include "TradingFunctions.mqh"
#include "SignalGenerator.mqh"

// Variables globales
bool indicatorsInitialized = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Initialisation des indicateurs
    if(!InitializeIndicators())
    {
        Print("Échec de l'initialisation des indicateurs");
        return INIT_FAILED;
    }
    
    indicatorsInitialized = true;
    Print("CrossMA_EA initialisé avec succès");
    Print("Paramètres: MA Rapide=", FastMAPeriod, ", MA Lente=", SlowMAPeriod);
    Print("Risque: SL=", StopLossPips, " pips, TP=", TakeProfitPips, " pips, Lot=", FixedLotSize);
    
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Fermer toutes les positions ouvertes par cet EA
    CloseAllPositions();
    
    // Désinitialiser les indicateurs
    if(indicatorsInitialized)
    {
        DeinitializeIndicators();
    }
    
    Print("CrossMA_EA désinitialisé. Raison: ", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Vérifier si les indicateurs sont initialisés
    if(!indicatorsInitialized)
        return;
    
    // Vérifier s'il y a déjà une position ouverte
    if(HasOpenPosition())
        return;
    
    // Générer le signal
    ENUM_SIGNAL signal = GenerateSignal();
    
    // Exécuter le trade selon le signal
    switch(signal)
    {
        case SIGNAL_BUY:
            OpenBuyPosition();
            break;
            
        case SIGNAL_SELL:
            OpenSellPosition();
            break;
            
        case SIGNAL_NONE:
            // Pas d'action
            break;
    }
}

//+------------------------------------------------------------------+
//| Fonction de test (pour le Strategy Tester)                       |
//+------------------------------------------------------------------+
double OnTester()
{
    // Retourne le profit pour l'optimisation
    return TesterStatistics(STAT_PROFIT);
}

//+------------------------------------------------------------------+