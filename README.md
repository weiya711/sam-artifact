# sam-artifact
Repo for SAM artifact generation

## Overview
- Getting Started (5 human-minutes + 10 compute-minutes)
- Run Experiments:
    - Run Top-Level Script (5 human-minutes + 1 compute-hour)
    - Run Figure 15: ExTensor Memory Model (5 human-minutes + up to 50 compute-hours) 
- Validate All Results
- How to Reuse Artifact Beyond the Paper ( X human-minutes + X compute-minutes )
- [Optional] Detailed Breakdown of Top-Level Script 
    - Run and Validate Table 1: SAM Graph Properties (5 human-minutes + 1 compute-minutes)
    - Run and Validate Table 2: TACO Website Expressions (10 human-minutes + 10 compute-minutes)
    - Run Figure 11, 12, 13:  (2 human-minutes + 10 compute-minutes)
    - Run Figure 14: Stream Overhead (5 human-minutes + 15 compute-minutes)

## Getting Started
This guide assumes the user has a working installation of Docker and some version of python 3 installed.
- Run the following commands to build the docker image named `sam-artifact` locally from the files in this GitHub repo.
  ```
  git submodule update --init --recursive
  docker build -t sam-artifact .
  ```
- Once the image is built, run a docker container with a bash terminal
  ```
  docker run -d -it --rm sam-artifact bash
  ``` 
  - The above command should print out a `CONTAINER_ID`
- Attach to the docker container using the command below and the `CONTAINER_ID` from the previous step 
  ```
  docker attach CONTAINER_ID
  ```
- *IMPORTANT:* Do not type `exit` in the docker terminal as this will kill the container. The proper way to exit the docker is the sequence `CTRL-p, CTRL-q`.

## Run Top-Level Script (5 human-minutes + 1 compute-hour)
TODO

 
## Run Figure 15: Memory Model  (10 human-minutes + between 30 compute-minutes to 92 compute-hours)
- Run the following command which creates a `sam-artifact/sam/extensor_mtx` directory and generates pre-tiled synthetic matrices (about 8 compute-minutes).
  ```
  cd /sam-artifact/sam/
  ./scripts/generate_sparsity_sweep_mem_model.sh
  ```
  - The synthetic matrices are uniformly randomly sparse and vary across the
    number of nonzeros (nnz), `NNZ`, and dense dimension size, `DIMSIZE`. We assume the matrices
    are square as in the Extensor evaluation. The files follow the naming scheme `extensor_mtx/extensor_NNZ_DIMSIZE.mtx` 

Next, choose one of the three options to run:
1. Run `./scripts/few_points_memory_model_runner.sh` to run a restricted set of experiments (8) from Figure 15 on page 12 of our paper that will take 8 compute-hours to run. 
   ```
   ./scripts/few_points_memory_model_runner.sh memory_config_extensor_17M_llb.yaml 0
   ```
   - The second argument of this script can either take a `0` or `1`, where `0`
     omits checking against the gold numpy computation and `1` checks against
     gold.  
   - *NOTE:* Running with gold (1 as the second argument) will take 20 compute-hours.

2. Run `./scripts/full_memory_model_runner.sh` to run the full set of points from Figure 15 on page 12 that will take 64 compute-hours. The full command is:
   ```
   ./scripts/full_memory_model_runner.sh memory_config_extensor_17M_llb.yaml 0
   ```
   - The second argument of this script can either take a `0` or `1`, where `0`
     omits checking against the gold numpy computation and `1` checks against
     gold.  
   - *NOTE:* Running with gold (1 as the second argument) will take XX compute-hours.
 
3. Run `./scripts/single_point_memory_model_runner.sh` to run a single point from Figure 15 on page 12 that will take variable time depending on which point is chosen. The full command is:
   ```
   ./scripts/single_point_memory_model_runner.sh extensor_NNZ_DIMSIZE.mtx
   ```
   - where `NNZ` is the number of nonzeros for each matrix (and point plotted in Figure 15). `NNZ` can be values [5000, 10000, 25000, or 50000] 
   - where `DIMSIZE` is the dense dimension size for each matrix (and point plotted in Figure 15). `DIMSIZE` can be values (TODO, list all the dense dimensions sizes). 
   - This script runs with gold checks on by default.  
   - *NOTE:* This script may take anywhere from 20 minutes (for NNZ=5000, DIMSIZE=1024) to 17 hours (NNZ=50000, DIMSIZE=15720) to compute

