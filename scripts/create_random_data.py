import random
for fname in snakemake.output:
    with open(fname, 'w') as f:
        for i in range(10):
            print(random.random(), file=f)
