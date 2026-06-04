# Shared utilities for project scripts
# Usage: . "$(dirname "$0")/_common.sh"

set -e

# Navigate to the project root
cd "$(dirname "$0")/.."

# Terminal colors
RED=$'\e[1;31m'
GREEN=$'\e[1;32m'
RESET=$'\e[0m'

# Print a colored status message
status() {
  printf "\n${GREEN}# %s\n--------------------------------------------------${RESET}\n" "$1"
}
