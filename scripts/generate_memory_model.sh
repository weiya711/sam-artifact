while getopts m flag
do
    case "${flag}" in
        m) memory_model=${OPTARG};;
    esac
done

if [ -z "$memory_model" ];
then
    echo "Defaulting memory model to one..."
    memory_model="one"
fi

if [[ "$memory_model" != "one" && "$memory_model" != "few" && "$memory_model" != "all" ]];
then
    echo "Memory Model (-m) must be one, few, or all"
    return
fi

cd $SAM_HOME
./scripts/generate_sparsity_sweep_mem_model.sh

if [[ "$memory_model" == "one" ]];
then
    echo "Running one..."
    ./scripts/single_point_memory_model_runner.sh extensor_5000_1024.mtx
elif [[ "$memory_model" == "few" ]];
then
    echo "Running few..."
    ./scripts/few_points_memory_model_runner.sh memory_config_extensor_17M_llb.yaml 0
elif [[ "$memory_model" == "all" ]];
then
    echo "Running all..."
    ./scripts/full_memory_model_runner.sh memory_config_extensor_17M_llb.yaml 0
fi

python ./scripts/plot_memory_model.py memory_model_out/matmul_ikj_tile_pipeline_final.csv memory_model_plot.png
