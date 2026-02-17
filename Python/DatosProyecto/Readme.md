# Marketing Campaign Analysis — Portuguese Bank

## 1. Project Objective

The goal of this analysis is to explore and understand the performance drivers of a Portuguese bank’s marketing campaign dataset.

The dataset contains demographic, financial, and campaign interaction variables, with the target variable `y` indicating whether a client subscribed to the promoted product/service.

This work focuses on:

* Exploratory Data Analysis (EDA)
* Data cleaning & validation
* Feature engineering
* Early business insights

---

## 2. Dataset Overview

Initial dataset exploration was conducted using Pandas to understand structure and quality.

Key commands used:

```python
bank.shape
bank.columns
bank.info()
bank.describe()
```

This allowed us to identify:

* Number of records and variables
* Data types
* Presence of null values
* Numeric distributions

No critical missing values or structural data integrity issues were detected at this stage.

---

## 3. Data Cleaning & Validation

### 3.1 Data Types

The `age` variable was initially stored as a float.

Validation steps:

```python
bank["age"].describe()
bank["age"].isnull().sum()
```

Since no decimals or nulls were found, the column could safely be converted to integer if needed:

```python
bank["age"] = bank["age"].astype(int)
```

However, this did not materially impact analysis, so it was treated as a low-priority cleaning task.

---

### 3.2 Categorical Consistency

We verified that categorical variables did not contain typos or formatting inconsistencies.

Checked columns included:

* job
* marital
* education
* contact

Validation method:

```python
bank["job"].unique()
```

No trimming or text normalization was required, as categories were standardized.

---

### 3.3 Unknown / Missing Categories

We validated whether “unknown” categories existed:

```python
bank.eq("unknown").sum()
```

No unknown values were present, reducing the need for categorical imputation.

---

## 4. Special Value Investigation — `pdays`

The variable `pdays` represents:

> Days since the client was last contacted prior to the current campaign.

A high volume of value `999` was observed (~40K records), prompting investigation.

### Validation Test

```python
bank[bank["pdays"] == 999]["previous"].value_counts()
```

Findings:

* Majority had `previous = 0` → never contacted before
* Minority had prior contacts but no recency recorded

### Interpretation

Value `999` encodes:

* Clients never contacted before
* Or clients with no recent contact history available

Thus, `999` is not an error but a meaningful encoded category.

---

## 5. Feature Engineering

To better capture campaign dynamics, we engineered binary segmentation variables.

### 5.1 Contact History Flag

```python
bank["contacted_before"] = (bank["previous"] > 0).astype(int)
```

Meaning:

* 0 → First-time contact
* 1 → Previously contacted

This variable isolates relationship history.

---

### 5.2 Contact Recency Flag

```python
bank["recent_contact"] = (bank["pdays"] != 999).astype(int)
```

Meaning:

* 0 → No recent prior contact
* 1 → Recent prior contact

This captures recency effect.

---

## 6. Target Encoding

To enable numeric aggregation and conversion rate calculations, the target variable was encoded as a binary numeric field:

```python
bank["y_num"] = bank["y"].map({"yes": 1, "no": 0})
```

Where:

* 1 → Client subscribed
* 0 → Client did not subscribe

This transformation allows direct computation of subscription rates using averages.

---

## 7. Contact History & Recency Impact

To assess the influence of prior interactions on campaign success, two complementary segmentation variables were engineered:

### 7.1 Contact History Flag

```python
bank["contacted_before"] = (bank["previous"] > 0).astype(int)
```

This variable distinguishes between:

* First-time contacts
* Previously contacted clients

### Conversion Results

| Segment              | Conversion Rate |
| -------------------- | --------------- |
| Never contacted      | ~9%             |
| Previously contacted | ~27%            |

### Insight

Clients previously contacted are approximately **3× more likely** to subscribe than first-time contacts.

This highlights the importance of follow-up campaigns and relationship-building in marketing effectiveness.

---

### 7.2 Contact Recency Flag

To capture recency effects, we engineered an additional variable based on the `pdays` field:

