#!/bin/bash
# Function to run all benchmarks based on input config
run_benchmarks() {
    for item in /users/u3593094/elec3441hw2/benchmarks/*; do
        if [ -d "$item" ]; then
            dir_name=$(basename "$item")
            cd $item
            echo "$dir_name-$1-$2-$3-$4"
            echo "$dir_name-$1-$2-$3-$4" >> "/users/u3593094/line_size-$4-result.txt"
            spike --ic=128:1:32 --dc="$2:$3:$4" pk "$dir_name" >> "/users/u3593094/line_size-$4-result.txt"
            echo "end" >> "/users/u3593094/line_size-$4-result.txt"
            cd ..
        fi
    done
}



line_size_li=(16 32)
assoc_li=(1 2 4 8 16 32 64)
capacity_li=(4096 8192 16384 32768 65536 131072 262144 524288 1048576 2097152)
for line_size in "${line_size_li[@]}"; do
    echo "" > "line_size-$line_size-result.txt" # initialize the result file
    for assoc in "${assoc_li[@]}"; do
        for capacity in "${capacity_li[@]}"; do
            entries=$((capacity / line_size / assoc))
            if [ $entries -le 16 ]; then # skip if entries is less than 16, because the given table set this
                continue
            fi
            run_benchmarks $capacity $entries $assoc $line_size
        done
    done
done

