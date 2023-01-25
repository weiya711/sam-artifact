# sam-artifact
Repo for SAM artifact generation

## Overview
- Getting Started (X human-minutes + X compute-minutes)
- Build Docker (X human-minutes + X compute-minutes)
- Run Experiments:
    - Run Table 1: SAM Graph Properties (X human-minutes + X compute-minutes)
    - Run Table 2: TACO Website Expressions (10 human-minutes + 8 compute-minutes)
    - Run Figure 11, 12, 13:  ()
    - Run Figure 14: Stream Overhead ()
    - Run Figure 15: ExTensor Memory Model () 
- Validate Results
- How to reuse beyond the paper ( X human-minutes + X compute-)

## Getting Started
```
docker pull weiya711/sam-artifact:latest
```

```
git submodule update --init --recursive
docker build -t sam-artifact .
```

```
docker run -d -it --rm sam-artifact bash
``` 

```
docker attach CONTAINER
```

## Run and Validate Table 1
TODO

## Run and Validate Table 2: TACO Website Expressions
- Run the following commands
  ```
  cd taco-website
  ./process.sh
  ```
  - `process.sh` will create two files `unique_formats.log` and `prim_data.log`. These file names can be changed by changing `ufname` and `fname`, respectively, located at the top of `process.sh`
  - `process.sh` calls the file `process_expr.py` with the correct input arguments to create a log of unique expressions, format algorithms and to create each row of Table 2.
- Open `prim_data.log` and validate that the results match Table 2 on page 10
- Finally return to the main directory 
    ```
    cd /sam-artifact/sam/
    ```

## Run and Validate Figure 11, 12, and 13: 
- Run the following commands
  ```
  cd /sam-artifact/sam/
  ./scripts/generate_synthetics.sh
  ```
  - `generate_synthetics.sh` will generate a variety of data structures and matrices at `/sam-artifact/sam/synthetic`. These are used for the subsequent evaluation scripts and are necessary to proceed. There are no inputs to this script and it can be run repeatedly without any negative result. This should only take a minute or two.
  ```
  ./scripts/run_synthetics.sh
  ```
  - `run_synthetics.sh` will run 

## Run and Validate Figure 14: Stream Overhead

- Randomly choose 15 Suitesparse matrices to get their stream overheads. Run the following:
  ```
  cd /sam-artifact/sam/scripts/tensor_names
  python get_benchmark_data.py` 
  ```
    - `get_benchmark_data.py` will generate `./suitesparse_benchmarks.txt`
       which has the names of 15 suitesparse matrices that are valid (do not
       OOM). The script randomly chooses 5 from each of the following: 
        1. `suitesparse_small50.txt` (the smallest 50 (based on dense dimension size) valid matrices) 
        2. `suitesparse_mid50.txt` (the median 50 (based on dense dimension size) valid matrices)  
        3. `suitesparse_large50.txt` (the largest 50 (based on dense dimension size) valid matrices) 
    - `get_benchmark_data.py` also takes in three inputs: `--seed` (defaults to 0,
       changing this will change the randomness seed), `--num` (defaulted to 5,
       this arg changes the number of names sampled from each of the above files:
       small50, mid50, and large50), and `--out_path` (defaults to
       `suitesparse_benchmarks.txt`, changing this will change the output path for the
       generated list of suitesparse matrix names). Running the script with the
       default arguments will recreate Figure 14 on page XX. These numbers can be
       changed 
- Run a script to get the stream overhead data into json files for the ramdomly selected Suitesparse matrices above. 
  ```
  cd /sam-artifact/sam/
  ./scripts/stream_overhead.sh scripts/tensor_names/suitesparse_benchmarks.txt 
  ```
  `stream_overhead.sh` does the following: 
  - Generates a file `./scripts/download_suitesparse_stream_overhead.sh` that
    ONLY downloads the suitesparse matrices listed in
    `suitesparse_benchmarks.txt`. 
  - Executes `./scripts/download_suitesparse_stream_overhead.sh`, which
    downloads the Suitesparse matrices using wget at the location
    `SUITESPARSE_PATH` (set in the docker). 
    Note: the Suitesparse dataset can be found at https://sparse.tamu.edu/
  - Then it untars all files in `SUITESPARSE_PATH` and deletes any
    unneccesary metadata files leaving just the Suitesparse `*.mtx` files. 
  - Since mtx files store the matrices in coordinate (COO) format, the script also reformats
    them to be in compressed sparse fiber/doubly-compressed sparse row
    (CSF/DCSR) format
  - Then it runs the SAM Graph simulation
    `sam-artifact/sam/sim/test/final-apps/test_mat_identity_FINAL.py` for each matrix, collecting the
    streams and counting the types of tokens in each stream, storing the data in `sam-artifact/sam/jsons/`. 
    - Each test is only run
      for one program iteration since the SAM simulator code (in
      `test_mat_identity_FINAL.py`) counts cycles (loop iterations), which is not
      system dependant. 
    - It is important to note that `test_mat_identity_FINAL.py` is run using
      pytest with a `--check-gold` flag, which compares the SAM simulation
      output to a gold numpy calculation. If the pytest passes, then the computation
      is verified and functionally correct.  
  - Finally, the script converts all jsons in  `sam-artifact/sam/jsons/` to
    csvs and aggregates the data in to one final csv
    `sam-artifact/sam/suitesparse_stream_overhead.csv`
- Run `XXX`, a plotting script to visualize `suitesparse_stream_overhead.csv` 
  ```
  python scripts/plot_stream_overhead.py suitesparse_stream_overhead.csv stream_overhead_plots.png  
  ```
    - The `stream_overhead_plots.png` filename can be changed to another name. 
    - The `plot_stream_overhead.py` creates plots via matplotlib and saves those images to the file `stream_overhead_plots.png`
- Validate that the plot in `stream_overhead_plots.png`  matches Figure 14 on page 12.  
