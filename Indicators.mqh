// Indicators.mqh - Gestion des indicateurs techniques
#ifndef INDICATORS_MQH
#define INDICATORS_MQH

// Paramètres des moyennes mobiles
input int FastMAPeriod = 20;              // Période MA rapide
input int SlowMAPeriod = 50;              // Période MA lente
input ENUM_MA_METHOD MAMethod = MODE_SMA; // Méthode de calcul
input ENUM_APPLIED_PRICE MAPrice = PRICE_CLOSE; // Prix appliqué

// Handles pour les indicateurs
int fastMAHandle;
int slowMAHandle;

// Fonction d'initialisation des indicateurs
bool InitializeIndicators()
{
    fastMAHandle = iMA(_Symbol, _Period, FastMAPeriod, 0, MAMethod, MAPrice);
    slowMAHandle = iMA(_Symbol, _Period, SlowMAPeriod, 0, MAMethod, MAPrice);
    
    if(fastMAHandle == INVALID_HANDLE || slowMAHandle == INVALID_HANDLE)
    {
        Print("Erreur lors de la création des indicateurs MA");
        return false;
    }
    
    return true;
}

// Fonction pour obtenir les valeurs des MA
bool GetMAValues(double &fastMA[], double &slowMA[])
{
    if(CopyBuffer(fastMAHandle, 0, 0, 3, fastMA) < 3 ||
       CopyBuffer(slowMAHandle, 0, 0, 3, slowMA) < 3)
    {
        Print("Erreur lors de la copie des données MA");
        return false;
    }
    
    return true;
}

// Fonction de déinitialisation des indicateurs
void DeinitializeIndicators()
{
    if(fastMAHandle != INVALID_HANDLE)
        IndicatorRelease(fastMAHandle);
    if(slowMAHandle != INVALID_HANDLE)
        IndicatorRelease(slowMAHandle);
}

#endif