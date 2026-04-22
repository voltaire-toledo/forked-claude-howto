#!/usr/bin/env bash
# GitHub Copilot Knowledge Self-Assessment Quiz
# Tests your understanding of GitHub Copilot concepts across 10 categories.

set -euo pipefail

# ── ANSI colour codes ──────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# ── Score tracking ─────────────────────────────────────────────────────────────
SCORE=0
TOTAL=10
declare -A WRONG_MODULES   # map of module name → 1 when user got it wrong

# ── Helpers ────────────────────────────────────────────────────────────────────
print_header() {
  clear
  echo -e "${CYAN}${BOLD}"
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║       GitHub Copilot in a Weekend — Self-Assessment Quiz     ║"
  echo "╚══════════════════════════════════════════════════════════════╝"
  echo -e "${RESET}"
}

print_question() {
  local num="$1" total="$2" category="$3" question="$4"
  echo -e "${BOLD}Question ${num}/${total}  ${DIM}[${category}]${RESET}"
  echo -e "${BOLD}${question}${RESET}\n"
}

ask_question() {
  # ask_question <num> <category> <question> <correct_letter> <tip> <module> \
  #              <A> <B> <C> <D>
  local num="$1" category="$2" question="$3" correct="$4"
  local tip="$5" module="$6"
  local A="$7" B="$8" C="$9" D="${10}"

  print_question "$num" "$TOTAL" "$category" "$question"
  echo -e "  ${BOLD}A)${RESET} $A"
  echo -e "  ${BOLD}B)${RESET} $B"
  echo -e "  ${BOLD}C)${RESET} $C"
  echo -e "  ${BOLD}D)${RESET} $D"
  echo

  local answer
  while true; do
    read -rp "$(echo -e "${YELLOW}Your answer [A/B/C/D]: ${RESET}")" answer
    answer="${answer^^}"   # uppercase
    case "$answer" in
      A|B|C|D) break ;;
      *) echo -e "${RED}Please enter A, B, C, or D.${RESET}" ;;
    esac
  done

  if [[ "$answer" == "$correct" ]]; then
    echo -e "\n${GREEN}${BOLD}✔  Correct!${RESET}\n"
    (( SCORE++ )) || true
  else
    echo -e "\n${RED}${BOLD}✘  Incorrect.${RESET} The correct answer is ${BOLD}${correct}${RESET}."
    echo -e "${DIM}💡 Tip: ${tip}${RESET}\n"
    WRONG_MODULES["$module"]=1
  fi

  read -rp "$(echo -e "${DIM}Press Enter to continue...${RESET}")"
  clear
}

# ── Questions ──────────────────────────────────────────────────────────────────

