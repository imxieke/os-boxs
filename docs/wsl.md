## WSL 2
- Open PowerShell as administrator and run:
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

- Restart

- Open PowerShell as administrator and run:

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

- Restart
` wsl --set-default-version 2`

## WSL url

### Archlinux
- https://github.com/yuk7/ArchWSL/releases

### CentOS
- https://github.com/mishamosher/CentOS-WSL/releases

* Redhat
- https://github.com/yosukes-dev/RHWSL/releases

### Fedora
- https://github.com/yosukes-dev/FedoraWSL

### Manjaro
- https://github.com/sileshn/ManjaroWSL

### Alpine
- https://github.com/yuk7/AlpineWSL