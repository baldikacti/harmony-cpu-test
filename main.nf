// main.nf
nextflow.enable.dsl=2


process SIMULATE_READS {
    cpus 2
    memory '4 GB'
    time '1.h'
    container 'baldikacti/spades:latest'

    input:  
    val seed
    path ref

    output: tuple val(seed), path("reads_${seed}_{1,2}.fq.gz")

    script:
    """
    wgsim -N 200000 -1 150 -2 150 -S ${seed} \\
            ${ref} \\
            reads_${seed}_1.fq reads_${seed}_2.fq
    gzip reads_${seed}_1.fq reads_${seed}_2.fq
    """
}

process ASSEMBLE {
    cpus 4
    memory '8 GB'
    time '1.h'
    container 'baldikacti/spades:latest'

    input:  tuple val(seed), path(reads)
    output: tuple val(seed), path("assembly_${seed}/contigs.fasta")

    script:
    """
    spades.py -1 ${reads[0]} -2 ${reads[1]} \\
                -o assembly_${seed} \\
                --threads ${task.cpus}
    """
}

process QC {
    cpus 1
    memory '2 GB'
    time '1.h'
    container 'baldikacti/quast:5.3.0'
    publishDir params.outdir, mode: 'move'

    input:  tuple val(seed), path(contigs)
    output: path("quast_${seed}/report.tsv")

    script:
    """
    quast.py ${contigs} -o quast_${seed} --threads ${task.cpus}
    """
}

workflow {
    seeds = channel.of(1..params.n_jobs)
    ch_ref = file(params.ref, checkIfExists: true)
    reads = SIMULATE_READS(seeds, ch_ref)
    assemblies = ASSEMBLE(reads)
    QC(assemblies)
}