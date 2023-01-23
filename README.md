# sam-artifact
Repo for SAM artifact generation

## Overview
- Getting Started (X human-minutes + X compute-minutes)
- Build Docker (X human-minutes + X compute-minutes)
- Run and Validate Experiments:
  - Run and Validate Table 1 (X human-minutes
  - Run and Validate Table 2 (10 human-minutes + 8 compute-minutes)
  - Run and Validate Figure 11, 12, 13 ()
  - Run and Validate Figure 14 ()
  - Run and Validate Figure 15 () 
- How to reuse beyond the paper ( human-minutes + X compute-)

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

# Run and Validate Table 1
TODO

# Run and Validate Table 2
- Run the following commands
```
cd taco-website
./process.sh
``` 
  - `process.sh` will create two files `unique_formats.log` and `prim_data.log`
- Open `prim_data.log` and validate that the results match Table 2 on page 10

- Run and  
