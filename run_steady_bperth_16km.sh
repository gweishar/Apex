#!/usr/bin/env zsh

### Job name
#BSUB -J apex_big_steady

### File / path where STDOUT & STDERR will be written
###    %J is the job ID, %I is the array ID
#BSUB -o job_logs/steady_16km_perth.%J.%I

### Send email when job is done
#BSUB -u gweishar@gmail.com
#BSUB -N

### Request the time you need for execution in minutes
### The format for the parameter is: [hour:]minute,
### that means for 80 minutes you could also use this: 1:20
#BSUB -W 00:50

### Request memory you need for your job in TOTAL in MB
#BSUB -M 3000

### Use esub for Open MPI
#BSUB -a openmpi

### Request number of slots
#BSUB -n 24

cd $HOME/projects/Apex
mpirun -n 24 ./Apex-opt -i problems/golden_input/d_steady_bperth_16km.i
