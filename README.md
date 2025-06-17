# Signal-Enhancement

This repository supports the paper:  
**"[Enhancing Uterine Contraction Detection Through Novel EHG Signal Processing: A Pilot Study Leveraging the Relationship Between Slow and Fast Wave Components to Improve Signal Quality and Noise Resilience](https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2025.1568919/full)"**, published in *Frontiers in Physiology*.

## 📁 Sample Data

The file `sample_data_subject_5.mat` contains sample data used in the study. It includes the following variables:

- `activeElectrodes`: Indices of the electrodes used in the study  
- `fastWave`: Raw EHG signals filtered with a bandpass filter (0.34–1 Hz)  
- `slowWave`: Raw EHG signals filtered with a bandpass filter (0.01–0.1 Hz)  
- `slowEnv`: RMS envelope of the slow wave  
- `modulation`: Enhanced signal computed by element-wise multiplication of the fast wave and slow wave envelope  
- `toco`: Binary TOCO mask indicating contraction periods  
- `toco_location`: Coordinates of the TOCO monitor  

## 🧠 Code Overview

The provided MATLAB code demonstrates the complete processing pipeline in the file Signal_enhancement.m

1. **Load the data**
2. **Perform bad channel removal**
3. **Compute ROC curves** for each channel
4. **Visualize AUC distribution** across the body surface
5. **Display high-consistency channel distribution**
6. **Estimate signaling distance**


## 📌 Citation

If you find this repository helpful, please cite the associated paper:  
[https://www.frontiersin.org/articles/10.3389/fphys.2025.1568919/full](https://www.frontiersin.org/articles/10.3389/fphys.2025.1568919/full)
```
