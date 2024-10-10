#!/bin/bash

# Variables for Python version and virtual environment name
PYTHON_VERSION="${1:-3.8.0}"    # Default Python version is 3.8.0 if not specified
VENV_NAME="${2:-myenv}"         # Default virtualenv name is 'myenv' if not specified

# Function to display help
show_help() {
    echo "Usage: $0 [PYTHON_VERSION] [VENV_NAME]"
    echo
    echo "Arguments:"
    echo "  PYTHON_VERSION   Optional. Specify the Python version to install (default: 3.8.0)"
    echo "  VENV_NAME        Optional. Specify the name of the virtualenv to create (default: myenv)"
    echo
    echo "Example:"
    echo "  $0 3.9.7 myenv39"
    echo "  This will install Python 3.9.7 and create a virtualenv named 'myenv39'."
    exit 0
}

# Check for help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# check packages
is_installed() {
    dpkg -s "$1" &>/dev/null
}


DEPENDENCIES=(
    "make"
    "build-essential"
    "libssl-dev"
    "zlib1g-dev"
    "libbz2-dev"
    "libreadline-dev"
    "libsqlite3-dev"
    "wget"
    "curl"
    "llvm"
    "libncurses-dev"
    "xz-utils"
    "tk-dev"
    "libffi-dev"
    "liblzma-dev"
    "python3-openssl"
)

# Update the system
echo "Updating the system..."
sudo apt-get update

# Install Python dependencies
echo "Checking and installing missing dependencies..."

for package in "${DEPENDENCIES[@]}"; do
    if is_installed "$package"; then
        echo "$package is already installed."
    else
        echo "$package is not installed. Installing [$package]..."
        sudo apt-get install -y "$package"
    fi
done


# Check if Python is installed
if command_exists python; then
    echo "Python is already installed."
else
    echo "Python is not installed. Installing Python..."
    sudo apt-get install -y python
fi

# Check if pyenv is installed
if command_exists pyenv; then
    echo "pyenv is already installed."
else
    echo "pyenv is not installed. Installing pyenv..."
    
    # Install pyenv using the official installation script
    curl https://pyenv.run | bash

    # Add pyenv to bashrc for automatic loading
    if ! grep -q 'export PATH="$HOME/.pyenv/bin:$PATH"' ~/.bashrc; then
        echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
        echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
        echo 'eval "$(pyenv init -)"' >> ~/.bashrc
        echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
    fi

    # Reload bashrc to make pyenv available in this session
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# Install the specified Python version via pyenv if not installed
if pyenv versions | grep -q "$PYTHON_VERSION"; then
    echo "Python version $PYTHON_VERSION is already installed."
else
    echo "Installing Python version $PYTHON_VERSION using pyenv..."
    pyenv install "$PYTHON_VERSION"
fi

# Create and activate the virtualenv if not already created
if pyenv virtualenvs | grep -q "$VENV_NAME"; then
    echo "Virtualenv $VENV_NAME already exists."
else
    echo "Creating virtualenv $VENV_NAME with Python version $PYTHON_VERSION..."
    pyenv virtualenv "$PYTHON_VERSION" "$VENV_NAME"
    # Activate the virtualenv
    echo "Activating virtualenv $VENV_NAME..."
    pyenv activate "$VENV_NAME"
    echo "Python version $PYTHON_VERSION installed and virtualenv $VENV_NAME is now active."
fi

# Final message
echo "Script execution completed.
