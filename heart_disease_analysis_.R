
# Exploratory Data Analysis: UCI Heart Disease Dataset (Cleveland subset)
# Source: UCI Machine Learning Repository (CC BY 4.0)
#         https://archive.ics.uci.edu/dataset/45/heart+disease
#
# Setup (run once in the console, not in this script):
#   install.packages(c("tidyverse", "effectsize"))
#
# Run this script from the project root folder, with the data file located at:
#   data/processed.cleveland.data

# Libraries
library(tidyverse)
library(effectsize)

# Load data 
file_path <- "data/processed.cleveland.data"

col_names <- c("age", "sex", "cp", "trestbps", "chol", "fbs", "restecg",
               "thalach", "exang", "oldpeak", "slope", "ca", "thal", "num")

# Missing values are coded as "?" in the raw file; na.strings converts them to NA
heart <- read.csv(file_path, header = FALSE,
                  col.names = col_names, na.strings = "?")

head(heart)
dim(heart)
names(heart)

#  Data cleaning 
heart <- heart %>%
  mutate(
    # num: 0 = no disease, 1-4 = disease present -> binary outcome
    heart_disease = ifelse(num > 0, "Disease", "No Disease"),
    heart_disease = factor(heart_disease, levels = c("No Disease", "Disease")),

    sex = ifelse(sex == 1, "Male", "Female"),
    sex = factor(sex, levels = c("Female", "Male")),

    cp = factor(cp,
                levels = c(1, 2, 3, 4),
                labels = c("Typical Angina", "Atypical Angina",
                           "Non-anginal Pain", "Asymptomatic"))
  )

# Number of observations and variables
cat("Number of observations (rows):", nrow(heart), "\n")
cat("Number of variables (columns):", ncol(heart), "\n")
str(heart)

# Missing values 
missing_summary <- colSums(is.na(heart)) %>%
  as.data.frame() %>%
  rownames_to_column("variable") %>%
  rename(missing_count = 2) %>%
  filter(missing_count > 0) %>%
  arrange(desc(missing_count))

print(missing_summary)

# Age distribution 
heart %>%
  summarise(
    mean_age   = mean(age),
    median_age = median(age),
    sd_age     = sd(age),
    min_age    = min(age),
    max_age    = max(age)
  )

# Plot 1: Histogram of age distribution
ggplot(heart, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "steelblue", color = "white") +
  labs(title = "Age Distribution of Patients",
       x = "Age", y = "Number of Patients") +
  theme_minimal()

# Heart disease counts 
heart %>%
  group_by(heart_disease) %>%
  summarise(
    count = n(),
    percentage = round(n() / nrow(heart) * 100, 1)
  )

# Age by heart disease status 
heart %>%
  group_by(heart_disease) %>%
  summarise(
    mean_age = mean(age),
    median_age = median(age),
    sd_age = sd(age)
  )

# Plot 2: Boxplot comparing age between the two groups
ggplot(heart, aes(x = heart_disease, y = age, fill = heart_disease)) +
  geom_boxplot() +
  labs(title = "Age Distribution by Heart Disease Status",
       x = "Heart Disease Status", y = "Age") +
  theme_minimal() +
  theme(legend.position = "none")

# Cholesterol by heart disease status 
heart %>%
  group_by(heart_disease) %>%
  summarise(
    mean_chol = mean(chol, na.rm = TRUE),
    median_chol = median(chol, na.rm = TRUE),
    sd_chol = sd(chol, na.rm = TRUE)
  )

t.test(chol ~ heart_disease, data = heart)

# Plot 3: Boxplot comparing cholesterol
ggplot(heart, aes(x = heart_disease, y = chol, fill = heart_disease)) +
  geom_boxplot() +
  labs(title = "Cholesterol Distribution by Heart Disease Status",
       x = "Heart Disease Status", y = "Cholesterol (mg/dl)") +
  theme_minimal() +
  theme(legend.position = "none")

#  Maximum heart rate (thalach) by heart disease status 
heart %>%
  group_by(heart_disease) %>%
  summarise(
    mean_thalach = mean(thalach, na.rm = TRUE),
    median_thalach = median(thalach, na.rm = TRUE),
    sd_thalach = sd(thalach, na.rm = TRUE)
  )

