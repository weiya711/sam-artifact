# Get command line arg for memory model
while getopts m flag
do
    case "${flag}" in
        m) memory_model=${OPTARG};;
    esac
done

if [ -z "$memory_model" ];
then
    echo "Defaulting memory model to one..."
    memory_model = "one"
fi

if [[ "$memory_model" != "one" && "$memory_model" != "few" && "$memory_model" != "all" ]];
then
    echo "Memory Model (-m) must be one, few, or all"
    return
fi

# Generate Table 1...
./scripts/generate_table_1.sh

# Generate Table 2...
./scripts/generate_table_2.sh

# Generate Figures 11, 12, 13...
./scripts/generate_figure_11_12_!3.sh

# Generate Figure 14 (Stream Overhead)
./scripts/generate_stream_overhead.sh

# Generate Figure 14 (Memory Model)
./scripts/generate_memory_model.sh -m $memory_model