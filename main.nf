//#! usr/bin/env nextflow
//process zero loadfiles

include { fastqc } from './proc/fastqc.nf'
include { fastp } from './proc/fastp.nf'
include { fastqc2 } from './proc/fastqc2.nf'
//include { makeContigs } from './proc/makeContigs.nf'

//Channel.fromPath('./Data/LGE*')
  //     .view()
params.reads = './Data/*{R1,R2}.fastq'
params.outdir = "output"
params.thread = 4
params.quality = 30

ifile = Channel.fromFilePairs(params.reads)
       .view()
       .set {reads_ch}   
              
//fastqc (QC)



log.info """\
    Oklander - N F   P I P E L I N E
    ===================================
    File parameters:
    --reads        : ${params.reads}
    --outdir       : ${params.outdir}
    
    Fastp options:
    --thread     : ${params.thread}
    --quality    : ${params.quality}

    """
    .stripIndent()



//fastp

//Make.contigs (ensamble de contigs) del mismo individuo.

//Summary.seqs (información estadística del proceso)

//Screen.seqs (filtrado de secuencias indeseadas, por longitud 200-350, bases ambiguas, max homopolymer=8)

//Barcode Splitter (Separación de las colecciones para separar los 3 genes)

//Unique.seqs (names: grupos de nombres según secuencias únicas)

//Count.seqs (conteo de seqs, mothur instalado localmente)
//      Conteo final de genes en grupos (GH2,DQB,DRB)
//      mothur > count.seqs(name=file.mothur.names, group=file.mothur.groups, compress=f)


workflow{
       fastqc(reads_ch)
       fastp_ch = fastp(reads_ch)
       fastqc2(fastp.out.fastp_1
                .concat(fastp.out.fastp_2))
}








