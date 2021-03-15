#!/bin/bash
#SBATCH --ntasks=504
#SBATCH --clusters=c4
#SBATCH --time=12
#SBATCH --job-name=NEP_10km_IT_mix_fix

cd /lustre/f2/scratch/gfdl/Liz.Drenkard/NEP

export y=1980

srun ./MOM6

if [ $? -eq 0 ]; then
    cp -r RESTART restarts_$y
    cp MOM_IC.nc restarts_$y
else
    exit 1
fi

