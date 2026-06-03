# Keil µVision 5 Nix Package

A deterministic, minimal-runtime Nix orchestrator for Keil µVision 5 (MDK and C51) on Linux via Wine.

## Overview

This project provides a Nix flake to install and run Keil µVision in an isolated, reproducible environment. Each package is a proper Nix derivation that:

1.  **Builds** the application using `requireFile` (installer must be provided manually).
2.  **Wraps** the result with a launcher script that copies files into a persistent Wine prefix (`~/.keil_prefix`) on first run.
3.  **Supports** both MDK (ARM) and C51 (8051) toolchains.

## Installer Setup

Because Keil software is proprietary, installers cannot be downloaded automatically. Use `nix-prefetch-url` to add them to the Nix store before building:

```bash
nix-prefetch-url --type sha256 file:///path/to/mdk543a.exe
nix-prefetch-url --type sha256 file:///path/to/c51v961.exe
```

Add the resulting hashes into `pkgs/keil-uvision.nix` and `pkgs/keil-c51.nix` respectively.

## Usage

### 1. Launch / Install Keil MDK (ARM)
```bash
nix run .#keil-uvision
```
If Keil is not installed in `~/.keil_prefix`, it will be copied from the Nix store. If already installed, it launches the µVision IDE.

### 2. Install Keil C51 (8051)
```bash
nix run .#keil-c51
```
This launches the C51 compiler installer into the same shared environment as MDK.

### 3. FHS Environment
For plugins or legacy scripts requiring a standard Linux hierarchy:
```bash
nix run .#keil-uvision-fhs
```

## Wine Prefix

By default, Keil is installed to `~/.keil_prefix`. You can override this by setting the `WINEPREFIX` environment variable:
```bash
WINEPREFIX=$HOME/.custom_keil nix run .#keil-uvision
```
