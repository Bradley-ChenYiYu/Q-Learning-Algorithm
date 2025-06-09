#!/bin/bash
container_name="Q-Learning"
image_name="q-learning"
script_path=$(realpath "$0")
docker_path=$(dirname "$script_path")
workspace_path=$(dirname "$docker_path")
echo "Script path: $script_path"
echo "Workspace path: $workspace_path"
return 0
# Check if the image is built
if [ -z "$(docker images -q $image_name)" ]; then
    echo "Image $image_name not found. Building the image..."
    # docker build -t $image_name $docker_path
    docker build -t "$image_name" "$docker_path"
else
    echo "Image $image_name found."
fi

if [ -z "$(docker ps -a -q -f name=$container_name)" ]; then
    echo 'container not exist'
    # --network host \
    # --privileged \
    # -v /tmp/.X11-unix:/tmp/.X11-unix \
    # -e DISPLAY=$DISPLAY \
    # -w /RTAB_Nav2_ArUco \
    docker run -it -d --init \
        --name $container_name \
        --network host \
        -v "$workspace_path":"/q-learning" \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=$DISPLAY \
	    -w /q-learning \
        --gpus all \
        $image_name
else
    echo 'container exist'
    docker start $container_name
fi

# Unset variables
unset script_path
unset docker_path
unset workspace_path
unset container_name
unset image_name
