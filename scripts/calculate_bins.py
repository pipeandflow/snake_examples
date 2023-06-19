total = 0
num = 0
for fname in snakemake.input:
    with open(fname, 'r') as f:
        lines = f.readlines()
    total += sum([float(_) for _ in lines])
    num += len(lines)
mean = total/num
num_bins = int(100*mean)
with open(snakemake.output[0], 'w') as f:
    print(num_bins, file=f)
