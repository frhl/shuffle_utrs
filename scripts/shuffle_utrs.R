#setwd('~/Projects/09_whiffin_rotation/shuffle_utrs/')
devtools::load_all()
library(data.table)
library(reticulate)
library(argparse)

binary <- "/gpfs3/well/lindgren/users/mmq446/conda/skylake/envs/reticulate/bin/python3"
Sys.setenv(RETICULATE_PYTHON = binary)
print(reticulate::py_config())

ushuffle <- reticulate::import('ushuffle')
source_python('python/shuffle_utrs.py')

main <- function(args) {

    # setup parameteres
    seed <- as.numeric(args$seed)
    replicates <- as.numeric(args$replicates)
    path_sequences <- file.path(args$path_sequence)

    # import sequences
    d <- fread(path_sequences)
    stopifnot(nrow(d)>1)
    stopifnot(replicates>0)

    # go over each gene sequence

    idx <- 1
    sim_seq <- sim_expected_codons(d$seq, k = 2, iter = replicates, codons = codons, parallel = T, seed = i)
    sim_seq <- do.call(rbind, sim_seq)

    outfile <- paste0(args$out_prefix, ".txt.gz")
    fwrite(sim_seq, outfile_est, sep = ',')

    }



  

}

# add arguments
parser <- ArgumentParser()
parser$add_argument("--path_sequences", default=NULL, help = "?")
parser$add_argument("--replicates", default=5, help = "?")
parser$add_argument("--out_prefix", default=NULL, help = "?")
parser$add_argument("--seed", default=2, help = "?")
args <- parser$parse_args()

main(args)