run_quiz() {
  print_header
  echo -e "This quiz covers 10 key GitHub Copilot topics."
  echo -e "You will answer ${BOLD}${TOTAL} multiple-choice questions${RESET}."
  echo -e "At the end you'll receive a score and personalised study recommendations.\n"
  read -rp "$(echo -e "${YELLOW}Press Enter to begin...${RESET}")"
  clear

  # Q1 — Chat Commands
  ask_question 1 "Chat Commands" \
    "Which Copilot Chat slash command generates unit tests for selected code?" \
    "C" \
    "The /tests command asks Copilot to generate unit tests for the highlighted code. See copilot-course/01-chat-commands/." \
    "01-chat-commands" \
    "/doc" \
    "/fix" \
    "/tests" \
    "/new"

  # Q2 — Custom Instructions
  ask_question 2 "Custom Instructions" \
    "Where should you place a repo-level custom instructions file so that GitHub Copilot picks it up automatically?" \
    "B" \
    "The file .github/copilot-instructions.md is automatically loaded for @workspace queries. See copilot-course/02-custom-instructions/." \
    "02-custom-instructions" \
    "COPILOT.md at the repo root" \
    ".github/copilot-instructions.md" \
    ".vscode/instructions.md" \
    "docs/copilot.md"

  # Q3 — Extensions
  ask_question 3 "Extensions" \
    "How do you invoke a GitHub Copilot Extension called 'docker' in Copilot Chat?" \
    "A" \
    "Extensions are addressed with the @ prefix, e.g. @docker explain this Dockerfile. See copilot-course/03-extensions/." \
    "03-extensions" \
    "@docker explain this Dockerfile" \
    "/docker explain this Dockerfile" \
    "#docker explain this Dockerfile" \
    "!docker explain this Dockerfile"

  # Q4 — Agent Mode
  ask_question 4 "Agent Mode" \
    "Which file customises the environment that the GitHub Copilot coding agent runs in (e.g., pre-installing tools)?" \
    "D" \
    "copilot-setup-steps.yml in the .github/ directory lets you pre-install tools and configure the sandbox. See copilot-course/04-agent-mode/." \
    "04-agent-mode" \
    ".copilot/environment.yml" \
    ".github/workflows/agent.yml" \
    ".devcontainer/devcontainer.json" \
    ".github/copilot-setup-steps.yml"

  # Q5 — MCP
  ask_question 5 "MCP" \
    "Where do you define MCP server connections for GitHub Copilot in VS Code?" \
    "B" \
    "MCP servers can be configured in .vscode/mcp.json or in VS Code settings under the 'mcp' key. See copilot-course/05-mcp/." \
    "05-mcp" \
    ".github/mcp-servers.json" \
    ".vscode/mcp.json" \
    "~/.copilot/mcp.json" \
    "COPILOT_MCP.yaml"

  # Q6 — Actions Integration
  ask_question 6 "Actions Integration" \
    "When using Copilot to generate a GitHub Actions workflow, which chat participant gives the most relevant context about your repository structure?" \
    "C" \
    "@workspace gives Copilot access to your full repo, making it ideal for generating context-aware workflows. See copilot-course/06-actions-integration/." \
    "06-actions-integration" \
    "@terminal" \
    "@vscode" \
    "@workspace" \
    "@github"

  # Q7 — Workspace
  ask_question 7 "Copilot Workspace" \
    "Copilot Workspace is best described as:" \
    "A" \
    "Copilot Workspace is a cloud-based environment where you describe a task, Copilot makes a plan, and then opens a PR with the changes. See copilot-course/07-workspace/." \
    "07-workspace" \
    "A cloud-based task-to-PR flow where Copilot plans and implements changes" \
    "A VS Code theme optimised for Copilot users" \
    "A GitHub repository template with Copilot pre-configured" \
    "A dashboard showing all your Copilot usage statistics"

  # Q8 — Version Control
  ask_question 8 "Version Control" \
    "Where in VS Code do you trigger Copilot to auto-generate a commit message?" \
    "B" \
    "In the Source Control panel, click the sparkle/magic wand icon next to the commit message box to let Copilot suggest a message. See copilot-course/08-version-control/." \
    "08-version-control" \
    "Terminal → Run Task → Copilot Commit" \
    "Source Control panel → sparkle icon next to commit message box" \
    "Command Palette → Copilot: Write Commit" \
    "Git lens sidebar → AI commit"

  # Q9 — Advanced Features
  ask_question 9 "Advanced Features" \
    "Which GitHub Copilot model is best suited for complex, multi-step reasoning tasks that benefit from a 'thinking' phase?" \
    "D" \
    "The o3-mini (and o1) models are OpenAI's reasoning models that perform extended internal reasoning before responding — analogous to Claude's extended thinking. See copilot-course/09-advanced-features/." \
    "09-advanced-features" \
    "GPT-4.1" \
    "Gemini 1.5 Pro" \
    "Claude 3.5 Sonnet" \
    "o3-mini"

  # Q10 — CLI
  ask_question 10 "CLI" \
    "Which gh copilot subcommand explains what a given shell command does?" \
    "A" \
    "'gh copilot explain' takes a shell command string and returns a plain-English explanation. See copilot-course/10-cli/." \
    "10-cli" \
    "gh copilot explain" \
    "gh copilot describe" \
    "gh copilot help" \
    "gh copilot show"
}

# ── Results ────────────────────────────────────────────────────────────────────

show_results() {
  print_header
  local pct=$(( SCORE * 100 / TOTAL ))

  echo -e "${BOLD}═══════════════════════ Quiz Complete ═══════════════════════${RESET}\n"
  echo -e "  Score: ${BOLD}${SCORE} / ${TOTAL}${RESET}  (${pct}%)\n"

  if (( pct >= 90 )); then
    echo -e "  ${GREEN}${BOLD}🎉 Excellent!${RESET} You have a strong grasp of GitHub Copilot."
  elif (( pct >= 70 )); then
    echo -e "  ${YELLOW}${BOLD}👍 Good work!${RESET} A few topics to brush up on."
  elif (( pct >= 50 )); then
    echo -e "  ${YELLOW}${BOLD}📚 Keep studying!${RESET} Review the modules listed below."
  else
    echo -e "  ${RED}${BOLD}🔁 Start from the beginning${RESET} — work through the course sequentially."
  fi

  echo

  if (( ${#WRONG_MODULES[@]} > 0 )); then
    echo -e "${BOLD}Modules to revisit:${RESET}"
    for mod in "${!WRONG_MODULES[@]}"; do
      echo -e "  ${RED}▸${RESET} copilot-course/${mod}/"
    done
    echo
  fi

  echo -e "${DIM}Course landing page: copilot-course/README.md${RESET}"
  echo -e "${DIM}Transition guide:    TRANSITION_GUIDE.md${RESET}"
  echo
}

# ── Entry point ────────────────────────────────────────────────────────────────
main() {
  run_quiz
  show_results
}

main "$@"
