#!/bin/bash
#SBATCH -J rstudio
#SBATCH -o rstudio_%j.out
#SBATCH -p workshop

module purge
module load rstudio

port_job=$(echo "49152+$(echo ${SLURM_JOBID} | tail -c 4)" | bc)
vncserver
sleep 30s
vnc_display=$(awk '/New/{print $NF}' "${SLURM_JOB_NAME}_${SLURM_JOB_ID}.out")
port_vnc=$(awk '/port/{print $NF}' "${HOME}/.vnc/${vnc_display}.log")
ssh -N -R ${port_job}:localhost:${port_vnc} login01.m2.smu.edu &
echo "Using job port: ${port_job}"
echo "Using vnc port: ${port_vnc}"
echo "Mac/Linux: \"ssh -L ${port_vnc}:localhost:${port_job} ${USER}@login01.m2.smu.edu\""
wait

