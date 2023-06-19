An example of checkpoints mechanism usage in Snakemake.  

The workflow creates a fixed number of files that contain random numbers.
Then, it calculates its mean and defines a `num_bins=int(mean * 100)`.
Then, it creates `num_bins` files each containing its index.
Another rule concatenates all thos files to the top most result.
