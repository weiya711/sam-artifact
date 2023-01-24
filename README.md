# sam-artifact
Repo for SAM artifact generation

## Overview
- Getting Started (X human-minutes + X compute-minutes)
- Build Docker (X human-minutes + X compute-minutes)
- Run and Validate Experiments:
    - Run and Validate Table 1: SAM Graph Properties (X human-minutes + X compute-minutes)
    - Run and Validate Table 2: TACO Website Expressions (10 human-minutes + 8 compute-minutes)
    - Run and Validate Figure 11, 12, 13:  ()
    - Run and Validate Figure 14: Stream Overhead ()
    - Run and Validate Figure 15: ExTensor Memory Model () 
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
cd ..
```

## Run and Validate Figure 14: Stream Overhead

- Randomly choose 15 Suitesparse matrices to get their stream overheads. Run the following:
```
cd sam/scripts/tensor_names
python get_benchmark_data.py` 
```
`get_benchmark_data.py` will generate `./suitesparse_benchmarks.txt` which has the names of 15 suitesparse
matrices that are valid (do not OOM). The script randomly chooses 5 from each of the following: 
    1. `suitesparse_small50.txt` (the smallest 50 (based on dense dimension size) valid matrices) 
    2. `suitesparse_mid50.txt` (the median 50 (based on dense dimension size) valid matrices)  
    3. `suitesparse_large50.txt` (the largest 50 (based on dense dimension size) valid matrices) 
        - `get_benchmar_data.py` also takes in three inputs: `--seed` (defaults to 0,
           changing this will change the randomness seed), `--num` (defaulted to 5,
           this arg changes the number of names sampled from each of the above files:
           small50, mid50, and large50), and `--out_path` (defaults to
           `suitesparse_benchmarks.txt`, changing this will change the output path for the
           generated list of suitesparse matrix names). Running the script with the
           default arguments will recreate Figure 14 on page XX. These numbers can be
           changed 

