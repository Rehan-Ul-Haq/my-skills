---
name: readme-generator
description: Guide for generating README.md files for projects. This skill should be used when users want to create a README file for their project, document their codebase, or update existing documentation.
---

# README Generator

This skill generates README.md files for software projects.

## When to Use

Use this skill when a user asks to:
- Create a README for a project
- Generate project documentation
- Document a codebase

## How to Generate a README

### Step 1: Analyze the Project

To understand the project, examine:
- Main entry point files (e.g., `main.py`, `index.js`, `app.py`)
- Package configuration (`package.json`, `pyproject.toml`, `Cargo.toml`)
- Existing documentation
- Directory structure

### Step 2: Gather Information

Identify:
- Project name and description
- Installation requirements
- Usage examples
- Key features

### Step 3: Generate README

Use the template in `assets/readme-template.md` as a starting point. Customize based on:
- Project type (CLI, library, web app)
- Language/framework
- User's specific requirements

### Standard Sections

A good README includes:

1. **Title and Description** - What the project does
2. **Installation** - How to install dependencies and set up
3. **Usage** - How to use the project with examples
4. **Examples** - Code snippets showing common use cases
5. **License** - Project license

### Output

Generate the README.md file in the project root directory.
