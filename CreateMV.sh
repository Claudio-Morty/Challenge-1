#!/bin/bash

if [ $# -lt 7 ]; then
    echo "Uso: $0 <nombre_vm> <tipo_os> <cpus> <memoria_ram> <vram> <tamaño_disco> <controlador_sata> <controlador_ide>"
    exit 1
fi

VM_NAME=$1
OS_TYPE=$2
CPUS=$3
RAM_SIZE=$4
VRAM_SIZE=$5
DISK_SIZE=$6
SATA_CONTROLLER=$7
IDE_CONTROLLER=$8

echo "Se esta creando la máquina virtual con los siguientes parámetros:"
echo "Nombre de VM: $VM_NAME"
echo "Tipo de OS: $OS_TYPE"
echo "CPUs: $CPUS"
echo "Memoria RAM: ${RAM_SIZE}MB"
echo "VRAM: ${VRAM_SIZE}MB"
echo "Tamaño del Disco: ${DISK_SIZE}MB"
echo "Controlador SATA: $SATA_CONTROLLER"
echo "Controlador IDE: $IDE_CONTROLLER"


VBoxManage createvm --name "$VM_NAME" --ostype "$OS_TYPE" --register


VBoxManage modifyvm "$VM_NAME" --cpus "$CPUS" --memory "$RAM_SIZE" --vram "$VRAM_SIZE"


VBoxManage createhd --filename "$VM_NAME.vdi" --size "$DISK_SIZE" --format VDI


VBoxManage storagectl "$VM_NAME" --name "$SATA_CONTROLLER" --add sata --controller IntelAhci


VBoxManage storageattach "$VM_NAME" --storagectl "$SATA_CONTROLLER" --port 0 --device 0 --type hdd --medium "$VM_NAME.vdi"


VBoxManage storagectl "$VM_NAME" --name "$IDE_CONTROLLER" --add ide


VBoxManage storageattach "$VM_NAME" --storagectl "$IDE_CONTROLLER" --port 1 --device 0 --type dvddrive --medium emptydrive


VBoxManage showvminfo "$VM_NAME"


