// RiskManager.mqh - Gestion des risques et paramètres de trading
#ifndef RISKMANAGER_MQH
#define RISKMANAGER_MQH

// Paramètres de risque
input double FixedLotSize = 0.1;          // Taille de lot fixe
input int StopLossPips = 30;              // Stop loss en pips
input int TakeProfitPips = 60;            // Take profit en pips

// Fonction pour calculer le stop loss en points
int CalculateStopLossPoints()
{
    return (int)(StopLossPips * _Point * 10);  // Conversion pips -> points
}

// Fonction pour calculer le take profit en points
int CalculateTakeProfitPoints()
{
    return (int)(TakeProfitPips * _Point * 10); // Conversion pips -> points
}

// Fonction pour obtenir la taille de lot
double GetLotSize()
{
    return FixedLotSize;
}

#endif