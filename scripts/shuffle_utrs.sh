#!/bin/bash

#$ -wd /well/lindgren/flassen/projects/utrs/shuffle_utrs
#$ -N shuffle_utrs
#$ -o logs/shuffle_utrs.log
#$ -e logs/shuffle_utrs.errors.log
#$ -q short.qe
#$ -P lindgren.prjc
#$ -pe shmem 2


set +eu
module load Anaconda3/2020.07
module load java/1.8.0_latest
source "/apps/eb/skylake/software/Anaconda3/2020.07/etc/profile.d/conda.sh"
conda activate reticulate
set -eu

readonly array_replicate="${SGE_TASK_ID}"

readonly rscript="scripts/shuffle_utrs.R"

readonly in_dir="/well/lindgren/flassen/projects/utrs/shuffle_utrs/extdata"
readonly path_sequences="${in_dir}/5utr_seqs.txt"

readonly seed=142
readonly replicates=5

readonly out_dir="/well/lindgren/flassen/projects/utrs/shuffle_utrs/derived/14mar23"
readonly out_prefix="${out_dir}/test_sim"

mkdir -p ${out_dir}

Rscript ${rscript} \
  --path_sequences "${path_sequences}" \
  --replicates "${replicates}" \
  --out_prefix "${out_prefix}"  \
  --seed "${seed}"