```python
bank["recent_contact"] = (bank["pdays"] != 999).astype(int)
```

This segmentation identifies whether a client had a recent prior interaction before the current campaign.

### Conversion Results

| Segment           | Conversion Rate |
| ----------------- | --------------- |
| No recent contact | 9.2%            |
| Recent contact    | 64.0%           |

### Interpretation

Clients with recent prior contact demonstrate significantly higher subscription rates.

However, this segment represents only ~3.7% of the dataset (1,588 of 43K+ records), requiring cautious interpretation due to sample size imbalance.

---

### 7.3 Duration Bias Consideration

Further investigation revealed that recently contacted clients experienced longer call durations on average:

| Segment           | Avg Duration |
| ----------------- | ------------ |
| No recent contact | 255 sec      |
| Recent contact    | 320 sec      |

Since call duration strongly correlates with successful subscription outcomes, this partially explains the elevated conversion rate observed in the recent contact segment.

---

### 7.4 Duration Bias Validation

Given the unusually high conversion rate among recently contacted clients, we investigated whether call duration influenced outcomes.

```python
bank.groupby("recent_contact")["duration"].mean()
```

#### Results

| Segment           | Avg Call Duration |
| ----------------- | ----------------- |
| No recent contact | 255 sec           |
| Recent contact    | 320 sec           |

### Insight

Recently contacted clients experienced calls that were ~25% longer on average.

Since call duration is strongly correlated with successful subscription outcomes, this partially explains the elevated conversion rate observed in this segment.

---

### 7.5 Key Takeaways

* Prior contact history significantly increases conversion likelihood
* Recent interactions amplify subscription success even further
* Call engagement duration contributes to performance differences
* Follow-up and warm-lead strategies outperform cold outreach

These findings reinforce the strategic value of customer relationship continuity in marketing campaigns.


---

## 8. Conversion by Professional Segment

To identify high-performing demographic targets, conversion rates were analyzed across job categories.

```python
bank.groupby("job")["y_num"].agg(["count","mean"]).sort_values("mean", ascending=False)
```

### Top Performing Segments

| Job        | Conversion Rate | Volume |
| ---------- | --------------- | ------ |
| Student    | 31.3%           | 903    |
| Retired    | 25.2%           | 1,790  |
| Unemployed | 14.4%           | 1,063  |

#### Interpretation

* **Students** show the highest responsiveness, potentially driven by early financial planning needs.
* **Retired clients** represent a high-value segment, likely due to savings orientation and availability for engagement.
* **Unemployed individuals** may demonstrate increased receptiveness to financial opportunities.

---

### Mid-Tier Segments

| Job           | Conversion Rate |
| ------------- | --------------- |
| Admin         | 13.0%           |
| Management    | 11.2%           |
| Technician    | 10.8%           |
| Self-employed | 10.8%           |

These segments align closely with overall campaign averages and represent stable baseline performers.

---

### Lower Performing Segments

| Job          | Conversion Rate |
| ------------ | --------------- |
| Services     | 8.0%            |
| Entrepreneur | 8.3%            |
| Housemaid    | 9.9%            |

These groups demonstrate comparatively lower engagement, suggesting either reduced campaign resonance or accessibility constraints.

---

## 9. Conversion by Marital Segment


---

## 10. Current Insight Maturity

At this stage, the analysis has identified three primary campaign performance drivers:

| Driver                | Impact Level              |
| --------------------- | ------------------------- |
| Prior contact history | High                      |
| Contact recency       | High (with duration bias) |
| Professional segment  | High                      |
| Marital status        | Moderate                  |

These variables form the foundation for deeper segmentation and predictive modeling exploration.

---

## 11. Temporal Segmentation

### Initial Hypothesis

Temporal dynamics were explored as a potential driver of campaign performance under the assumption that seasonality, macroeconomic cycles, or customer financial behavior trends could influence subscription likelihood.

Time-based segmentation was evaluated across multiple granularities:

* Year
* Month
* Quarter

---

### Methodology

