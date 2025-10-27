# 🧬 Routine WGS QC and Assembly Workflow

This repository contains a **Jupyter Notebook workflow** for performing **Quality Control (QC)** and **Genome Assembly**  
of bacterial *Whole Genome Sequencing (WGS)* data on the local sequencing server.

The notebook automates the standard **GHRU workflow**, combining:
- **[BactScout](https://github.com/ghruproject/bactscout)** for QC  
- **[GHRU-Assembly](https://github.com/ghruproject/GHRU-assembly)** for genome assembly


---

## 📋 Features

- ✅ Automatic setup of directory structure for each sequencing run  
- ✅ Quality Control using **BactScout** (with Pixi environment)  
- ✅ Manual QC interpretation step (`final_summary.csv`)  
- ✅ Automatic generation of sample sheet for passed samples  
- ✅ De novo genome assembly using **GHRU-Assembly** (Nextflow pipeline)  
- ✅ Optional cleanup of `work` and `.nextflow.log` files  
- ✅ Reproducible and auditable workflow with clear logs  

---


---

## ⚙️ Setup Instructions

### 1. Clone the Pipelines
```bash
mkdir -p /data/nihr/nextflow_pipelines/
cd /data/nihr/nextflow_pipelines/

# Clone BactScout and GHRU-Assembly
git clone https://github.com/ghruproject/bactscout.git
git clone https://github.com/ghruproject/GHRU-assembly.git
```

### 2. Create Conda Environments
```bash
# Create environment for BactScout (Pixi)
mamba create -n pixi python=3.10 -y
mamba run -n pixi pip install pixi

# Create environment for Nextflow (Assembly)
mamba create -n nextflow python=3.10 -y
mamba run -n nextflow mamba install -c bioconda nextflow -y
```

## 🧪 Running the Notebook

1. Launch **JupyterLab** or **Jupyter Notebook** on the sequencing server.  
2. Open the notebook **`Routine_WGS_QC_and_Assembly.ipynb`**.  
3. Update the **`base_dir`** variable to your current run folder (for example:  
   `/data/nihr/ghru2/2025/2025-09-22`).  
4. Run the cells sequentially from top to bottom.

---

## 🧾 Workflow Summary

### Step 1 – Define Run Folders
- Set up `input_dir`, `output_dir`, `qc_dir`, and `assembly_dir`.

### Step 2 – Run QC (BactScout)
- Runs QC inside the **Pixi** environment.  
- Generates `final_summary.csv` and `multiqc_report.html`.

### Step 3 – Manual QC Review
- Open `final_summary.csv` and add a new column **`overall_status`** (`PASSED` or `FAILED`).

### Step 4 – Generate Samplesheet
- Runs a script to create **`samplesheet_passed.csv`** containing only PASSED samples.

### Step 5 – Run Assembly (GHRU-Assembly)
- Runs the **Nextflow assembly pipeline** inside the `nextflow` environment.  
- Generates the assembly output and summary files.

### Step 6 – Optional Cleanup
- Removes `work/` and `.nextflow.log` files after successful completion.

---

## 🧠 Notes

- Always verify QC results before running the assembly pipeline.  
- You can modify the BactScout config file to include additional organisms if needed.  
- Run cleanup **only after confirming assembly completion**.  
- The notebook follows a fixed folder structure — avoid renaming or moving directories manually.

---

## 🧑‍💻 Author

**Varun Shamanna**  
Senior Bioinformatician, Central Research Laboratory, KIMS, Bengaluru  
PhD Researcher

