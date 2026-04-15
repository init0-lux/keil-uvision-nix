# Keil µVision 5 Nix Package

A deterministic, minimal-runtime Nix orchestrator for Keil µVision 5 (MDK and C51) on Linux via Wine.

## Overview

This project provides a Nix flake to run Keil µVision in an isolated, reproducible environment. Unlike traditional Nix packages that bundle all binaries into the Nix Store, this package uses a **minimal runtime orchestration** pattern:

1.  **Orchestration**: Nix manages the environment (Wine, aria2, and launcher scripts).
2.  **State**: The application is installed into a persistent Wine prefix in your home directory (`~/.keil_prefix`).
3.  **Speed**: Uses `aria2` for multi-threaded parallel downloads of installers if they aren't found locally.

## Features

-   **Parallel Downloads**: Integrated `aria2` with 16 connections for rapid installer fetching.
-   **Local Installer Support**: Detects `.exe` installers in the project root to avoid re-downloading.
-   **Multi-Compiler Support**: Support for both MDK (ARM) and C51 (8051) toolchains.
-   **Modern Wine**: Uses `wineWow64Packages` for efficient 32-bit execution on 64-bit Linux.

## Usage

### 1. Launch / Install Keil MDK (ARM)
```bash
nix run . --impure
```
If Keil is not installed, this will download and launch the MDK installer. If already installed, it launches the µVision IDE.

### 2. Install Keil C51 (8051)
```bash
nix run .#keil-c51 --impure
```
This launches the C51 compiler installer into the same shared environment as MDK.

### 3. FHS Environment
For plugins or legacy scripts requiring a standard Linux hierarchy:
```bash
nix run .#keil-uvision-fhs --impure
```

## Advanced

### Local Installers
To skip downloads, place the following officially downloaded files in the project root:
-   `mdk538a.exe` (MDK ARM)
-   `c51v961.exe` (C51 8051)

### Wine Prefix
By default, Keil is installed to `~/.keil_prefix`. You can override this by setting the `WINEPREFIX` environment variable:
```bash
WINEPREFIX=$HOME/.custom_keil nix run . --impure
```

## Performance Note
This package uses `builtins.fetchurl` or `aria2` at runtime to minimize the closure size and initial build time. The Nix derivation itself builds in seconds.
