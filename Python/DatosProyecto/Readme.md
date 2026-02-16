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

# 2. Dataset Overview

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

# 3. Data Cleaning & Validation

## 3.1 Data Types

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

## 3.2 Categorical Consistency

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

## 3.3 Unknown / Missing Categories

We validated whether “unknown” categories existed:

```python
bank.eq("unknown").sum()
```

No unknown values were present, reducing the need for categorical imputation.

---

# 4. Special Value Investigation — `pdays`

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

# 5. Feature Engineering

To better capture campaign dynamics, we engineered binary segmentation variables.

## 5.1 Contact History Flag

```python
bank["contacted_before"] = (bank["previous"] > 0).astype(int)
```

Meaning:

* 0 → First-time contact
* 1 → Previously contacted

This variable isolates relationship history.

---

## 5.2 Contact Recency Flag

```python
bank["recent_contact"] = (bank["pdays"] != 999).astype(int)
```

Meaning:

* 0 → No recent prior contact
* 1 → Recent prior contact

This captures recency effect.

---

# 6. Target Encoding

To enable numeric aggregation and conversion rate calculations, the target variable was encoded as a binary numeric field:

```python
bank["y_num"] = bank["y"].map({"yes": 1, "no": 0})
```

Where:

* 1 → Client subscribed
* 0 → Client did not subscribe

This transformation allows direct computation of subscription rates using averages.

---

# 7. Contact History & Recency Impact

To assess the influence of prior interactions on campaign success, two complementary segmentation variables were engineered:

## 7.1 Contact History Flag

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

## 7.2 Contact Recency Flag

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

## 7.3 Duration Bias Consideration

Further investigation revealed that recently contacted clients experienced longer call durations on average:

| Segment           | Avg Duration |
| ----------------- | ------------ |
| No recent contact | 255 sec      |
| Recent contact    | 320 sec      |

Since call duration strongly correlates with successful subscription outcomes, this partially explains the elevated conversion rate observed in the recent contact segment.

---

## 7.4 Key Takeaways

* Prior contact history significantly increases conversion likelihood
* Recent interactions amplify subscription success even further
* Call engagement duration contributes to performance differences
* Follow-up and warm-lead strategies outperform cold outreach

These findings reinforce the strategic value of customer relationship continuity in marketing campaigns.


---

## 8. Duration Bias Validation

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

⚠️ Note: Call duration is recorded post-interaction and cannot be used for predictive modeling, but remains valuable for descriptive performance analysis.

---

## 9. Conversion by Professional Segment

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

## 10. Strategic Targeting Implications

The job segmentation analysis provides actionable campaign optimization insights:

| Strategy Lever           | Recommendation                           |
| ------------------------ | ---------------------------------------- |
| High conversion segments | Prioritize outreach (Students, Retired)  |
| High volume segments     | Maintain investment (Admin, Technicians) |
| Low conversion segments  | Reassess messaging or targeting          |

This segmentation enables marketing resource allocation based on both responsiveness and reach.

---

## 11. Analytical Validation Principles Applied

Throughout this phase, several validation checks ensured insight reliability:

* Segment size verification
* Conversion rate normalization
* Behavioral bias investigation (duration)
* Encoded value interpretation (pdays)

This approach ensured that findings were not only statistically correct but also contextually meaningful.

---

## 12. Current Insight Maturity

At this stage, the analysis has identified three primary campaign performance drivers:

| Driver                | Impact Level              |
| --------------------- | ------------------------- |
| Prior contact history | High                      |
| Contact recency       | High (with duration bias) |
| Professional segment  | High                      |

These variables form the foundation for deeper segmentation and predictive modeling exploration.

---





