#!/usr/bin/env zsh

### Job name
#BSUB -J apex_big_transient

### File / path where STDOUT & STDERR will be written
###    %J is the job ID, %I is the array ID
#BSUB -o job_logs/cd_transient.%J.%I

### Send email when job is done
#BSUB -u gweishar@gmail.com
#BSUB -N 

### Request the time you need for execution in minutes
### The format for the parameter is: [hour:]minute,
### that means for 80 minutes you could also use this: 1:20
#BSUB -W 03:00

### Request memory you need for your job in TOTAL in MB
#BSUB -M 4024

### Request the number of compute slots you want to use
#BSUB -n 8

### Use esub for Open MPI
#BSUB -a openmpi

### Use a specific machine
#BSUB -m mpi-l-bull

cd $HOME/projects/Apex
mpirun -n 16 ./Apex-opt -i problems/small_mesh/transient/cd_btransient_sperth.i
