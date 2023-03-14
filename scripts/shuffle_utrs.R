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
    seed <- as.integer(args$seed)
    replicates <- as.integer(args$replicates)
    path_sequences <- file.path(args$path_sequence)

    # import sequences
    d <- fread(path_sequences)
    stopifnot(nrow(d)>1)
    stopifnot(replicates>0)

    # expect column names
    stopifnot("seq" %in% colnames(d))
    stopifnot("ensgid" %in% colnames(d))

    # go over each gene sequence
    for (idx in 1:5){ #nrow(d)){
        # get gene & sequence 
        gene <- d$ensgid[idx]
        sequence <- d$seq[idx]
        # simulate context given sequence 
        sequence <- as.vector(sequence)
        sim_seq <- shuffle_utrs(seq=sequence, k=2, max_iter=replicates, seed=seed)
        # combien and write to file
        sim_out <- data.table(ensgid=gene, seqsim=sim_seq) 
        outfile <- paste0(args$out_prefix,".",gene,".txt.gz")
        fwrite(sim_out, outfile, sep = ',')
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

