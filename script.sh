#!/bin/sh

container_name="adb-client"

# Function to display the help message
show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  --up        Start Docker containers (sudo docker compose up -d)"
    echo "  --down      Stop and remove Docker containers (sudo docker compose down)"
    echo "  --devices    List connected devices via adb (sudo docker exec -it container-name adb devices)"
    echo "  --run       Run the Python script inside the container with config (sudo docker exec -it container-name python3 run.py --config config-examples/config.yml)"
    echo "  --help      Show this help message and exit"
    echo ""
}

# Check the provided argument
case "$1" in
    --up)
        echo "Starting Docker containers..."
        sudo docker compose up -d
        ;;
    --down)
        echo "Stopping and removing Docker containers..."
        sudo docker compose down
        ;;
    --devices)
        echo "Listing connected devices with adb..."
        sudo docker exec -it ${container_name} adb devices
        ;;
    --run)
        echo "Running the Python script inside the container..."
        sudo docker exec -it ${container_name} python3 run.py --config config-examples/config.yml
        ;;
    --help|*)
        show_help
        ;;
esac

