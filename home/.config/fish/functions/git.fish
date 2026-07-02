function git_health --description "Quick Git repository health report"
    echo
    set_color cyan
    echo "=== Top Churn ==="
    set_color normal
    git_churn

    echo
    set_color cyan
    echo "=== Contributors ==="
    set_color normal
    git_authors

    echo
    set_color cyan
    echo "=== Bug Hotspots ==="
    set_color normal
    git_bug_hotspots

    echo
    set_color cyan
    echo "=== Monthly Activity ==="
    set_color normal
    git_velocity

    echo
    set_color cyan
    echo "=== Firefighting ==="
    set_color normal
    git_firefighting
end

function git_activity --description "Show monthly commit activity for Git repositories"
    set -l root .

    if test (count $argv) -gt 0
        set root $argv[1]
    end

    for gitdir in (find $root -type d -name .git)
        echo $gitdir
        git -C $gitdir log --format="%ad" --date=format:"%Y-%m" 2>/dev/null \
            | sort \
            | uniq -c
        echo
    end | less
end

function git_firefighting --description "Show hotfixes, reverts, and emergency commits"
    set -l since "1 year ago"

    if test (count $argv) -gt 0
        set since $argv[1]
    end

    git log --oneline --since="$since" \
        | grep -iE 'revert|hotfix|emergency|rollback'
end

function git_velocity --description "Show monthly commit activity"
    git log \
        --format="%ad" \
        --date=format:"%Y-%m" \
        | sort \
        | uniq -c
end

function git_bug_hotspots --description "Show files most frequently mentioned in bug-fix commits"
    set -l since

    if test (count $argv) -gt 0
        set since --since="$argv[1]"
    end

    git log -i -E \
        --grep="fix|bug|broken" \
        $since \
        --name-only \
        --format='' \
        | sort \
        | uniq -c \
        | sort -nr \
        | head -20
end

function git_authors --description "Rank contributors by commit count"
    if test (count $argv) -gt 0
        git shortlog -sn --no-merges --since="$argv[1]"
    else
        git shortlog -sn --no-merges
    end
end

function git_churn --description "Show the most frequently modified files"
    set -l since "1 year ago"
    set -l count 20

    if test (count $argv) -ge 1
        set since $argv[1]
    end

    if test (count $argv) -ge 2
        set count $argv[2]
    end

    git log --format=format: --name-only --since="$since" \
        | sort \
        | uniq -c \
        | sort -nr \
        | head -n $count
end
