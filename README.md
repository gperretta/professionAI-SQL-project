## Analisi dei clienti di una banca
### Descrizione del Progetto
L'azienda Banking Intelligence vuole sviluppare un modello di machine learning supervisionato per prevedere i comportamenti futuri dei propri clienti, basandosi sui dati transazionali e sulle caratteristiche del possesso di prodotti. Lo scopo del progetto è creare una tabella denormalizzata con una serie di indicatori (feature) derivati dalle tabelle disponibili nel database, che rappresentano i comportamenti e le attività finanziarie dei clienti.
### Obiettivo
Il nostro obiettivo è creare una tabella di feature per il training di modelli di machine learning, arricchendo i dati dei clienti con vari indicatori calcolati a partire dalle loro transazioni e dai conti posseduti. La tabella finale sarà riferita all'ID cliente e conterrà informazioni sia di tipo quantitativo che qualitativo.
### Struttura del Database
Il database è costituito dalle seguenti tabelle:
- **Cliente:** contiene informazioni personali sui clienti (ad esempio, età).
- **Conto:** contiene informazioni sui conti posseduti dai clienti.
- **Tipo_conto:** descrive le diverse tipologie di conti disponibili.
- **Tipo_transazione:** contiene i tipi di transazione che possono avvenire sui conti.
- **Transazioni:** contiene i dettagli delle transazioni effettuate dai clienti sui vari conti.
### Indicatori Comportamentali da Calcolare
Gli indicatori saranno calcolati per ogni singolo cliente (riferiti a *id_cliente*) e includono:

#### Indicatori di base
1. Età del cliente (da tabella cliente).
#### Indicatori sulle transazioni
2. Numero di transazioni in uscita su tutti i conti.
3. Numero di transazioni in entrata su tutti i conti.
4. Importo totale transato in uscita su tutti i conti.
5. Importo totale transato in entrata su tutti i conti.
#### Indicatori sui conti
6. Numero totale di conti posseduti.
7. Numero di conti posseduti per tipologia (un indicatore per ogni tipo di conto).
#### Indicatori sulle transazioni per tipologia di conto
8. Numero di transazioni in uscita per tipologia di conto (un indicatore per tipo di conto).
9. Numero di transazioni in entrata per tipologia di conto (un indicatore per tipo di conto).
10. Importo transato in uscita per tipologia di conto (un indicatore per tipo di conto).
11. Importo transato in entrata per tipologia di conto (un indicatore per tipo di conto).
