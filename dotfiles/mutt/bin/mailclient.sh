#!/bin/sh

command -v tmux >/dev/null 2>&1 || return 1

if tmux has-session -t "mutt" 2>/dev/null; then
  #[[ $- != *i* ]] && return

  #urxvt -e bash -c "tmux attach -d -t ${name}"
  tmux attach -d -t "mutt" \; \
       split-window -l 2 'offlineimap -o 2>&1 | grep --color=always "Copy message" && exit' \; \
       last-pane
else
  #urxvt -e bash -c "tmux new-session -s \"${name}\" \"${file_path}\" \; set-option status \; set set-titles-string \"${name} (tmux@${HOST})\""
  tmux -2 \
       new-session -s "mutt" "command mutt" \; \
       set-option status \; \
       set set-titles-string "mutt@tmux" \; \
       split-window -l 2 'echo "sync..."; offlineimap -o 2>&1 | grep --color=always "Copy message" && exit' \; \
       last-pane \;
fi

