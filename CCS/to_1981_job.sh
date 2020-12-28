#!/bin/bash
#SBATCH --ntasks=360
#SBATCH --clusters=c4
#SBATCH --time=20
#SBATCH --job-name=CCS_soda

cd /lustre/f2/scratch/gfdl/Liz.Drenkard/CCS

export y=1980

srun ./MOM6

if [ $? -eq 0 ]; then
    cp -r RESTART restarts_$y
    cp MOM_IC.nc restarts_$y
else
    exit 1
fi

