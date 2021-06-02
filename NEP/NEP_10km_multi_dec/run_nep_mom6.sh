#!/bin/bash
#SBATCH --ntasks=415
#SBATCH --clusters=c4
#SBATCH --job-name=NEP_10km_multi_dec
#SBATCH --time=780

# set sbatch time to 20 for 1994
cd /lustre/f2/scratch/gfdl/Liz.Drenkard/NEP_10km_multi_dec

y=2009


if (( $y == 1994 )) ; then
	r="n"; mr=0; hr=35; m=12; d=30; h=13
	init_fil="init.nc"	
        rm -f INPUT/MOM.res.nc
        rm -f INPUT/coupler.res
        rm -f INPUT/ice_model.res.nc	
else
	r="r"; mr=12; hr=0; m=1; d=1; h=0
	init_fil="1995_restart.nc"
	cp RESTART/MOM.res.nc INPUT/
        cp RESTART/coupler.res INPUT/
        cp RESTART/ice_model.res.nc INPUT/
fi

cat data_table.template | sed -e "s/<YEAR>/$y/g" > data_table
cat MOM_input.template | sed -e "s/<YEAR>/$y/g" -e "s/<INITIAL_CONDITION>/$init_fil/g"> MOM_input
cat MOM_override.template | sed -e "s/<YEAR>/$y/g" > MOM_override
cat input.nml.template | sed -e "s/<RESTART>/$r/g" -e "s/<MONTH_RUN>/$mr/g" -e "s/<HR_RUN>/$hr/g" -e "s/<YEAR>/$y/g" -e "s/<MONTH>/$m/g" -e "s/<DAY>/$d/g" -e "s/<HOUR>/$h/g" > input.nml

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

