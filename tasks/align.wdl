version 1.0

task Align {

    input {

        File fastq_file
        File ref_fasta
        String sample_id
        
        Int threads
        String ram
    }

    Int disk_size = ceil(size(fastq_file, "GB")) * 2 + 10

	command {
        minimap2 -ax map-ont -t ${threads} ${ref_fasta} ${fastq_file} | samtools sort -o ${sample_id}.bam
        samtools index ${sample_id}.bam
    }

    output {
        File bam = "${sample_id}.bam"
        File bam_index = "${sample_id}.bam.bai"
    }

    runtime {
        cpu: threads
        memory: ram
        docker: "adamslab/minimap2"
        disks: "local-disk " + disk_size + " HDD"
    }
	
}

