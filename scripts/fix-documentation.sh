#!/bin/bash
# Script to automatically fix common documentation issues in Clariad

set -e # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Clariad Documentation Fixer${NC}"
echo "This script will automatically fix common issues found in the documentation."
echo

# Check if we're in the right directory
if [ ! -d "docs" ]; then
    echo -e "${RED}Error: 'docs' directory not found. Please run this script from the root of the Clariad repository.${NC}"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required tools
if ! command_exists "sed"; then
    echo -e "${RED}Error: 'sed' is required but not installed.${NC}"
    exit 1
fi

if ! command_exists "find"; then
    echo -e "${RED}Error: 'find' is required but not installed.${NC}"
    exit 1
fi

echo -e "${YELLOW}Starting documentation fixes...${NC}"

# 1. Create a backup of all documentation files
echo "Creating backup of documentation..."
BACKUP_DIR="docs_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r docs/* "$BACKUP_DIR/"
echo -e "${GREEN}Backup created at $BACKUP_DIR${NC}"

# 2. Rename files to follow kebab-case convention
echo "Renaming files to follow kebab-case convention..."
# This is a bit tricky to automate safely, so we'll log files that need renaming
RENAME_LOG="docs_rename_needed.txt"
rm -f "$RENAME_LOG"
touch "$RENAME_LOG"

find docs -type f -name "*.md" | while read -r file; do
    filename=$(basename "$file")
    dirname=$(dirname "$file")

    # Skip files that are already kebab-case or have special numbering patterns
    if [[ "$filename" =~ ^[a-z0-9]+(-[a-z0-9]+)*\.md$ || "$filename" =~ ^adr-[0-9]+-[a-z0-9-]+\.md$ || "$filename" =~ ^us-[0-9]+-[a-z0-9-]+\.md$ ]]; then
        continue
    fi

    # Convert CamelCase or snake_case to kebab-case
    new_filename=$(echo "$filename" | sed -E 's/([A-Z])/-\L\1/g' | sed 's/^-//' | sed 's/_/-/g' | tr '[:upper:]' '[:lower:]')

    # Log files that need renaming
    echo "mv \"$file\" \"$dirname/$new_filename\"" >> "$RENAME_LOG"
done

echo -e "${YELLOW}Files that need renaming are logged in $RENAME_LOG${NC}"
echo -e "${YELLOW}Review this file and execute the commands manually to avoid breaking links.${NC}"

# 3. Fix heading structure issues
echo "Fixing heading structure issues..."

# a. Fix multiple H1 headings (convert extra H1s to H2s)
find docs -type f -name "*.md" | while read -r file; do
    # Count H1 headings
    h1_count=$(grep -c '^# ' "$file" || true)

    if [ "$h1_count" -gt 1 ]; then
        echo "Fixing multiple H1s in $file"
        # Keep the first H1, convert others to H2
        sed -i.bak -E '0,/^# /! s/^# /## /' "$file"
        rm "${file}.bak"
    fi

    # Check if there's no H1 at all
    if [ "$h1_count" -eq 0 ]; then
        echo "No H1 found in $file, checking for H2 to promote"
        # If there's an H2 at the top, promote it to H1
        if grep -q '^## ' "$file"; then
            sed -i.bak '0,/^## /s/^## /# /' "$file"
            rm "${file}.bak"
            echo "Promoted first H2 to H1 in $file"
        else
            echo -e "${YELLOW}Warning: No H1 or H2 found in $file. Please add a title manually.${NC}"
        fi
    fi
done

# 4. Fix common formatting issues
echo "Fixing common formatting and grammar issues..."

# a. Fix "it's" vs "its" errors
find docs -type f -name "*.md" | xargs sed -i.bak 's/it\'s own/its own/g'
find docs -type f -name "*.md.bak" -delete

# b. Standardize terminology
find docs -type f -name "*.md" | xargs sed -i.bak 's/\bMCP\b/Model-Client Protocol (MCP)/g'
find docs -type f -name "*.md" | xargs sed -i.bak 's/\bbot\b/agent/gi'
find docs -type f -name "*.md.bak" -delete

# 5. Add metadata footer to files missing it
echo "Adding metadata footer to files missing it..."

find docs -type f -name "*.md" | while read -r file; do
    # Check if file already has metadata
    if ! grep -q "^\*Document Status:" "$file" && ! grep -q "^\*Last Updated:" "$file"; then
        echo "Adding metadata to $file"
        echo -e "\n---\n\n*Document Status: Draft*  \n*Last Updated: $(date +%Y-%m-%d)*  \n*Created By: Documentation Tool*  \n*Version: 1.0*" >> "$file"
    fi
done

# 6. Verify internal links (just checking, not fixing automatically)
echo "Checking internal links..."

BROKEN_LINKS_LOG="docs_broken_links.txt"
rm -f "$BROKEN_LINKS_LOG"
touch "$BROKEN_LINKS_LOG"

find docs -type f -name "*.md" | while read -r file; do
    # Extract markdown links with relative paths
    grep -o -P '\[.*?\]\((?!https?://|www\.).*?\)' "$file" | while read -r link; do
        # Extract the link target
        target=$(echo "$link" | sed -E 's/\[.*\]\((.+)\)/\1/')

        # Remove anchor part if exists
        target_file=$(echo "$target" | sed 's/#.*//')

        # Skip empty targets (link to the same file)
        if [ -z "$target_file" ]; then
            continue
        fi

        # Resolve relative path
        if [[ "$target_file" == /* ]]; then
            # Absolute path from repo root
            resolved_path="${target_file:1}"
        else
            # Relative path from the current file's directory
            resolved_path="$(dirname "$file")/$target_file"
        fi

        # Normalize path (handle ../ etc)
        resolved_path=$(realpath --relative-to="$(pwd)" "$resolved_path" 2>/dev/null || echo "$resolved_path")

        # Check if the file exists
        if [ ! -f "$resolved_path" ]; then
            echo "In $file: Broken link to $target_file (resolved to $resolved_path)" >> "$BROKEN_LINKS_LOG"
        fi
    done
done

if [ -s "$BROKEN_LINKS_LOG" ]; then
    echo -e "${YELLOW}Broken links found. Check $BROKEN_LINKS_LOG for details.${NC}"
else
    echo -e "${GREEN}No broken internal links found.${NC}"
    rm "$BROKEN_LINKS_LOG"
fi

echo -e "${GREEN}Documentation fixes completed!${NC}"
echo
echo "The following tasks require manual review:"
echo "1. Review and execute file renaming commands in $RENAME_LOG"
echo "2. Fix any broken links found in $BROKEN_LINKS_LOG (if it exists)"
echo "3. Update external links and add proper context to them"
echo "4. Fix Mermaid diagram syntax"
echo "5. Apply consistent style according to the style guide"
echo
echo -e "${YELLOW}Remember to test documentation changes by viewing them in GitHub or a Markdown viewer.${NC}"
