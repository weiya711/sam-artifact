cd $SAM_HOME
./scripts/generate_synthetics.sh
./scripts/run_synthetics.sh
python sam/onyx/synthetic/plot_synthetics.py 