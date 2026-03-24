#!/usr/bin/bash
#SBATCH --job-name=spades-test                    # Job name
#SBATCH --partition=workflow,cpu            # Partition (queue) name
#SBATCH -c 2                                # Number of CPUs
#SBATCH --nodes=1                           # Number of nodes
#SBATCH --mem=10gb                          # Job memory request
#SBATCH --time=1-00:00:00                   # Time limit days-hrs:min:sec
##SBATCH -q long
#SBATCH --output=logs/%x_%j.log

module load nextflow/24.10.3 apptainer/latest

export NXF_APPTAINER_CACHEDIR=$APPTAINER_CACHEDIR
export NXF_OPTS="-Xms1G -Xmx8G"

nextflow run main.nf \
    --n_jobs 10 \
    --ref test/ecoli_k12.fasta \
    --outdir test/result \
    -profile unity
