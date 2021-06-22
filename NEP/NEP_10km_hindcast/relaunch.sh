#!/bin/bash

cat run_nep_mom6_template.sh | sed -e "s/<RUN_YEAR>/$1/g" > run_nep_mom6.sh
sbatch --qos=urgent run_nep_mom6.sh



