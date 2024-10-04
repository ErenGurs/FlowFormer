#!/bin/bash

alias conductor='AWS_EC2_METADATA_DISABLED=true aws --endpoint-url https://conductor.data.apple.com'

if [ ! -d  "datasets/Sintel" ]; then
    mkdir -p "datasets"
    conductor s3 cp s3://egurses-diffusion/Datasets/MPI-Sintel-complete.zip  ./
    echo "Extracting MPI-Sintel-complete.zip ..."
    unzip MPI-Sintel-complete.zip -d datasets > /dev/null 2>&1
    mv datasets/MPI-Sintel-complete datasets/Sintel
fi

# conductor s3 cp --recursive s3://egurses-frc/ImagePairs/ ./ImagePairs/
#conductor s3 cp s3://mingchen_li/real_validation1.zip ./


if [[ $(conda env list) != *"flowformer"* ]]; then
    # Original environment
    # conda install pytorch=1.6.0 torchvision=0.7.0 cudatoolkit=10.1 matplotlib tensorboard scipy opencv -c pytorch
    # Alternativelyclone the env from 'iris'
    conda create --name flowformer --clone iris
    conda activate flowformer

    pip install yacs loguru einops timm==0.4.12
fi

conda activate flowformer

mkdir checkpoints/
conductor s3 cp s3://egurses-frc/models/flowformer/sintel.pth checkpoints/