To enable temporal analysis, the campaign interaction date field was first standardized.

**1. Date Parsing**

The original dataset contained non-standard Spanish-formatted dates (e.g., `2-agosto-2019`).
Month names were translated to English and converted into datetime format:

```python
bank["date"] = pd.to_datetime(bank["date"], dayfirst=True)
```

---

**2. Feature Extraction**

Time attributes were derived from the parsed date:

```python
bank["year"] = bank["date"].dt.year
bank["month"] = bank["date"].dt.month
bank["quarter"] = bank["date"].dt.quarter
```

---

### Conversion Analysis

Subscription rates were then evaluated across each temporal dimension.

---

#### Conversion by Year

```python
bank.groupby("year")["y_num"].mean()
```

**Observed Range:** ~10.8% → ~11.7%

This narrow spread indicates stable campaign performance across years.

---

#### Conversion by Month

```python
bank.groupby("month")["y_num"].mean()
```

**Observed Range:** ~10.7% → ~12.4%

Minor variation was observed, with slightly higher performance in October and marginally lower performance in early spring months.

However, differences remained limited in magnitude.

---

#### Conversion by Quarter

```python
bank.groupby("quarter")["y_num"].mean()
```

**Observed Range:** ~11.0% → ~11.8%

Quarterly analysis further confirmed minimal seasonal fluctuation.

---

### Observations

Key findings include:

* No strong seasonal conversion peaks
* Stable subscription rates across calendar periods
* Limited variance between best and worst performing months
* No structural performance trend over years

---

### Analytical Conclusion

Temporal factors were determined to have low explanatory power in predicting subscription outcomes.

Campaign performance appears largely time-independent, suggesting:

* Product appeal remains consistent year-round
* Outreach effectiveness does not rely on seasonal timing
* Budget allocation need not prioritize specific campaign windows

---

### Strategic Implication

Given the absence of meaningful temporal performance variation, campaign optimization efforts should prioritize:

* Behavioral segmentation
* Demographic targeting
* Engagement depth
* Contact recency

rather than time-based outreach scheduling.

---


## 12 Geographic Segmentation

### Initial Hypothesis

Geographic location was explored as a potential driver of campaign performance under the assumption that regional socioeconomic factors, banking penetration, or localized marketing strategies could influence subscription behavior.

Latitude and longitude coordinates present in the dataset enabled spatial segmentation testing.

---

### Methodology

To evaluate geographic influence, multiple spatial aggregation approaches were implemented:

**1. Coordinate Binning**

```python
bank["lat_bin"] = bank["latitude"].round(1)
bank["lon_bin"] = bank["longitude"].round(1)
```

This grouped nearby clients into geographic zones.

---

**2. Conversion Rate by Spatial Zones**

```python
bank.groupby(["lat_bin","lon_bin"])["y_num"].agg(["count","mean"])
```

This allowed identification of potential high-performing geographic clusters.

---

**3. Volume Filtering**

To ensure statistical reliability, low-density zones were filtered:

```python
.query("count >= threshold")
```

This removed micro-clusters driven by single-client outcomes.

---

### Observations

Findings revealed:

* Extremely sparse geographic clusters
* Most spatial cells contained fewer than five clients
* Conversion rates were highly volatile at micro-location level
* No dense or statistically stable geographic hotspots emerged

Latitude-only aggregation showed moderate variation, while longitude segmentation exhibited minimal differentiation — consistent with Portugal’s limited east–west geographic span.

---

### External Geographic Validation

To confirm interpretability, sampled coordinate pairs were cross-referenced using Google Maps.

This validation revealed that many latitude/longitude combinations did not correspond to real Portuguese locations (e.g., coordinates mapping to regions such as Calgary, Canada).

This strongly indicates that spatial coordinates were:

* Anonymized
* Synthetic
* Or geographically obfuscated

---

### Analytical Conclusion

Due to sparse clustering and non-representative geographic coordinates, spatial segmentation was determined to lack business interpretability.

As a result:

