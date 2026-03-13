#!/usr/bin/env bash
set -euo pipefail

# Test that shell configs source cleanly without errors

PASS=0
FAIL=0

pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  FAIL: $1"; }

echo "Shell configuration tests"
echo "========================="

# Test profile sources without error
if bash -n ~/dotfiles/shell/profile 2>/dev/null; then
    pass "shell/profile parses cleanly"
else
    fail "shell/profile has syntax errors"
fi

# Test zshrc sources without error
if zsh -n ~/dotfiles/shell/zsh/zshrc 2>/dev/null; then
    pass "shell/zsh/zshrc parses cleanly"
else
    fail "shell/zsh/zshrc has syntax errors"
fi

# Test zprofile sources without error
if zsh -n ~/dotfiles/shell/zsh/zprofile 2>/dev/null; then
    pass "shell/zsh/zprofile parses cleanly"
else
    fail "shell/zsh/zprofile has syntax errors"
fi

# Test zshenv sources without error
if zsh -n ~/dotfiles/shell/zsh/zshenv 2>/dev/null; then
    pass "shell/zsh/zshenv parses cleanly"
else
    fail "shell/zsh/zshenv has syntax errors"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]] || exit 1
