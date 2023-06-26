
rule all:
    input: "results/bosons.dat"

checkpoint create_unknown_amount_of_data:
    """
    Note that this rule creates an apriory unknown amount of files.
    It creates files until the random number is greater than params.threshold.
    The template that is specified in params is used both to create the files
    and to read them in the subsequent jobs.
    """
    output:
        "results/random_data.done"
    params:
        template="results/rnd_{}.dat",
        threshold=0.9
    run:
        import random
        import os
        val = params.threshold/2.0
        i = 0;
        while val < params.threshold:
            fname = params.template.format(i)
            with open(fname, 'w') as f:
                for _ in range(10):
                    print(random.random(), file=f)
            val = random.random()
            i += 1
        os.system('touch {}'.format(output[0]))


def get_all_dat_files(**wildcards):
    import glob
    # NOTE: 'output' is acquired by using get() and by using the checkpoints namespace
    #       'params' is acquired using the standard 'rules' namespace
    with open(checkpoints.create_unknown_amount_of_data.get(**wildcards).output[0], 'r') as f:
        template = rules.create_unknown_amount_of_data.params.template.format('*')
        files = glob.glob(template)
        return files
    

rule create_random_data:
    output: 
        expand("results/rnd_{sample}.dat", sample=range(5))
    script:
        "scripts/create_random_data.py"


checkpoint calculate_bins:
    input: lambda wildcards: get_all_dat_files(**wildcards)
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