* Geographic targeting was deprioritized
* Campaign performance analysis focused on behavioral and demographic drivers instead

---

## 13. Updated Insight Maturity

At this stage, the analysis has analysed six campaign performance drivers:

| Driver                | Impact Level              |
| --------------------- | ------------------------- |
| Prior contact history | High                      |
| Contact recency       | High                      |
| Professional segment  | High                      |
| Marital Status        | Moderate                  |
| Duration              | Moderate                  |
| Temporal              | Low                       |
| Geographical          | Low                       |


---

# EXECUTIVE SUMMARY

## 1 Final Segmentation Synthesis

Following comprehensive exploratory analysis, multiple segmentation dimensions were evaluated to identify the primary drivers of marketing campaign performance.

These dimensions included:

* Behavioral interaction history
* Contact recency
* Professional demographics
* Engagement duration
* Temporal patterns
* Geographic distribution

Each dimension was assessed for statistical strength, business interpretability, and strategic actionability.

---

### 1.1 Driver Strength Hierarchy

| Segmentation Axis    | Impact on Conversion | Strategic Value |
| -------------------- | -------------------- | --------------- |
| Contact History      | High                 | High            |
| Contact Recency      | High                 | High            |
| Call Duration        | High                 | High            |
| Professional Segment | High                 | High            |
| Marital Status       | Moderate             | Moderate        |
| Temporal Factors     | Low                  | Moderate        |
| Geographic Location  | Negligible           | Low             |

---

### 1.2 Primary Performance Drivers

#### **Prior Contact History**

Clients previously engaged in earlier campaigns demonstrated significantly higher subscription rates (~27%) compared to first-time contacts (~9%).

This confirms the effectiveness of follow-up engagement strategies and relationship continuity.

---

#### **Contact Recency**

Clients with recent prior interactions exhibited the highest observed subscription rates (~64%).

However, this segment represents a small portion of the dataset (~4%) and is partially influenced by longer engagement durations.

---

#### **Engagement Duration**

Longer call durations strongly correlate with successful subscription outcomes.

Recently contacted clients averaged ~25% longer calls, reinforcing engagement depth as a key conversion lever.

---

#### **Professional Segmentation**

Occupation-based analysis identified high-performing demographic targets:

Top segments:

* Students (~31%)
* Retired clients (~25%)

These groups demonstrate heightened financial receptiveness and engagement availability.

---

#### **Marital Segmentation**

Marital-based analysis identified high-performing demographic targets:

Top segment:

* Singles (~14%)

---

### 1.3 Secondary & Low-Impact Drivers

#### **Temporal Factors**

Analysis across years, months, and quarters revealed minimal variation in subscription rates (~10.8%–11.7%).

This indicates campaign performance remains stable over time, with no strong seasonality effects.

---

#### **Geographic Segmentation**

Initial geographic segmentation using latitude and longitude binning revealed sparse spatial clustering.

Further validation determined that coordinate values did not correspond to real Portuguese geographic locations, suggesting anonymization or synthetic data generation.

As a result, geographic analysis was deprioritized due to limited business interpretability.

---

### 1.4 Strategic Targeting Implications

Key optimization levers identified:

| Strategy Lever        | Recommendation                          |
| --------------------- | --------------------------------------- |
| Follow-up outreach    | Prioritize previously contacted clients |
| Warm lead targeting   | Focus on recent interactions            |
| Call engagement       | Invest in longer interaction quality    |
| Demographic targeting | Prioritize students and retirees        |
| Marital status        | Prioritize singles                      |
| Seasonality timing    | Low priority optimization               |
| Geographic targeting  | Not recommended based on dataset        |

---

### 1.5 Analytical Conclusion

Campaign success is primarily driven by behavioral and engagement factors rather than temporal or geographic conditions.

The most effective targeting strategies should therefore emphasize:

* Relationship continuity
* Lead recency
* Engagement depth
* Demographic receptiveness
* Students tends to be single

These insights provide a strong foundation for predictive modeling, campaign optimization, and marketing resource allocation initiatives.

---


