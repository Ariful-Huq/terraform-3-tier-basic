#!/bin/bash
set -e

# Log all output to a file
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "========================================"
echo "Starting BMI Health Tracker Deployment"
echo "Time: $(date)"
echo "========================================"

# Update and upgrade system packages
apt-get update -qq
apt-get upgrade -y -qq
echo "[SUCCESS] System updated"

# Install essential packages
apt-get install -y net-tools zip unzip

# Clone the application repository
echo "Cloning application from GitHub..."
DEPLOY_DIR="/home/ubuntu/bmi-health-tracker"
git clone https://github.com/Ariful-Huq/terraform-3-tier-basic.git "$DEPLOY_DIR"

cd "$DEPLOY_DIR"

echo "========================================"
echo "Application cloned successfully!"
echo "Repository: https://github.com/Ariful-Huq/terraform-3-tier-basic.git"
echo "Location: $DEPLOY_DIR"
echo "========================================"

# Verify critical files exist
if [ ! -f "IMPLEMENTATION_AUTO.sh" ]; then
    echo "ERROR: IMPLEMENTATION_AUTO.sh not found in repository!"
    exit 1
fi

if [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    echo "ERROR: backend or frontend directory not found!"
    exit 1
fi

echo "✓ All required files present"

# Set proper ownership
chown -R ubuntu:ubuntu "$DEPLOY_DIR"

# Make deployment script executable (if not already)
chmod +x "$DEPLOY_DIR/IMPLEMENTATION_AUTO.sh"

# Run the deployment script with auto-confirmation
echo "========================================"
echo "Starting automated deployment..."
echo "========================================"

# Database credentials from Terraform variables
export DB_NAME="${db_name}"
export DB_USER="${db_user}"
export DB_PASSWORD="${db_password}"

echo "========================================"
echo "Database Configuration"
echo "========================================"
echo "DB_NAME: $DB_NAME"
echo "DB_USER: $DB_USER"
echo "DB_PASSWORD: [REDACTED - Length: ${#DB_PASSWORD} characters]"
echo "========================================"

# Run the deployment script with environment variables
echo "========================================"
echo "Starting automated deployment..."
echo "========================================"

# Execute deployment with environment variables passed to ubuntu user
# Using bash -c to ensure environment variables are properly exported
echo "Executing deployment script..."
echo "y" | sudo -u ubuntu -E bash -c "cd '$DEPLOY_DIR' && ./IMPLEMENTATION_AUTO.sh --fresh" 2>&1 | tee /var/log/bmi-deployment.log
# Execute the deployment
# Note: This will run in background and log to /var/log/bmi-deployment.log
# The actual deployment requires the full application code to be present

echo "========================================"
echo "Userdata script completed"
echo "Time: $(date)"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. SSH into the instance"
echo "2. Provide the application source code"
echo "3. Run the deployment script manually if needed"
echo ""
echo "Check logs:"
echo "  sudo tail -f /var/log/user-data.log"
echo "Deployment status:"
echo "  Application cloned from: https://github.com/Ariful-Huq/terraform-3-tier-basic.git"
echo "  Location: $DEPLOY_DIR"
echo "  Deployment script executed successfully!"