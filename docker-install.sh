#!/bin/bash
################################################################################
# Docker Complete Installation Script
# This script installs Docker Engine and Docker Compose with proper configuration
################################################################################

set -e  # Exit on error

echo "=================================="
echo "Docker Complete Installation"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running on supported OS
if [ ! -f /etc/os-release ]; then
    echo -e "${RED}Error: Cannot detect OS. This script supports Ubuntu/Debian based systems.${NC}"
    exit 1
fi

source /etc/os-release
echo -e "${BLUE}Detected OS: $PRETTY_NAME${NC}"
echo ""

# Step 1: Update package index
echo -e "${YELLOW}[1/9]${NC} Updating package index..."
sudo apt-get update
echo -e "${GREEN}✓${NC} Package index updated"
echo ""

# Step 2: Install prerequisites
echo -e "${YELLOW}[2/9]${NC} Installing prerequisite packages..."
sudo apt-get install -y ca-certificates curl gnupg lsb-release
echo -e "${GREEN}✓${NC} Prerequisites installed"
echo ""

# Step 3: Create keyrings directory
echo -e "${YELLOW}[3/9]${NC} Creating keyrings directory..."
sudo install -m 0755 -d /etc/apt/keyrings
echo -e "${GREEN}✓${NC} Directory created"
echo ""

# Step 4: Add Docker's GPG key
echo -e "${YELLOW}[4/9]${NC} Adding Docker's official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo -e "${GREEN}✓${NC} GPG key added"
echo ""

# Step 5: Set up Docker repository
echo -e "${YELLOW}[5/9]${NC} Setting up Docker repository..."
# Use Ubuntu codename for Zorin OS and other Ubuntu-based distros
if [ "$ID" = "zorin" ] || [ "$ID_LIKE" = *"ubuntu"* ]; then
    UBUNTU_CODENAME=${UBUNTU_CODENAME:-$VERSION_CODENAME}
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
elif [ "$ID" = "debian" ]; then
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $VERSION_CODENAME stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
else
    echo -e "${RED}Warning: Unsupported distribution. Attempting Ubuntu repository...${NC}"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi
echo -e "${GREEN}✓${NC} Repository added"
echo ""

# Step 6: Update package index again
echo -e "${YELLOW}[6/9]${NC} Updating package index with Docker repository..."
sudo apt-get update
echo -e "${GREEN}✓${NC} Package index updated"
echo ""

# Step 7: Install Docker Engine
echo -e "${YELLOW}[7/9]${NC} Installing Docker Engine and components..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo -e "${GREEN}✓${NC} Docker installed"
echo ""

# Step 8: Add user to docker group
echo -e "${YELLOW}[8/9]${NC} Adding current user to docker group..."
sudo usermod -aG docker $USER
echo -e "${GREEN}✓${NC} User added to docker group"
echo ""

# Step 9: Enable and start Docker service
echo -e "${YELLOW}[9/9]${NC} Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker
echo -e "${GREEN}✓${NC} Docker service started"
echo ""

# Verification
echo "=================================="
echo "Verification:"
echo "=================================="
echo -e "${BLUE}Docker Version:${NC}"
docker --version
echo ""
echo -e "${BLUE}Docker Compose Version:${NC}"
docker compose version
echo ""
echo -e "${BLUE}Docker Service Status:${NC}"
sudo systemctl is-active docker
echo ""

# Test Docker
echo -e "${YELLOW}Testing Docker...${NC}"
if sudo docker run --rm hello-world > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Docker is working correctly!"
else
    echo -e "${RED}✗${NC} Docker test failed"
fi
echo ""
echo "=================================="
echo -e "${GREEN}Installation Complete!${NC}"
echo "=================================="
echo ""
echo -e "${YELLOW}IMPORTANT:${NC}"
echo "1. You need to log out and log back in (or restart)"
echo "   for docker group permissions to take effect"
echo ""
echo "2. After logging back in, you can run Docker commands without sudo:"
echo "   docker run hello-world"
echo ""
echo "3. Useful commands:"
echo "   - docker ps                    (list running containers)"
echo "   - docker images                (list images)"
echo "   - docker compose up -d         (start compose project)"
echo "   - docker compose down          (stop compose project)"
echo "   - docker system prune -a       (clean up unused data)"
echo ""