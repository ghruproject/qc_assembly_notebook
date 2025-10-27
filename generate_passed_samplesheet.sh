#!/bin/bash

# Usage: ./generate_passed_samplesheet.sh /path/to/fastq_dir /path/to/final_summary.csv
# Output: samplesheet_passed.csv (in current working directory)

if [ $# -lt 2 ]; then
    echo "Usage: $0 /path/to/fastq_dir /path/to/final_summary.csv"
    exit 1
fi

FASTQ_DIR="$1"
QC_SUMMARY="$2"

if [ ! -d "$FASTQ_DIR" ]; then
    echo "❌ FASTQ directory not found: $FASTQ_DIR"
    exit 1
fi

if [ ! -f "$QC_SUMMARY" ]; then
    echo "❌ QC summary file not found: $QC_SUMMARY"
    exit 1
fi

echo "✅ Using FASTQ directory: $FASTQ_DIR"
echo "✅ Using QC summary: $QC_SUMMARY"

# Create new samplesheet for passed samples
OUTPUT_FILE="samplesheet_passed.csv"
echo "sample_id,short_reads1,short_reads2,long_reads,genome_size" > "$OUTPUT_FILE"

declare -A sample_short1
declare -A sample_short2
declare -A sample_long

# Gather all FASTQ files
for file in "$FASTQ_DIR"/*.fastq.gz; do
    [[ -e "$file" ]] || continue
    fname=$(basename "$file")

    if [[ "$fname" =~ (_R1|_1)\.fastq\.gz$ ]]; then
        sample_id=$(echo "$fname" | sed -E 's/_R1\.fastq\.gz$|_1\.fastq\.gz$//')
        sample_short1["$sample_id"]="$(realpath "$file")"
    elif [[ "$fname" =~ (_R2|_2)\.fastq\.gz$ ]]; then
        sample_id=$(echo "$fname" | sed -E 's/_R2\.fastq\.gz$|_2\.fastq\.gz$//')
        sample_short2["$sample_id"]="$(realpath "$file")"
    else
        sample_id=$(basename "$file" .fastq.gz)
        sample_long["$sample_id"]="$(realpath "$file")"
    fi
done

# Extract PASSED samples from final_summary.csv
echo "📊 Extracting samples with overall_status = PASSED..."
PASSED_SAMPLES=($(awk -F',' 'NR>1 && $2=="PASSED" || $NF=="PASSED" {print $1}' "$QC_SUMMARY" | sort -u))

# Merge and write to samplesheet
for sample_id in "${PASSED_SAMPLES[@]}"; do
    short1="${sample_short1[$sample_id]}"
    short2="${sample_short2[$sample_id]}"
    longr="${sample_long[$sample_id]}"
    echo "$sample_id,${short1:-},${short2:-},${longr:-}," >> "$OUTPUT_FILE"
done

echo "✅ Generated: $OUTPUT_FILE"
echo "📁 Location: $(realpath "$OUTPUT_FILE")"
echo "Total PASSED samples: ${#PASSED_SAMPLES[@]}"
