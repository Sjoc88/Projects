# Spanish Electricity Market Analysis


## Project Overview
This project analyzes the structural drivers of electricity prices in Spain by combining wholesale price data with generation telemetry.

The objective is to understand how renewable, fossil, and nuclear generation influence price formation.



## Data Sources

### 1. PVPC Electricity Prices
- Hourly wholesale price data - XML archives (2020–2026)
- Source: Red Eléctrica de España (REE)

### 2. Aggregated Generation Output
- Hourly generation by technology
- Source: Red Eléctrica de España (REE)



## Methodology

- XML parsing and transformation
- Data cleaning and normalization
- Temporal alignment
- Feature engineering:
  - Renewable share
  - Fossil generation
  - Nuclear output
- Correlation analysis



## Key Insights

- Fossil generation is the primary price driver
- Renewable penetration suppresses prices
- Nuclear stabilizes price volatility



## Tools & Technologies

- Python
- Pandas
- Matplotlib



## Repository Structure

```python
data/
 |
 ├─ PVPC 2020/
 |    ├─ PVPCDesglocehorario
 │    ├─ pvpc_xml/
 │      └─ datos_xml_limpios
 |
 ├─ PVPC 2021/
 |    ├─ PVPCDesglocehorario
 │    ├─ pvpc_xml/
 │      └─ datos_xml_limpios
 |
 ├─ PVPC 2022/
 |    ├─ PVPCDesglocehorario
 │    ├─ pvpc_xml/
 │      └─ datos_xml_limpios
 |
 ├─ PVPC 2023/
 |    ├─ PVPCDesglocehorario
 │    ├─ pvpc_xml/
 │      └─ datos_xml_limpios.csv
 |
 ├─ PVPC 2024/
 |    ├─ PVPCDesglocehorario
 │    ├─ pvpc_xml/
 │      └─ datos_xml_limpios.csv
 |
 ├─ PVPC 2025/
 |    ├─ PVPCDesglocehorario
 │    ├─ pvpc_xml/
 │      └─ datos_xml_limpios.csv
 |
 ├─ PVPC 2026/
 |    ├─ PVPCDesglocehorario
 │    ├─ pvpc_xml/
 │      └─ datos_xml_limpios.csv
 │
 ├─ REE_AggGenOutput/
 │   ├─ Agg_xml/
 │   ├─ agg_gen_output_long
 │   └─ datos_xml_limpios.csv
 │
 └─ pvp_wide.csv
```

## Code review

### > PVP - Hourly price

First we uploaded and concatenate the cleaned data from each year together and then run a quick shape and head() to ensure our 'PVP_all' loaded and merged well.

Then we have to format the date column in datetime and bring the 'hour' column in and ran a quick min(), max() to ensure df was complete.

Finally we exported PVP_all into a csv file

### > Tariff - Tariff Segmentation

Soon enough in our analysis we ran into this key 'TipoPrecio' column which intrigued us and had 5 different entries. We were wondering wether it was a tariff segmentation based on geography, time of the day, or low/normal/pick clusters. 

After reading about a tariff regulation change that happened mid 2021, we needed to check this information using our datetime dataset and see what happens data wise before May 2021 and after May 2021. 

Using both map() and lambda() functions, we establish an [Era] to identify tariffs pre and post reform to confirm our intuition, with the following information:

* Z14/Z24 = legacy tariffs (pre-June 2021)
* Z01/Z02/Z03 = new 2.0TD periods (post-June 2021)

What we wanted to know was: Did tariff reform change price volatility? and the answer is YES

### > AGG - Aggregated Generation Output (by energy source)

For the next part of our code, we focused on searching additional data on the REE website to answer this key question: Why do electricity prices move the way they do?

The AggGenOutput data tipically look at the Hourly electricity generation in MW, aggregated at system level and broken down by generation technology, following this codes;

| Code | Technology     |
|------|----------------|
| B01  | Biomass        |
| B02  | Fossil Brown   |
| B03  | Fossil Coal    |
| B04  | Fossil Gas     |
| B05  | Fossil Oil     |
| B06  | Hydro pumped   |
| B07  | Hydro river    |
| B08  | Hydro Reseroir |
| B09  | Geothermal     |
| B10  | Nuclear        |
| B11  | Solar          |
| B16  | Wind Onshore   |
| B18  | Wind Offshore  |

```python
datetime × technology → MW generated
```

Very tricky part of the project since each file need to be dowloaded individually for each day and can take as long as 2 to 3 minutes. So we wanted to focus on January of all available years (2024, 2025 & 2026) to understand the impact of other energy sources on the final price of electricity.

### > MERGE

At this stage, we faced several complexities mostly due to the datetime format, which was different from both our PVP and AGG EDAs, so our code kept showing **"ValueError: You are trying to merge on datetime64[ns] and datetime64[ns, UTC] columns for key 'datetime'. If you wish to proceed you should use pd.concat"** which makes sense since we had 

| Dataset     | Dtype                 |
| ----------- | --------------------- |
| pvp_hourly  | datetime64[ns]        |
| gen_wide    | datetime64[ns, UTC]   |

Since AggGenOutput XML uses UTC (+00:00), and electricity markets are usually handled in UTC internally, we decided to convert everything in UTC

```python
### Formatting datetime as timezone-aware (UTC)

pvp_hourly["datetime"] = (
    pd.to_datetime(pvp_hourly["datetime"])
    .dt.tz_localize("UTC")
```

Following the previous creation of energy bucket to understand macro drviers for prices we wanted to make sure we were getting rows generated that would match our buckets based on our merged dataset, which worked and based on 3 months of winter data (January 24', 25' and 26'), we are able to now run a first driver correlation.

### > Analysis

Descriptive statistics of year-by-year correlations reveal a high degree of stability in the relationship between electricity prices and generation mix. Fossil generation consistently exhibits a strong positive correlation with prices (mean +0.54, std 0.04), confirming its role as marginal price setter. Renewable share shows a stable negative correlation (mean −0.27, std 0.02), evidencing a persistent merit-order price suppression effect. Nuclear generation displays weaker and more variable correlations, consistent with its role as baseload rather than a marginal driver.