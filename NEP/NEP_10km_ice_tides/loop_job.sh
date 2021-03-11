#!/bin/bash
#SBATCH --ntasks=504
#SBATCH --clusters=c4
#SBATCH --time=760
#SBATCH --job-name=NEP_10km_ICE_TID_BLL

cd /lustre/f2/scratch/gfdl/Liz.Drenkard/NEP

for y in {1983..1983}; do
    # Create data_table, replacing <YEAR> with the current year
    cat data_table.template | sed -e "s/<YEAR>/$y/g" > data_table
    cat MOM_input.template | sed -e "s/<YEAR>/$y/g" > MOM_input
    # For the first year of the run, the run begins from the given ICs
    if (( $y == 1981 )) ; then
	cat input.nml.template | sed -e "s/<RESTART>/n/g" -e "s/<YEAR>/$y/g"> input.nml    
        rm -f INPUT/MOM.res.nc
        rm -f INPUT/coupler.res
        rm -f INPUT/ice_model.res.nc
    # For later years of the run, the run begins from the restart saved in RESTART/
    else
        cat input.nml.template | sed -e "s/<RESTART>/r/g" -e "s/<YEAR>/$y/g"> input.nml
    	cp RESTART/MOM.res.nc INPUT/
        cp RESTART/coupler.res INPUT/
        cp RESTART/ice_model.res.nc INPUT/
    fi

    # run one year
    srun ./MOM6

    # if run completed, save duplicates of restarts
    # otherwise, exit
    if [ $? -eq 0 ]; then
        cp -r RESTART restarts_$y
        cp MOM_IC.nc restarts_$y
    else
        exit 1
    fi

done

