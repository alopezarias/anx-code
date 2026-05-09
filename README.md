# VS Code JetBrains-like Dotfiles

Configuración personal de VS Code inspirada en JetBrains IDEs:

- WebStorm
- Rider
- PyCharm
- DataGrip

## Install base extensions manually

[![IntelliJ Keybindings](https://img.shields.io/badge/Install-IntelliJ%20Keybindings-blue?logo=visualstudiocode)](vscode:extension/k--kato.intellij-idea-keybindings)

[![GitHub Copilot](https://img.shields.io/badge/Install-GitHub%20Copilot-blue?logo=visualstudiocode)](vscode:extension/GitHub.copilot)

[![GitHub Copilot Chat](https://img.shields.io/badge/Install-Copilot%20Chat-blue?logo=visualstudiocode)](vscode:extension/GitHub.copilot-chat)

[![Material Icon Theme](https://img.shields.io/badge/Install-Material%20Icons-blue?logo=visualstudiocode)](vscode:extension/PKief.material-icon-theme)

[![Error Lens](https://img.shields.io/badge/Install-Error%20Lens-blue?logo=visualstudiocode)](vscode:extension/usernamehw.errorlens)

[![GitLens](https://img.shields.io/badge/Install-GitLens-blue?logo=visualstudiocode)](vscode:extension/eamodio.gitlens)

## One-command install

### macOS / Linux

```bash
git clone git@github.com:TU_USUARIO/vscode-jetbrains-dotfiles.git
cd vscode-jetbrains-dotfiles
chmod +x install.sh
./install.sh all
```

### Windows PowerShell

```powershell
git clone git@github.com:TU_USUARIO/vscode-jetbrains-dotfiles.git
cd vscode-jetbrains-dotfiles
.\install.ps1 all
```

## Install only one profile extension set

### WebStorm-like

```bash
./install.sh webstorm
```

```powershell
.\install.ps1 webstorm
```

### Rider-like

```bash
./install.sh rider
```

```powershell
.\install.ps1 rider
```

### PyCharm-like

```bash
./install.sh pycharm
```

```powershell
.\install.ps1 pycharm
```

### DataGrip-like

```bash
./install.sh datagrip
```

```powershell
.\install.ps1 datagrip
```

## Profiles

Cuando los perfiles estén exportados, estarán en:

```text
profiles/
├─ WebStorm-like.code-profile
├─ Rider-like.code-profile
├─ PyCharm-like.code-profile
└─ DataGrip-like.code-profile
```

Para importarlos:

1. Abre VS Code.
2. Ejecuta `Preferences: Open Profiles (UI)`.
3. Selecciona `Import Profile`.
4. Elige el archivo `.code-profile`.

## Notes

Cambia `TU_USUARIO` por tu usuario u organización de GitHub antes de usar los comandos de instalación.

