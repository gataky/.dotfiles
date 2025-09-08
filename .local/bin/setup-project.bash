#!/bin/bash

# A script to automate the setup of new projects with asdf, direnv, and language-specific tools.

echo "🚀 Welcome to the Project Setup Assistant!"
echo "This script will help you configure a new project with asdf and direnv."
echo "--------------------------------------------------------"

# --- User Input Section ---

# Prompt for the project type
echo "What type of project are you setting up?"
echo "1. Python  (with 'layout poetry')"
echo "2. Node.js (with 'layout node')"
echo "3. Go      (with 'layout go')"
echo "4. Other / Manual"
read -p "Enter your choice (1-4): " project_type

# Determine the tool name based on the user's choice
case $project_type in
    1) tool_name="python" ;;
    2) tool_name="nodejs" ;;
    3) tool_name="golang" ;;
    4) tool_name="" ;; # No specific tool for manual setup
    *)
        echo "❌ Invalid choice. Please run the script again with a valid option."
        exit 1
        ;;
esac

# If a tool was chosen, list the installed versions
if [[ -n "$tool_name" ]]; then
    echo "🔎 Checking for installed versions of $tool_name..."
    echo "Available versions:"
    asdf list "$tool_name"
fi

# Prompt for the desired version
read -p "Enter the desired version: " version

# Prompt for the directory to operate in
read -p "Enter the project directory (press Enter for current directory): " project_dir
if [[ -z "$project_dir" ]]; then
    project_dir="."
fi

# Go into the project directory
# The || { ... } syntax provides a fallback if the command fails.
cd "$project_dir" || { echo "❌ Directory not found. Exiting."; exit 1; }

# --- Core Logic Functions ---

# Function to set up asdf and direnv for a given language
setup_asdf_and_direnv() {
    local lang_tool="$1"
    local version="$2"
    local direnv_layout="$3"

    echo "⚙️ Setting up $lang_tool with asdf version $version..."

    # Check if the asdf plugin for the language is already installed
    if ! asdf which "$lang_tool" &>/dev/null; then
        echo "🤔 asdf plugin for $lang_tool not found. Installing..."
        asdf plugin add "$lang_tool" || { echo "❌ Failed to install asdf plugin. Exiting."; exit 1; }
    fi

    # Install the specific version and set it locally for the project
    asdf install "$lang_tool" "$version" || { echo "❌ Failed to install $lang_tool version. Exiting."; exit 1; }
    asdf set "$lang_tool" "$version" || { echo "❌ Failed to set local $lang_tool version. Exiting."; exit 1; }

    # Create and configure the .envrc file
    echo "Creating .envrc file with direnv configuration..."
    echo "$direnv_layout" > .envrc

    echo "⏳ Allowing direnv to load the new configuration..."
    # The 'direnv allow .' command is crucial for enabling the environment
    direnv allow .

    echo "✅ Setup complete for $lang_tool! You're ready to go."
    echo "You can now run commands like '$lang_tool --version'."
}

# --- Main Script Execution ---

case $project_type in
    1)
        # Python setup
        setup_asdf_and_direnv "python" "$version" "layout poetry"
        echo "💡 Don't forget to run 'poetry install' to set up your dependencies."
        ;;
    2)
        # Node.js setup
        setup_asdf_and_direnv "nodejs" "$version" "layout node"
        echo "💡 You can now run 'npm install' to install dependencies."
        ;;
    3)
        # Go setup
        setup_asdf_and_direnv "golang" "$version" "layout go"
        echo "💡 The 'go.mod' file will be created when you run a go command."
        ;;
    4)
        # Manual setup
        echo "You chose 'Other / Manual'. The script will not make any changes."
        echo "You can manually set up your project using the following commands:"
        echo "  - asdf plugin add <tool>"
        echo "  - asdf install <tool> <version>"
        echo "  - asdf local <tool> <version>"
        echo "  - echo 'layout <your_layout>' > .envrc"
        echo "  - direnv allow ."
        ;;
esac

echo "--------------------------------------------------------"
echo "✅ Script finished."
