#/bin/bash

# Generador de evidencias de maquina
# Version: 1.1

# Variables
HOST=$(hostname)
FECHA=$(date +"%d%m%Y")
LOG_NAME="evidencias-${HOST}-${FECHA}.txt"

clear

echo "" > ""${LOG_NAME}""
echo "######################## INFO #######################" >> ""${LOG_NAME}""

echo "" >> ""${LOG_NAME}""
echo "Hostname: $(hostname)" >> ""${LOG_NAME}""
echo "Fecha: $(date)" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""

echo "###################### HARDWARE ######################" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""

echo "### PROCESADOR ###" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""
echo "$(grep -m 1 'model name' /proc/cpuinfo)" >> ""${LOG_NAME}""
echo "Nº Nucleos: $(grep processor /proc/cpuinfo | wc -l)" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""

echo "### MEMORIA ###" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""
echo "$(free -h)" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""

echo "### DISCOS ###" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""
echo "$(lsblk -nl)" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""

echo "##############  SISTEMA OPERATIVO  ################" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""

echo "Arquitectura: `uname -m` " >> "${LOG_NAME}"
echo "Kernel: `uname -r`" >> "${LOG_NAME}"
echo "Linux Distro: `cat /etc/*-release | head -1|cut -d '=' -f2`" >> "${LOG_NAME}"
echo "Version: $(grep DISTRIB_RELEASE /etc/*-release | cut -d '=' -f2)" >> "${LOG_NAME}"
echo "Nombre: $(grep DISTRIB_CODENAME /etc/*-release | cut -d '=' -f2)" >> "${LOG_NAME}" 
echo "UPTIME: `date +"%T"` " >> "${LOG_NAME}"

# Accesos fallidos SSH
echo "################ ACCESOS FALLIDOS SSH ####################" >> "${LOG_NAME}"
grep "Failed password" /var/log/auth.log >> "${LOG_NAME}"
echo "################" >> "${LOG_NAME}"
journalctl _SYSTEMD_UNIT=ssh.service | grep -E "Failed|Failure" >> "${LOG_NAME}"
echo "" >> "${LOG_NAME}"

echo "#################  FIN  ###############################" >> "${LOG_NAME}"
