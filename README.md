# Flutter App Embedded in AGL (Automotive Grade Linux) via Yocto

This guide provides a comprehensive walkthrough for creating a **Flutter App**, embedding it into an **AGL Yocto Image**, setting up a **Yocto layer**, hosting it on **GitHub**, and debugging potential errors. By following this document, you will gain insights into how Flutter can be integrated into an automotive-grade environment, leveraging Yocto’s customization capabilities.

---

## **1️⃣ Prerequisites**
### **System Requirements**
To ensure a smooth setup, make sure your system meets the following requirements:
- **Ubuntu 22.04 LTS** (recommended)
- **Yocto Project setup** (AGL)
- **QEMU installed** for emulation
- **Flutter installed** to develop the application
- **Git installed** for version control
- **Python3 and dependencies installed** to support build processes

### **Install Required Dependencies**
Before proceeding, install the necessary tools and dependencies required for the development and integration:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget unzip build-essential python3 python3-pip
```

### **Install Flutter**
Flutter is required to build the application. Install it using the Snap package manager:
```bash
sudo snap install flutter --classic
```

### **Clone Workspace-Automation for AGL Flutter Integration**
This repository contains necessary configurations and scripts to streamline Flutter-AGL integration:
```bash
git clone https://github.com/meta-flutter/workspace-automation.git
cd workspace-automation
```

---

## **2️⃣ Create and Build a Flutter App**

Flutter provides a structured way to create cross-platform applications. Let’s create and configure our application:

### **Initialize Flutter App**
```bash
flutter create agl_flutter_app
cd agl_flutter_app
```
This will generate the basic Flutter project structure with essential files like `main.dart`, `pubspec.yaml`, and necessary dependencies.

### **Add Required Dependencies**
To interact with AGL over WebSocket and HTTP, add the required dependencies:
```bash
flutter pub add web_socket_channel http
```

### **Build the Flutter App for AGL**
Before embedding it into AGL, compile the application for Linux:
```bash
flutter build linux
```
This will generate a compiled application under:
```bash
build/linux/x64/release/bundle/flutter_app
```

Expected output:
```
Building Linux application...
Successfully built!
```

---

## **3️⃣ Embed Flutter App in AGL Yocto Image**

Yocto allows us to customize the AGL image by adding our application as a package.

### **Copy Flutter App into AGL Root File System**
```bash
sudo cp -r build/linux/x64/release/bundle /home/steve/agl-rootfs/usr/bin/flutter_app
sudo chmod +x /home/steve/agl-rootfs/usr/bin/flutter_app
```

This step ensures that the application is present within the AGL file system and has the necessary execution permissions.

### **Modify Yocto Recipe to Include Flutter App**
Create a new Yocto layer and add the Flutter app as a package.
```bash
cd ~/workspace-automation/meta-flutter
mkdir recipes-flutter
cd recipes-flutter
nano flutter-app.bb
```

Add the following content to `flutter-app.bb`:
```bash
DESCRIPTION = "Flutter Application for AGL"
LICENSE = "MIT"
SRC_URI = "file://flutter_app"
S = "${WORKDIR}/flutter_app"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/flutter_app ${D}${bindir}/flutter_app
}
FILES_${PN} += "${bindir}/flutter_app"
```

Save and exit (`CTRL + X`, then `Y`, then `Enter`).

This `.bb` file defines how our Flutter app is installed within the AGL system, specifying its source location and how it should be copied into the image.

---

## **4️⃣ Host Yocto Layer on GitHub**

Once the custom Yocto layer is set up, it needs to be version-controlled for easy collaboration and reproducibility.

### **Initialize Git Repository**
```bash
cd ~/workspace-automation/meta-flutter
git init
echo "build/\nwork/\ntmp/\nsstate-cache/\ndownloads/" > .gitignore
git add .
git commit -m "Initial commit of meta-flutter layer"
```

### **Push to GitHub**
1. Create a new repository on GitHub (e.g., `meta-flutter`).
2. Link the repository:
```bash
git remote add origin https://github.com/YOUR_USERNAME/meta-flutter.git
git branch -M main
git push -u origin main
```

---

## **5️⃣ Running AGL with Flutter App**

### **Run AGL in QEMU**
```bash
run-agl-ivi-demo-flutter-qemu
```

### **Access Flutter App via SSH**
```bash
ssh root@localhost -p 2222
/usr/bin/flutter_app
```

Expected output:
```
Running Flutter Application...
AGL Vehicle Data
Battery Status: 78%
Speed: 60 km/h
Engine Status: Running
```

---

## **6️⃣ Debugging Common Errors**

While working with Yocto, you may encounter errors. Below are some common issues and solutions:

### **Issue: `afm-util: command not found`**
#### **Solution:** Ensure that AGL is correctly set up and the environment variables are loaded:
```bash
source poky/oe-init-build-env
```

### **Issue: `flutter: command not found`**
#### **Solution:** Ensure Flutter is correctly installed and available in the PATH:
```bash
export PATH="$HOME/snap/flutter/common/flutter/bin:$PATH"
```

### **Issue: `No such file or directory` when running Flutter App**
#### **Solution:** Verify the correct path:
```bash
ls -l /home/steve/agl-rootfs/usr/bin/flutter_app
```
If the file does not exist, rebuild and copy it again.

### **Issue: `SSH Connection Refused`**
#### **Solution:** Check if the SSH service is running in QEMU:
```bash
ps aux | grep sshd
```
If not running, restart it:
```bash
service ssh start
```

### **Issue: `Git Add Taking Too Long` for Yocto Layer**
#### **Solution:** Exclude unnecessary build files:
```bash
echo "build/\nwork/\ntmp/\nsstate-cache/\ndownloads/" > .gitignore
git add .
git commit -m "Optimized commit"
```

---

## **🎯 Summary**
- **Created a Flutter app** and built it for Linux.
- **Embedded the Flutter app into an AGL Yocto image**.
- **Created a Yocto recipe** and hosted the layer on GitHub.
- **Successfully ran AGL in QEMU** with the Flutter app.
- **Documented debugging steps** for common errors.

🚀 Now you have a Flutter app running inside AGL using Yocto! 🎉

