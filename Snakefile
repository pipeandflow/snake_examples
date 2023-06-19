
rule all:
    input: "results/bosons.dat"


rule create_random_data:
    output: 
        expand("results/rnd_{sample}.dat", sample=range(5))
    script:
        "scripts/create_random_data.py"


checkpoint calculate_bins:
    input: rules.create_random_data.output
    output: "results/bins.dat"
    script: "scripts/calculate_bins.py"


def get_num_bins(**wildcards):
    with checkpoints.calculate_bins.get(**wildcards).output[0].open() as f:
        num_bins = int(f.read())
        return num_bins

rule create_boson:
    output: "results/boson_{i}.dat"
    shell:
        """
        echo {wildcards.i} > {output}
        """

rule sum_bosons:
    input: lambda wildcards: expand(rules.create_boson.output[0], i=range(get_num_bins(**wildcards)))
    output: "results/bosons.dat"
    shell:
        """
        cat {input} > {output}
        """

