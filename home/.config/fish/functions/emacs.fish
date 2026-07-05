function emacs --wraps='emacsclient -c -a "" -n' --description 'alias emacs emacsclient -c -a "" -n'
    emacsclient -c -a "" -n $argv
end
