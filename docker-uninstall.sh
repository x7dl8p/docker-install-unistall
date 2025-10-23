#!/bin/bash
################################################################################
# Docker Complete Uninstallation Script
# This script removes Docker completely from your system
################################################################################

set -e  # Exit on error

echo "=================================="
echo "Docker Complete Uninstallation"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Stop all running containers
echo -e "${YELLOW}[1/7]${NC} Stopping all Docker containers..."
if command -v docker &> /dev/null; then
    sudo docker stop $(sudo docker ps -aq) 2>/dev/null || echo "No containers to stop"
    sudo docker rm $(sudo docker ps -aq) 2>/dev/null || echo "No containers to remove"
    echo -e "${GREEN}✓${NC} Containers stopped and removed"
else
    echo "Docker not found, skipping container cleanup"
fi
echo ""

# Step 2: Remove all Docker images and volumes
echo -e "${YELLOW}[2/7]${NC} Removing all Docker images, volumes, and networks..."
if command -v docker &> /dev/null; then
    sudo docker system prune -a --volumes -f 2>/dev/null || echo "No Docker data to clean"
    echo -e "${GREEN}✓${NC} Docker data cleaned"
else
    echo "Docker not found, skipping"
fi
echo ""

# Step 3: Uninstall Docker packages
echo -e "${YELLOW}[3/7]${NC} Uninstalling Docker packages..."
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras 2>/dev/null || echo "Some packages not found"
echo -e "${GREEN}✓${NC} Docker packages removed"
echo ""

# Step 4: Remove Docker directories
echo -e "${YELLOW}[4/7]${NC} Removing Docker directories..."
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo rm -rf ~/.docker
sudo rm -rf /etc/docker
echo -e "${GREEN}✓${NC} Docker directories removed"
echo ""

# Step 5: Remove Docker repository configuration
echo -e "${YELLOW}[5/7]${NC} Removing Docker repository configuration..."
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/keyrings/docker.gpg
echo -e "${GREEN}✓${NC} Repository configuration removed"
echo ""

# Step 6: Remove user from docker group
echo -e "${YELLOW}[6/7]${NC} Removing user from docker group..."
sudo deluser $USER docker 2>/dev/null || echo "User not in docker group"
sudo groupdel docker 2>/dev/null || echo "Docker group already removed"
echo -e "${GREEN}✓${NC} User permissions cleaned"
echo ""

# Step 7: Clean up unused dependencies
echo -e "${YELLOW}[7/7]${NC} Removing unused dependencies..."
sudo apt autoremove -y
echo -e "${GREEN}✓${NC} Unused dependencies removed"
echo ""

# Verification
echo "=================================="
echo "Verification:"
echo "=================================="
if command -v docker &> /dev/null; then
    echo -e "${RED}✗${NC} Docker is still installed"
    docker --version
else
    echo -e "${GREEN}✓${NC} Docker successfully removed"
fi
echo ""
echo "=================================="
echo -e "${GREEN}Uninstallation Complete!${NC}"
echo "=================================="
echo ""
echo "You may need to restart your system or log out and back in"
echo "to complete the cleanup process.",