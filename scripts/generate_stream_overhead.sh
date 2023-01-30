cd $SAM_HOME
cd /sam-artifact/sam/scripts/tensor_names
python get_benchmark_data.py
cd $SAM_HOME
./scripts/stream_overhead.sh scripts/tensor_names/suitesparse_benchmarks.txt
python scripts/plot_stream_overhead.py suitesparse_stream_overhead.csv stream_overhead_plots.png 