- The following is true for the above 3 scripts:
  - The scripts generate a directory called `tiles` with the pre-tiled matrix for the current test
  - The scripts create a directory called `memory_model_out` with a json and csv file for each experiment (`NNZ_DIMSIZE` matrix)
  - All csvs in `memory_model_out` are then aggregated into a single final csv called `matmul_ikj_tile_pipeline_final.csv in the same directory
  - The data in `memory_model_out` will not be deleted unless you run the following clean command. This means that running `few_points_memory_model_runner.sh` can be combined with `single_point_memory_model_runner.sh` to aggregate more experiments into the final `matmul_ikj_tile_pipeline_final.csv`. 
    - Running the below command removes all collateral directories (`tiles/`, `memory_model_out/`, and `extensor_mtx/`) created from this section, which means running the below command will stop accumulating experiments into the final `matmul_ikj_tile_pipeline_final.csv`.
      ```
      ./scripts/clean_memory_model.sh
      ```

- Once all desired points are run and stored in to `matmul_ikj_tile_pipeline_final.csv`, run a plotting script to generate (the full/partial) Figure 15 on page 12 as a PNG. 
  ```
  python ./scripts/plot_memory_model.py memory_model_out/matmul_ikj_tile_pipeline_final.csv memory_model_plot.png
  ```
    - The `memory_model_plot.png` filename argument (#2) can be changed to another name.
    - The script will create a plot by default at the location `/sam-artifact/sam/fig15.pdf` anyways so that the validation plot script in the *Validate Figure Results* section does not error.  
    - The `plot_memory_model.py` creates plots via matplotlib and saves those images to the file `memory_model_plot.png`

## Validate Figure Results
- Exit the docker (`CTRL-p, CTRL-q`)
- To extract all of the images/figures from the docker to your local machine for viewing, run the following command. This needs to be done from outside the docker, starting at the top directory of this repository (`sam-artifact`).
  ```
  python sam/scripts/artifact_docker_copy.py --output_dir <OUTPUT_DIRECTORY> --docker_id <DOCKER_ID>
  ```
  - `artifact_docker_copy.py` runs a series of `docker cp` commands to pull the figures from their default locations, renaming them to be clear which figure they correspond to in the main manuscript.
  - `--output_dir` is used to specify an output directory on the local machine for the figures to be stored in. The script will create the directory if it does not exist. All the files referenced in the next few steps will be found at this directory.
  - `--docker_id` is used to identify the docker container ID. This should have printed when the docker was created and is the same ID used to attach to the container.
    You may also retrieve the `DOCKER_ID` again by running `docker ps` in your terminal.

- Validate that the log in `tab1.log` matches Table 1 on page 10.
- Validate that the log in `tab2.log` matches Table 2 on page 10.
- Validate that the plot in `fig11.pdf` matches Figure 11 on page 10.
- Validate that the plot in `fig12.pdf` matches Figure 12 on page 10.
- Validate that the plot in `fig13a.pdf` matches Figure 13a on page 12.
- Validate that the plot in `fig13b.pdf` matches Figure 13b on page 12.
- Validate that the plot in `fig13c.pdf` matches Figure 13c on page 12.
- Validate that the plot in `fig14.pdf` matches Figure 14 on page 12.
- Validate that the plot in `fig15.pdf` matches Figure 15 on page 12.

## How to Reuse Artifact Beyond the Paper 

## [Optional] 

### Run and Validate Table 1 (5 human-minutes + 1 compute-minutes)
- Run the following command
  ```
  cd sam/	# from /sam-artifact/sam/
  python scripts/collect_node_counts.py
  ```
  - This script will go through each of the SAM graphs for the expressions listed in Table 1 on page 10 and counts the number of each relevant primitive in the graph. 
  - The script takes an argument `--sam_graphs` that can be pointed to the directory containing the sam graphs. This is defaulted to a safe path for the docker environment and is unnecessary for reviewers.
  - The script also takes an argument `--output_log` which provides a file location to write the log to. The log is identical to the standard output of the script, but we provide this utility in any case. This argument is also defaulted to `tab1.log` with the docker environment in mind, so reviewers need not use it.
- View the standard output from the script and validate that the results match the right half of Table 1 on page 10. 
  - *NOTE:* The left half of Table 1 was analytically done (by hand) and
  does not have associated source code. 
  - *NOTE:* SpM\*SpM in the artifact is only shown for the ijk dataflow order, so the CrdDrop value is 2 (which is within the range 0-2 in the paper)

### Run and Validate Table 2: TACO Website Expressions (10 human-minutes + 8 compute-minutes)
- Run the following commands
  ```
  cd /sam-artifact/taco-website
  ./process.sh
  ```
  - `process.sh` will create two files `unique_formats.log` and `tab2.log`. These file names can be changed by changing `ufname` and `fname`, respectively, located at the top of `process.sh`
  - `process.sh` calls the file `process_expr.py` with the correct input
    arguments to create a log of unique expressions, format algorithms and to
create each row of Table 2 on page 10.
- Open `tab2.log` and validate that the results match Table 2 on page 10

### Run Figure 11, 12, and 13: Optimizations (2 human-minutes + 10 compute-minutes)
- Run the following commands
  ```
  cd /sam-artifact/sam/
  ./scripts/generate_synthetics.sh
  ```
  1. `generate_synthetics.sh` will generate a variety of data structures and matrices at `/sam-artifact/sam/synthetic`. These are used for the subsequent evaluation scripts and are necessary to proceed. There are no inputs to this script and it can be run repeatedly without any negative result. This should only take a minute or two.
  ```
  ./scripts/run_synthetics.sh
  ```
  2. `run_synthetics.sh` will run the pytest benchmarks that generate the data for the simulator-based cycle counts in Figures 11, 12, and 13. For each set of data, the script runs the pytest benchmark and then converts the output results into a CSV file. The pytest benchmarks include comparisons to a gold output to verify that they are correct. Three directories (`./results`, `./results-fusion`, `./results-reorder`) are created and contain the original json files from the benchmark and their conversions as CSV. This script will also create `./SYNTH_OUT_<ACCEL/REORDER/FUSION>.csv` at the directory where the script was run from (in this case `/sam-artifact/sam/`), containing the combined results of each benchmark for each study.
  ```
  python sam/onyx/synthetic/plot_synthetics.py 
  ```
  3. `plot_synthetics.py` will gather the data frames from each CSV file from the previous step and use matplotlib to plot each figure from the paper accordingly. The script has an argument `--output_dir` that can be used to identify the location to output the pdfs/svgs into, but for the purposes of artifact evaluation and later instructions in this README, this argument is unnecessary.
- This is all that needs to be done for now, as a script is provided with the artifact to pull each figure out from the docker so that reviewers can view them on their local machine (in Section Validate Figure Results).

### Run Figure 14: Stream Overhead (5 human-minutes + 15 compute-minutes)

- Randomly choose 15 Suitesparse matrices to get their stream overheads. Run the following:
  ```
  cd /sam-artifact/sam/scripts/tensor_names
  python get_benchmark_data.py
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
- Run a script to get the stream overhead data into json files for the randomly selected Suitesparse matrices above. 
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
    `/sam-artifact/sam/sim/test/final-apps/test_mat_identity_FINAL.py` for each matrix, collecting the
    streams and counting the types of tokens in each stream, storing the data in `/sam-artifact/sam/jsons/`. 
    - Each test is only run
      for one program iteration since the SAM simulator code (in
      `test_mat_identity_FINAL.py`) counts cycles (loop iterations), which is not
      system dependant. 
    - It is important to note that `test_mat_identity_FINAL.py` is run using
      pytest with a `--check-gold` flag, which compares the SAM simulation
      output to a gold numpy calculation. If the pytest passes, then the computation
      is verified and functionally correct.  
  - Finally, the script converts all jsons in  `/sam-artifact/sam/jsons/` to
    csvs and aggregates the data in to one final csv
    `sam-artifact/sam/suitesparse_stream_overhead.csv`
- Run `plot_stream_overhead.py`, a plotting script to visualize `suitesparse_stream_overhead.csv` 
  ```
  python scripts/plot_stream_overhead.py suitesparse_stream_overhead.csv stream_overhead_plots.png  
  ```
    - The `stream_overhead_plots.png` filename argument (#2) can be changed to another name.
    - The script will create a plot by default at the location `/sam-artifact/sam/fig14.pdf` anyways so that the validation plot script in the *Validate Figure Results* section does not error.  
    - The `plot_stream_overhead.py` creates plots via matplotlib and saves those images to the file `stream_overhead_plots.png`
