# HLA Genotyping Pipeline with Nextflow

## Overview
This Nextflow pipeline performs HLA genotyping analysis for MHC class II genes (DQA, DQB, DRB) from paired-end sequencing data. The pipeline integrates quality control, read processing, contig assembly, sequence screening, and gene-specific analysis in an automated workflow.

![Pipeline Diagram](https://via.placeholder.com/800x300?text=Pipeline+Diagram)

## Pipeline Steps

### 1. Quality Control (Before Processing)
- **Tool**: FastQC
- **Output Directory**: `outdir_0_fastqc`
- **Purpose**: Initial quality assessment of raw sequencing reads

### 2. Read Trimming and Filtering
- **Tool**: fastp
- **Parameters**:
  - `--quality = 30` (Phred quality threshold)
  - `--unqualified_percent_limit = 3` (Max % of unqualified bases)
- **Purpose**: Adapter trimming and quality-based filtering

### 3. Quality Control (After Processing)
- **Tool**: FastQC
- **Output Directory**: `outdir_1_fastqc`
- **Purpose**: Verify quality improvements after processing

### 4. Contig Assembly
- **Tool**: Mothur (v1.47.0)
- **Command**: `make.contigs`
- **Purpose**: Assemble paired-end reads into contigs

### 5. Sequence Screening
- **Tool**: Mothur
- **Filters**:
  - Sequence length: 200-350 bp
  - Ambiguous bases: removed
  - Max homopolymer length: 8
- **Purpose**: Remove low-quality and undesirable sequences

### 6. Barcode Splitting
- **Tool**: `fastx_barcode_splitter.pl`
- **Genes Targeted**: DQA, DQB, DRB
- **Purpose**: Separate sequences by HLA gene type

### 7. Unique Sequence Identification
- **Tool**: Mothur (`unique.seqs`)
- **Output**: Sequence groups based on unique sequences
- **Purpose**: Identify unique sequences for downstream analysis

### 8. Sequence Counting
- **Tool**: Mothur (`count.seqs`)
- **Command**: 
  ```bash
  count.seqs(name=file.mothur.names, group=file.mothur.groups, compress=f)
  ```
- **Purpose**: Final gene count statistics for DQA, DQB, DRB genes

## Installation

### Prerequisites
- Java 8 or later
- Nextflow
- Docker

### Setup
1. Install Nextflow:
```bash
curl -s https://get.nextflow.io | bash
```

2. Clone this repository:
```bash
git clone https://github.com/yourusername/hla-genotyping-pipeline.git
cd hla-genotyping-pipeline
```

3. Pull the Docker image:
```bash
docker pull quay.io/mothur/mothur:v1.47.0
```

## Configuration

### Key Parameters
Set these in `nextflow.config` or as command-line arguments:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `reads` | `'./Data/*/*{R1,R2}.fastq'` | Input read path pattern |
| `outdir` | `'output'` | Output directory |
| `thread` | 4 | Number of threads |
| `quality` | 30 | Quality threshold for base qualification |
| `barcodeFile` | `'./Data/barcode/barcode_file.txt'` | Barcode mapping file |

### Barcode File Format
The barcode file should be a tab-delimited text file with two columns:
```
barcode_sequence    gene_name
```

Example:
```
ATGCGTA    DQA
TGCATAC    DQB
CGATGCG    DRB
```

## Usage

### Basic Run
```bash
nextflow run main.nf
```

### Custom Parameters
```bash
nextflow run main.nf \
  --reads './my_data/*_{1,2}.fastq' \
  --outdir 'my_results' \
  --thread 8 \
  --quality 25
```

### Resume Execution
```bash
nextflow run main.nf -resume
```

## Output Structure
```
output/
├── 0_fastqc/               # Initial quality reports
├── 1_fastqc/               # Post-processing quality reports
├── contigs/                # Assembled contigs
├── screened_seqs/          # Filtered sequences
├── gene_split/
│   ├── DQA/                # DQA gene sequences
│   ├── DQB/                # DQB gene sequences
│   └── DRB/                # DRB gene sequences
├── unique_seqs/            # Unique sequence groups
└── gene_counts/            # Final gene count statistics
```

## Dependencies
- [Nextflow](https://www.nextflow.io/) (v22.04.0 or later)
- [Mothur](https://mothur.org/) (v1.47.0)
- [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
- [fastp](https://github.com/OpenGene/fastp)
- [Docker](https://www.docker.com/) (for containerized execution)

## References
1. Schloss, P.D., et al. (2009). Introducing mothur: Open-source, platform-independent, community-supported software for describing and comparing microbial communities. *Appl Environ Microbiol* 75(23):7537-41.
2. Chen, S., et al. (2018). fastp: an ultra-fast all-in-one FASTQ preprocessor. *Bioinformatics* 34(17):i884-i890.

## Author
Sergio Litwiniuk
CONICET - GIGA lab
sergiolitwiniuk@gmail.com

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
