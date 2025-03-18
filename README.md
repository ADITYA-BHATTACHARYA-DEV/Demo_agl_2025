# Flutter App Embedded in AGL (Automotive Grade Linux) via Yocto

This guide provides a comprehensive walkthrough for creating a **Flutter App**, embedding it into an **AGL Yocto Image**, setting up a **Yocto layer**, hosting it on **GitHub**, and debugging potential errors.

---

## **1️⃣ Prerequisites**
### **System Requirements**
- **Ubuntu 22.04 LTS** (recommended)
- **Yocto Project setup** (AGL)
- **QEMU installed**
- **Flutter installed**
- **Git installed**
- **Python3 and dependencies installed**

### **Install Required Dependencies**
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget unzip build-essential python3 python3-pip
```

### **Install Flutter**
```bash
sudo snap install flutter --classic
```

### **Clone Workspace-Automation for AGL Flutter Integration**
```bash
git clone https://github.com/meta-flutter/workspace-automation.git
cd workspace-automation
```

---

## **2️⃣ Create and Build a Flutter App**

### **Initialize Flutter App**
```bash
flutter create agl_flutter_app
cd agl_flutter_app
```

### **Add Required Dependencies**
```bash
flutter pub add web_socket_channel http
```

### **Build the Flutter App for AGL**
```bash
flutter build linux
```

---

## **3️⃣ Embed Flutter App in AGL Yocto Image**

### **Copy Flutter App into AGL Root File System**
```bash
sudo mkdir -p /home/steve/agl-rootfs/usr/bin/
sudo cp -r build/linux/x64/release/bundle/flutter_app /home/steve/agl-rootfs/usr/bin/
sudo chmod +x /home/steve/agl-rootfs/usr/bin/flutter_app
```

### **Modify Yocto Recipe to Include Flutter App**
Create a new Yocto layer and add the Flutter app as a package.

```bash
cd ~/workspace-automation/meta-flutter
mkdir -p recipes-flutter/flutter-app
cd recipes-flutter/flutter-app
nano flutter-app.bb
```

Add the following content:
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

---

## **4️⃣ Host Yocto Layer on GitHub**

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

---

## **6️⃣ Debugging Common Errors**
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

## **7️⃣ Recommended Resources**
- **Yocto Project Documentation**: https://docs.yoctoproject.org
- **AGL Documentation**: https://docs.automotivelinux.org
- **Flutter Documentation**: https://flutter.dev/docs
- **Workspace Automation for AGL Flutter**: https://github.com/meta-flutter/workspace-automation

---

## **🎯 Summary**
- **Created a Flutter app** and built it for Linux.
- **Embedded the Flutter app into an AGL Yocto image**.
- **Created a Yocto recipe** and hosted the layer on GitHub.
- **Successfully ran AGL in QEMU** with the Flutter app.
- **Documented debugging steps** for common errors.

🚀 Now you have a Flutter app running inside AGL using Yocto! 🎉

