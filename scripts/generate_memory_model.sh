while getopts m flag
do
    case "${flag}" in
        m) memory_model=${OPTARG};;
    esac
done

if ! [ -z "$memory_model" ];
then
    memory_model = "one"
fi

if [[ "$memory_model" != "one"]] && [[ "$memory_model" != "few"]] && [[ "$memory_model" != "all"]];
then
    echo "Memory Model (-m) must be one, few, or all"
fi


cd $SAM_HOME
./scripts/generate_sparsity_sweep_mem_model.sh
./scripts/single_point_memory_model_runner.sh extensor_5000_1024.mtx