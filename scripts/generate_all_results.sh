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
    memory_model="one"
fi

if [[ "$memory_model" != "one" && "$memory_model" != "few" && "$memory_model" != "all" ]];
then
    echo "Memory Model (-m) must be one, few, or all"
    return
fi

# Generate Table 1...
source /sam-artifact/scripts/generate_table_1.sh

# Generate Table 2...
source /sam-artifact/scripts/generate_table_2.sh

# Generate Figures 11, 12, 13...
source /sam-artifact/scripts/generate_figure_11_12_13.sh

# Generate Figure 14 (Stream Overhead)
source /sam-artifact/scripts/generate_stream_overhead.sh

# Generate Figure 14 (Memory Model)
source /sam-artifact/scripts/generate_memory_model.sh -m $memory_model