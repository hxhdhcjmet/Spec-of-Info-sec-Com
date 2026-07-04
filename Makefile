# ==============================================================================
# Makefile for LaTeX Report
#
# Author : FoodTeam
#
# Requirements
# ------------------------------------------------------------------------------
# Required:
#   - GNU Make
#   - XeLaTeX (TeX Live / MiKTeX)
#
# Optional (recommended):
#   - latexmk
#
# Usage
# ------------------------------------------------------------------------------
# make
#       Compile the document using XeLaTeX (3 passes).
#       This mode has the best compatibility and does NOT require latexmk.
#
# make latexmk
#       Compile using latexmk (recommended if installed).
#       Automatically determines the required number of compilation passes.
#
# make clean
#       Remove all generated build files.
#
# make force
#       Clean and rebuild using XeLaTeX.
#
# make force-latexmk
#       Clean and rebuild using latexmk.
#
# make view
#       Open the generated PDF.
#
# Output
# ------------------------------------------------------------------------------
#   build/main.pdf
#
# ==============================================================================

# ----------------------------------------------------------------------
# Project configuration
# ----------------------------------------------------------------------

MAIN      := main
ENGINE    := xelatex
BUILDDIR  := build

TEXFLAGS  := \
	-interaction=nonstopmode \
	-halt-on-error \
	-file-line-error \
	-output-directory=$(BUILDDIR)

PDF := $(BUILDDIR)/$(MAIN).pdf

# ----------------------------------------------------------------------
# Platform detection
# ----------------------------------------------------------------------

ifeq ($(OS),Windows_NT)

	MKDIR = if not exist "$(BUILDDIR)" mkdir "$(BUILDDIR)"
	RMDIR = if exist "$(BUILDDIR)" rmdir /S /Q "$(BUILDDIR)"
	OPEN  = start "" "$(PDF)"
	NULL  = NUL

else

	MKDIR = mkdir -p "$(BUILDDIR)"
	RMDIR = rm -rf "$(BUILDDIR)"
	NULL  = /dev/null

	UNAME := $(shell uname)

	ifeq ($(UNAME),Darwin)
		OPEN = open "$(PDF)"
	else
		OPEN = xdg-open "$(PDF)"
	endif

endif

.PHONY: all latexmk clean force force-latexmk view

# ----------------------------------------------------------------------
# Default target
# ----------------------------------------------------------------------

all:
	@$(MKDIR)

	@echo.
	@echo ==================================================
	@echo Compiling with XeLaTeX (Pass 1/3)...
	@echo ==================================================
	@$(ENGINE) $(TEXFLAGS) $(MAIN).tex >$(NULL) 2>&1

	@echo.
	@echo ==================================================
	@echo Compiling with XeLaTeX (Pass 2/3)...
	@echo ==================================================
	@$(ENGINE) $(TEXFLAGS) $(MAIN).tex >$(NULL) 2>&1

	@echo.
	@echo ==================================================
	@echo Compiling with XeLaTeX (Pass 3/3)...
	@echo ==================================================
	@$(ENGINE) $(TEXFLAGS) $(MAIN).tex

	@echo.
	@echo ==================================================
	@echo Build succeeded.
	@echo Output: $(PDF)
	@echo ==================================================

# ----------------------------------------------------------------------
# Build using latexmk (optional)
# ----------------------------------------------------------------------

latexmk:
	@$(MKDIR)

	@echo.
	@echo ==================================================
	@echo Compiling with latexmk...
	@echo ==================================================
	@latexmk \
		-xelatex \
		-outdir=$(BUILDDIR) \
		$(MAIN).tex

	@echo.
	@echo ==================================================
	@echo Build succeeded.
	@echo Output: $(PDF)
	@echo ==================================================

# ----------------------------------------------------------------------
# Force rebuild
# ----------------------------------------------------------------------

force: clean all

force-latexmk: clean latexmk

# ----------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------

clean:
	@$(RMDIR)
	@echo Build directory removed.

# ----------------------------------------------------------------------
# Open PDF
# ----------------------------------------------------------------------

view:
	@$(OPEN)