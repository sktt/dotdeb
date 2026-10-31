#!/bin/bash
cat <<'EOF'
 tmux cheat sheet          prefix = C-Space

 SESSIONS
  $          rename session            (default)
  s          choose session            (default)
  d          detach                    (default)
  C-s        save all sessions/windows/panes (resurrect)
  C-r        restore saved sessions/windows/panes (resurrect)
             (auto-restores on tmux start, auto-saves every 15min)

 WINDOWS
  c          new window
  n          rename window
  W          move window to session (pick from list, Enter)
  < / >      swap window left / right
  C-M-h/l    prev/next window          (no prefix)

 PANES
  " / %      split vertical / horizontal
  N          break pane into its own new session (prompts for name)
  C-h/j/k/l  resize pane (repeatable)
  , / .      move pane left / right
  { / }      swap pane up / down
  C-M-j/k    switch client prev/next   (no prefix)

 LAYOUTS
  m          main-vertical
  M          main-horizontal
  t          tiled
  h          even-horizontal
  v          even-vertical

 COPY MODE (vi keys)
  v          begin selection
  y          copy selection -> system clipboard

 HELP
  H          this cheat sheet
  ?          full default tmux key list
EOF
printf '\n press q to close '
read -n 1 -s
