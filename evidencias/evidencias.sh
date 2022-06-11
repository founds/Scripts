#/bin/bash

# Generador de evidencias de maquina
# Version: 1.3

# Variables
HOST=$(hostname)
FECHA=$(date +"%d%m%Y")
LOG_NAME="evidencias-${HOST}-${FECHA}.txt"

clear

# Comprobar si hay actualizaciones del script
git pull

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

echo "################### ALMACENAMIENTO  #################" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""
echo "## FILE SYSTEMS  ##" >> ""${LOG_NAME}""
df -hP|sort -nk5  | sed "s/\(.*\)/\t\1/g" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""
echo "## PUNTOS DE MONTAJE ###" >> ""${LOG_NAME}""
cat /proc/mounts|sort  | sed "s/\(.*\)/\t\1/g" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""

echo "## FSTAB ##" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""
cat /etc/fstab|grep -v -e ^$ -e ^# | sed "s/\(.*\)/\t\1/g" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""

echo "##############  SISTEMA OPERATIVO  ################" >> ""${LOG_NAME}""
echo "" >> ""${LOG_NAME}""

echo "Arquitectura: `uname -m` " >> "${LOG_NAME}"
echo "Kernel: `uname -r`" >> "${LOG_NAME}"
echo "Linux Distro: `cat /etc/*-release | head -1|cut -d '=' -f2`" >> "${LOG_NAME}"
echo "Version: $(grep DISTRIB_RELEASE /etc/*-release | cut -d '=' -f2)" >> "${LOG_NAME}"
echo "Nombre: $(grep DISTRIB_CODENAME /etc/*-release | cut -d '=' -f2)" >> "${LOG_NAME}" 
echo "UPTIME: `date +"%T"` " >> "${LOG_NAME}"
echo "" >> ""${LOG_NAME}""

echo "###################### RED ######################" >> "${LOG_NAME}"
echo "" >> "${LOG_NAME}"
echo "$(ip a)" >> "${LOG_NAME}"
echo "" >> "${LOG_NAME}"

echo "###################### HOSTS ######################" >> "${LOG_NAME}"
echo "" >> "${LOG_NAME}"
echo "$(cat /etc/hosts)" >> "${LOG_NAME}"
echo "" >> "${LOG_NAME}"

echo "###################### USUARIOS ######################" >> "${LOG_NAME}"
echo "" >> "${LOG_NAME}"
echo "$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd)" >> "${LOG_NAME}"
echo "" >> "${LOG_NAME}"

# Comprobar si existe ssh
if which systemctl status sshd > /dev/null; then
  echo "################ SSH ####################" >> "${LOG_NAME}"
  echo "" >> "${LOG_NAME}"
  echo " -> Activo" >> "${LOG_NAME}"
  echo "" >> "${LOG_NAME}"
fi
echo "" >> "${LOG_NAME}"

# Comprobar si existe vagrant
if which vagrant global-status  > /dev/null; then
  echo "################ IMAGENES VAGRANT ####################" >> "${LOG_NAME}"
  echo "" >> "${LOG_NAME}"
  vagrant global-status >> "${LOG_NAME}"
  echo "" >> "${LOG_NAME}"
fi
echo "" >> "${LOG_NAME}"

# Comprobar si existe docker
if which docker ps -a  > /dev/null; then
  echo "################ IMAGENES DOCKER ####################" >> "${LOG_NAME}"
  echo "" >> "${LOG_NAME}"
  docker ps -a >> "${LOG_NAME}"
  echo "" >> "${LOG_NAME}"
fi
echo "" >> "${LOG_NAME}"

# Comprobar si existe apache2
if which apache2ctl > /dev/null; then
  echo "################ PAGINAS EN APACHE ####################" >> "${LOG_NAME}"
  echo "" >> "${LOG_NAME}"
  apache2ctl -S | grep namevhost | awk -F ' ' '{ print $4 }' >> "${LOG_NAME}"
  echo "" >> "${LOG_NAME}"
fi
echo "" >> "${LOG_NAME}"

echo "" >> "${LOG_NAME}"
echo "#################  FIN  ###############################" >> "${LOG_NAME}"
