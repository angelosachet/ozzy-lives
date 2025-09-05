# Docker Installation Scripts

This repository contains several batch scripts for installing Docker Desktop and related development tools on Windows PCs.

## Scripts Overview

### 1. `docker_installer.bat` - Comprehensive Docker Installer
**Recommended for most users**

- ✅ Checks Windows version compatibility
- ✅ Verifies virtualization support
- ✅ Installs WSL2 automatically
- ✅ Downloads and installs Docker Desktop
- ✅ Comprehensive error handling
- ✅ Detailed status messages

### 2. `docker_simple.bat` - Simple Docker Installer
**For users who want minimal setup**

- ✅ Basic Docker Desktop installation
- ✅ WSL2 installation
- ✅ Lightweight and fast
- ✅ Less verbose output

### 3. `dev_environment_installer.bat` - Full Development Environment
**For developers setting up a complete environment**

- ✅ Interactive menu to choose components
- ✅ Docker Desktop
- ✅ Node.js LTS
- ✅ Git for Windows
- ✅ Visual Studio Code
- ✅ Customizable installation

### 4. `install.bat` - Legacy Script
**Your original script (Portuguese)**

- Installs Node.js and Docker Desktop
- Portuguese language interface

## Prerequisites

- Windows 10 (version 2004 or higher) or Windows 11
- Administrator privileges
- Internet connection
- At least 4GB of available disk space

## How to Use

1. **Download the script** you want to use
2. **Right-click** on the `.bat` file
3. Select **"Run as administrator"**
4. Follow the on-screen instructions

## Important Notes

### Before Installation
- Ensure virtualization is enabled in BIOS/UEFI settings
- Close any running applications
- Have a stable internet connection

### After Installation
- **Restart your computer** (required for WSL2 and Docker)
- Launch Docker Desktop from Start Menu
- Wait for Docker to complete initialization (may take 5-10 minutes)
- Accept Docker Desktop license agreement if prompted

### Troubleshooting Common Issues

#### 403 Error When Downloading Docker
- Try running the script again (temporary network issue)
- Check if your antivirus is blocking the download
- Verify internet connection

#### WSL2 Installation Issues
- Ensure Windows is up to date
- Enable "Virtual Machine Platform" in Windows Features
- Restart after enabling Windows features

#### Docker Desktop Won't Start
- Verify virtualization is enabled in BIOS
- Check Windows version compatibility
- Restart Windows after installation
- Try running Docker Desktop as administrator

## Manual Installation Alternative

If the scripts fail, you can install manually:

1. **WSL2**: Run `wsl --install` in PowerShell (as admin)
2. **Docker Desktop**: Download from [docker.com](https://www.docker.com/products/docker-desktop/)
3. **Node.js**: Download from [nodejs.org](https://nodejs.org/)
4. **Git**: Download from [git-scm.com](https://git-scm.com/)

## System Requirements

### Minimum Requirements
- Windows 10 version 2004 (Build 19041) or higher
- 4GB RAM
- BIOS-level hardware virtualization support

### Recommended Requirements
- Windows 11 or Windows 10 version 21H2
- 8GB RAM or more
- SSD storage
- Intel VT-x or AMD-V virtualization

## Verification

After installation, verify everything works:

```bash
# Check Docker
docker --version
docker run hello-world

# Check Node.js (if installed)
node --version
npm --version

# Check Git (if installed)
git --version
```

## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Ensure all prerequisites are met
3. Try running the script again as administrator
4. Check Docker Desktop documentation

## License

These scripts are provided as-is for educational and development purposes.