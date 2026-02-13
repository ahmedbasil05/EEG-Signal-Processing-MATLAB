# EEG Signal Processing & Band Power Analysis (MATLAB)

## 📌 Course
CP-303 Digital Signal Processing

## 📖 Project Overview
This project implements EEG signal processing and analysis using MATLAB. 
Raw EEG data is loaded from a CSV file and processed using time-domain and frequency-domain techniques.

The system performs:
- Data loading and validation
- Epoch segmentation (5-second segments)
- Time-domain signal visualization
- Moving Average filtering
- Butterworth IIR Low-pass filtering
- EEG frequency band power analysis

---

## 🧠 EEG Channels Used
- RAW_TP9
- RAW_AF7
- RAW_AF8
- RAW_TP10

Sampling Frequency: **256 Hz**  
Epoch Length: **5 seconds**

---

## 🔍 Processing Steps

### 1️⃣ Time-Domain Analysis
- Plots raw EEG signals for each channel.
- Observes signal amplitude and noise characteristics.

### 2️⃣ Moving Average Filter
- Window size = 5 samples
- Reduces random noise.
- Smooths signal.

### 3️⃣ IIR Butterworth Low-Pass Filter
- Order = 4
- Cutoff Frequency = 30 Hz
- Removes high-frequency noise.

### 4️⃣ Frequency Band Power Analysis
Band powers are calculated for:

| Band  | Frequency Range (Hz) |
|-------|----------------------|
| Delta | 0.5 – 4              |
| Theta | 4 – 8                |
| Alpha | 8 – 13               |
| Beta  | 13 – 30              |
| Gamma | 30 – 50              |

Results are displayed in:
- Table format
- Bar graph visualization

---

## 📊 Output
- Raw EEG plots
- Filter comparison plots
- EEG band power table
- Bar graphs for each channel

---

## 🛠 Requirements
- MATLAB
- Signal Processing Toolbox

---

## 📁 Input File
CSV file must contain columns:
- RAW_TP9
- RAW_AF7
- RAW_AF8
- RAW_TP10

---

## 🎯 Learning Outcomes
- Practical EEG signal processing
- Digital filtering techniques
- Time & frequency domain analysis
- Power spectral analysis
- MATLAB signal visualization

---

## 👨‍💻 Author
Ahmed Basil  
Machine Learning & AI Enthusiast  
