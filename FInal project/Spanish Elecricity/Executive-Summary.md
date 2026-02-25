## Executive Summary — Spanish Electricity Market Analysis

This project analyzes the structural drivers of electricity prices in Spain by combining wholesale hourly price data (PVPC) with generation mix telemetry from Red Eléctrica de España (REE).

The objective was to understand how different generation technologies — particularly renewable, fossil, and nuclear — influence price formation in the Iberian electricity market.

## Data Sources

Two independent raw datasets were integrated:

### 1. PVPC Hourly Prices (2020–2026)

* Extracted from XML market price archives
* Cleaned, filtered, and transformed into canonical hourly price series

### 2. Aggregated Generation Output (AggGenOutput)

* Hourly generation by technology (psrType classification)
* Parsed from GL_MarketDocument XML telemetry feeds

Both datasets were aligned temporally and merged into a unified analytical dataset.

## Methodology

Key transformation steps included:

* XML parsing and normalization
* Technology classification (renewable, fossil, nuclear)
* Hourly aggregation
* Timezone alignment
* Feature engineering:
* Renewable share
* Fossil generation total
* Nuclear baseload output
* Tariff spread metrics

To ensure methodological consistency, comparative analysis focused on identical winter periods (January 2024–2026).

## Key Findings
### 1️. Fossil generation is the primary price driver

Correlation analysis shows a strong and consistent positive relationship between fossil generation and electricity prices:

* Mean correlation: +0.54
* Range: +0.50 → +0.57

This confirms fossil plants — particularly gas — act as marginal price setters in Spain’s merit-order market structure.

### 2. Renewable penetration suppresses electricity prices

Renewable share exhibits a stable negative correlation with prices:

* Mean correlation: −0.27
* Low inter-annual variability

This reflects the merit-order effect, where low marginal cost renewable generation displaces fossil dispatch and lowers clearing prices.

### 3. Nuclear generation stabilizes price dynamics

Nuclear output shows weaker but consistently negative correlations:

* Mean correlation: −0.22

As baseload generation, nuclear reduces scarcity risk and dampens price volatility rather than actively driving price levels.

## Structural Insight

Cross-year statistical stability confirms these relationships are structural rather than incidental:

| Driver	    | Mean Corr     | Std Dev
| ------------- | ------------- | ----------
| Fossil        | +0.54         | 0.04
| Renewable     | -0.27         | 0.02
| Nuclear       | -0.22         | 0.11


Low dispersion across years strengthens the robustness of the findings.

## Conclusion

The Spanish electricity market demonstrates clear merit-order dynamics:

* Fossil generation drives price increases
* Renewable penetration suppresses prices
* Nuclear provides system stability

**These findings align with established electricity market theory and validate the explanatory power of generation mix in price formation.**