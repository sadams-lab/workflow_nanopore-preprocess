version 1.0

import "tasks/basecall.wdl" as basecall
import "tasks/align.wdl" as align

workflow NanoporePreprocess {

    input {
        String flowcell
        String kit
        String sample_id
        Array[File] fast5_files
        File ref_fasta
        File ref_fasta_index

        String guppy_docker = "adamslab/guppy"
        Int guppy_threads = 2
        Int guppy_gpus = 1
        String guppy_ram = "8 GB"

        String align_docker = "adamslab/minimap2"
        Int align_threads = 16
        String align_ram = "32 GB"
    }

    call basecall.Basecall as bc {
        input :
            flowcell = flowcell,
            kit = kit, 
            fast5_files = fast5_files,
            docker_container = guppy_docker,
            threads = guppy_threads, 
            gpus = guppy_gpus,
            ram = guppy_ram,
            sample_id = sample_id
    }

    call align.Align as aln {
        input :
            fastq_file = bc.fastq_file,
            ref_fasta = ref_fasta,
            sample_id = sample_id,
            docker_container = align_docker,
            ram = align_ram,
            threads = align_threads
    }

    output {
        File fastq_out = bc.fastq_file
        File bam = aln.bam
        File bam_index = aln.bam_index
    }
}
