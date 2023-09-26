#!/bin/bash

# Define input directory and output directory
input_dir="$HOME/2023-09-21"
output_dir="$HOME/2023-09-21"

# Make sure the output directory exists, if not, create it
#mkdir -p "$output_dir"

# Iterate through paired-end FASTQ.gz files in the input directory
for file in "$input_dir"/*_R1.fastq.gz; do
    if [ -e "$file" ]; then
        # Get the base filename (without extension) for naming output files
        base_name=$(basename "$file" _R1.fastq.gz)
        
        # Define output paths for fastp, fastqc, and Unicycler
        fastp_output="$output_dir/${base_name}_fastp"
        #fastqc_output="$output_dir/${base_name}_fastqc"
        unicycler_output="$output_dir/${base_name}_unicycler"
        
        # Run fastp to perform quality trimming and filtering
        fastp -i "$file" -I "${file/_R1/_R2}" -o "$fastp_output.R1.fastq.gz" -O "$fastp_output.R2.fastq.gz" --detect_adapter_for_pe -h "$fastp_output.html" -j "$fastp_output.json"
        
        # Run fastqc to generate quality reports
        #fastqc -o "$fastqc_output" "$fastp_output.R1.fastq.gz" "$fastp_output.R2.fastq.gz"
        
        # Run Unicycler for assembly (modify this command as needed)
        unicycler -t 40 -1 "$fastp_output.R1.fastq.gz" -2 "$fastp_output.R2.fastq.gz" -o "$unicycler_output"
        
        # You can add more post-processing steps here if needed
    fi
done

