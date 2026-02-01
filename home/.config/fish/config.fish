if status is-interactive
end

set -g fish_greeting ""
set -g ALTERNATE_EDITOR "zeditor"
set -g EDITOR "emacsclient -nw"
set -g VISUAL "emacsclient -cn"

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

zoxide init fish | source

source (starship init fish --print-full-init | psub)

bind alt-backspace 'backward-kill-word'

alias ls="eza --almost-all --icons always --sort changed --group-directories-first"
alias ll="eza --long --almost-all --icons always --sort changed --dereference --group-directories-first --mounts --git-repos-no-status --time-style long-iso"
alias lt="eza --tree --icons always --sort changed --group-directories-first --hyperlink --level"
alias grep="grep --color=auto"
abbr -a pip "uv pip"
abbr -a venv "source ~/.venv/bin/activate.fish"
abbr -a b "batcat"
abbr -a cd "z"
abbr -a e 'emacsclient --socket "emacs" -cn'
abbr -a et 'emacsclient --socket "emacs" -ct'
abbr -a gpg "gpg2"
abbr -a rustscan "rustscan --ulimit 5000"
abbr -a pwncollege "ssh hacker@pwn.college"
abbr -a masscan "sudo masscan"