t.test(thalach ~ heart_disease, data = heart)

# Plot 4: Boxplot comparing maximum heart rate
ggplot(heart, aes(x = heart_disease, y = thalach, fill = heart_disease)) +
  geom_boxplot() +
  labs(title = "Maximum Heart Rate by Heart Disease Status",
       x = "Heart Disease Status", y = "Maximum Heart Rate (thalach)") +
  theme_minimal() +
  theme(legend.position = "none")

# Sex vs. heart disease 
heart %>%
  group_by(sex, heart_disease) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(sex) %>%
  mutate(percentage = round(count / sum(count) * 100, 1)) %>%
  arrange(sex, heart_disease)

# Plot 5: Proportional bar chart for two categorical variables
ggplot(heart, aes(x = sex, fill = heart_disease)) +
  geom_bar(position = "fill") +
  labs(title = "Heart Disease Rate by Sex",
       x = "Sex", y = "Proportion", fill = "Status") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal()

#  Chest pain type vs. heart disease 
heart %>%
  group_by(cp, heart_disease) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(cp) %>%
  mutate(percentage = round(count / sum(count) * 100, 1)) %>%
  arrange(desc(percentage))

# Plot 6: Proportional bar chart for chest pain type
ggplot(heart, aes(x = cp, fill = heart_disease)) +
  geom_bar(position = "fill") +
  labs(title = "Heart Disease Rate by Chest Pain Type",
       x = "Chest Pain Type", y = "Proportion", fill = "Status") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 20, hjust = 1))

#  Additional findings 

# Finding 1: Does maximum heart rate (thalach) decrease with age, and does
# this relationship differ by heart disease group?
ggplot(heart, aes(x = age, y = thalach, color = heart_disease)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Relationship Between Age and Maximum Heart Rate",
       x = "Age", y = "Maximum Heart Rate (thalach)", color = "Status") +
  theme_minimal()

# Finding 2: Relationship between exercise-induced angina (exang) and heart disease
heart %>%
  mutate(exang_label = ifelse(exang == 1, "Yes", "No")) %>%
  group_by(exang_label, heart_disease) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(exang_label) %>%
  mutate(percentage = round(count / sum(count) * 100, 1))

heart %>%
  mutate(exang_label = ifelse(exang == 1, "Yes", "No")) %>%
  ggplot(aes(x = exang_label, fill = heart_disease)) +
  geom_bar(position = "fill") +
  labs(title = "Exercise-Induced Angina and Heart Disease",
       x = "Exercise-Induced Angina (exang)", y = "Proportion", fill = "Status") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal()

# Finding 3: Is ST depression (oldpeak) different between groups?
heart %>%
  group_by(heart_disease) %>%
  summarise(
    mean_oldpeak = mean(oldpeak, na.rm = TRUE),
    median_oldpeak = median(oldpeak, na.rm = TRUE)
  )

ggplot(heart, aes(x = heart_disease, y = oldpeak, fill = heart_disease)) +
  geom_boxplot() +
  labs(title = "ST Depression (oldpeak) by Heart Disease Status",
       x = "Heart Disease Status", y = "Oldpeak") +
  theme_minimal() +
  theme(legend.position = "none")

# Summary table 
result <- heart %>%
  mutate(exang_label = ifelse(exang == 1, "Yes", "No")) %>%
  group_by(heart_disease) %>%
  summarise(
    n = n(),
    mean_age = round(mean(age), 1),
    median_age = median(age),
    mean_chol = round(mean(chol, na.rm = TRUE), 1),
    median_chol = median(chol, na.rm = TRUE),
    mean_thalach = round(mean(thalach, na.rm = TRUE), 1),
    median_thalach = median(thalach, na.rm = TRUE),
    mean_oldpeak = round(mean(oldpeak, na.rm = TRUE), 2),
    exang_percentage = round(mean(exang_label == "Yes") * 100, 1)
  )

print(result, width = Inf)

# ---- Statistical tests and effect sizes -------------------------------------
t.test(chol ~ heart_disease, data = heart)
t.test(thalach ~ heart_disease, data = heart)

cohens_d(thalach ~ heart_disease, data = heart)
cohens_d(chol ~ heart_disease, data = heart)
