# Setting up your work environment

## Windows (Work In Progress)

1. Install [Git](https://git-scm.com/download/win) or from your CLI by executing ``winget install --id Git.Git``
2. Install [Visual Studio Code](https://code.visualstudio.com/download) on your computer. (If you have an editor of preference that's also fine)
3. Go to the left sidebar and look for Extensions (Ctrl+Shift+X) button and look for the **Verilog-HDL/SystemVerilog** extension then install
4. Create a folder on your computer where you want your club related work (including onboarding) to be stored
5. In that folder, open a terminal in VS Code and lone this repository by typing `git clone https://github.com/asicwru/asicwru-onboarding.git`

## Mac

1. Open your terminal and execute ``brew install git verilator yosys && brew install --cask gtkwave && pip install cocotb cocotb-bus``
2. Install [Visual Studio Code](https://code.visualstudio.com/download) on your computer.
3. Go to the left sidebar and look for Extensions (Ctrl+Shift+X) button and look for the **Verilog-HDL/SystemVerilog** extension then install
4. Create a folder on your computer where you want your club related work (including onboarding) to be stored
5. In that folder, open a terminal in VS Code and lone this repository by typing `git clone https://github.com/asicwru/asicwru-onboarding.git`

## Linux

1. Open your terminal and execute ``sudo apt update && sudo apt install git gtkwave verilator yosys -y && pip install cocotb cocotb-bus`` (assuming you're on a Debian-based distro, if not change to your respective package manager)
2. Install [Visual Studio Code](https://code.visualstudio.com/download) on your computer. (If you have an editor of preference that's also fine)
3. Go to the left sidebar and look for Extensions (Ctrl+Shift+X) button and look for the **Verilog-HDL/SystemVerilog** extension then install
4. Create a folder on your computer where you want your club related work (including onboarding) to be stored
5. In that folder, open a terminal in VS Code and lone this repository by typing `git clone https://github.com/asicwru/asicwru-onboarding.git`

> [!Note]
> **Turn off Copilot's in line code suggestions!**
>
> In VS Code, click the arrow next to the Copilot icon at the top of your VSCode window, choose **Configure Inline Suggestions**, and select **Disable Completions**. Then open **Settings**, search for `github.copilot.nextEditSuggestions.enabled`, and make sure it's unchecked. You may use AI to consult about digital design concepts but for the purpose of learning, do not let AI do the onboarding projects or the HDLBits exercises for you as they're meant to prepare you


For references on installation, you can refer from [EcrioniX](https://ecrionix.org/open-source-eda-tools/)'s guide
