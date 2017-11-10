#!/bin/bash
#SBATCH -J vnc_rstudio
#SBATCH -o vnc_rstudio_%j.out
#SBATCH -p workshop

cat << 'EOF' > ${HOME}/.vnc/xstartup
#!/bin/sh

module purge
module load rstudio

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
. /etc/X11/xinit/xinitrc-common
xfwm4 &
rstudio
EOF

port_job=$(echo "49152+$(echo ${SLURM_JOBID} | tail -c 4)" | bc)
vncserver -geometry 1920x1080
sleep 30s
vnc_display=$(awk '/New/{print $NF}' "${SLURM_JOB_NAME}_${SLURM_JOB_ID}.out")
port_vnc=$(awk '/port/{print $NF}' "${HOME}/.vnc/${vnc_display}.log")
ssh -N -R ${port_job}:localhost:${port_vnc} login01.m2.smu.edu &
echo "Using job port: ${port_job}"
echo "Using vnc port: ${port_vnc}"
echo "Mac/Linux: \"ssh -L ${port_vnc}:localhost:${port_job} ${USER}@login01.m2.smu.edu\""
echo "Access VNC instance using: \"localhost:${port_vnc}\""
wait
