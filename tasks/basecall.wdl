version 1.0

task Basecall {
    
    input {
        String flowcell
        String kit
        String sample_id
        Array[File] fast5_files

        String docker_container
        Int threads
        Int gpus
        String ram
    }

    Int disk_size = ceil(size(fast5_files, "GB")) * 2 + 25

    command {
        mkdir fastq
        mkdir fast5

        for f in ${sep = ' ' fast5_files} ; 
        do
            mv $f fast5/
        done

        # Basecall
        guppy_basecaller --input_path fast5 \
            --save_path fastq \
            --flowcell ${flowcell} \
            --kit ${kit} \
            --device auto \
            --compress_fastq
        
        cat fastq/*.gz > ${sample_id}.fq.gz
            
        cat fastq/guppy_basecaller_log* > guppy_basecaller.log
    }

    output {
        File sequence_summary = "fastq/sequencing_summary.txt"
        File guppy_basecaller_log = "guppy_basecaller.log"
        File fastq_file = "${sample_id}.fq.gz"
    }

    runtime {
        cpu: threads
        bootDiskSizeGb: 25
        memory: ram
        docker: docker_container
        disks: "local-disk " + disk_size + " HDD"
        gpuType: "nvidia-tesla-p100"
        gpuCount: gpus
        zones: ["us-central1-c", "us-central1-f", "us-east1-b", "us-east1-c"]
    }
    
}

