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


function git_recent --description "Recent commit graph"
    set -l since "30 days ago"

    if test (count $argv) -gt 0
        set since $argv[1]
    end

    git log \
        --graph \
        --decorate \
        --oneline \
        --all \
        --since="$since"
end


function git_stale --description "Show branches sorted by last commit date"
    git for-each-ref \
        --sort=committerdate \
        --format='%(committerdate:short) %(refname:short)' \
        refs/heads
end


function git_merge_rate --description "Show merge commits"
    set -l since "1 year ago"

    if test (count $argv) -gt 0
        set since $argv[1]
    end

    git log \
        --merges \
        --since="$since" \
        --oneline
end


function git_release_tags --description "List release tags by date"
    git for-each-ref \
        --sort=-creatordate \
        refs/tags \
        --format='%(creatordate:short) %(refname:short)'
end


function git_biggest_files --description "Largest tracked files"
    set -l count 20

    if test (count $argv) -gt 0
        set count $argv[1]
    end

    git ls-tree -r -l HEAD \
        | sort -k4 -n \
        | tail -n $count
end


function git_hot_authors --description "Most active recent contributors"
    set -l since "90 days ago"

    if test (count $argv) -gt 0
        set since $argv[1]
    end

    git shortlog -sn \
        --no-merges \
        --since="$since"
end


function git_wip --description "Find WIP-style commits"
    git log --oneline \
        | grep -iE 'wip|temp|oops|fixup|asdf|test'
end


function git_todos --description "Find TODO/FIXME/HACK markers"
    git grep -nE 'TODO|FIXME|XXX|HACK'
end


function git_orphans --description "Merged branches"
    git branch --merged
end


function git_unmerged --description "Branches not yet merged"
    git branch --no-merged
end


function git_conflicts --description "Find committed merge conflict markers"
    git grep -nE '<<<<<<<|=======|>>>>>>>'
end


function git_extensions --description "File extension breakdown"
    git ls-files \
        | sed 's/.*\.//' \
        | sort \
        | uniq -c \
        | sort -nr
end


function git_weekday --description "Commit frequency by weekday"
    git log \
        --date=format:'%A' \
        --format='%ad' \
        | sort \
        | uniq -c
end


function git_hourly --description "Commit frequency by hour"
    git log \
        --date=format:'%H' \
        --format='%ad' \
        | sort \
        | uniq -c
end


function git_health --description "Comprehensive Git repository health dashboard"

    set_color --bold cyan
    echo "==========================================="
    echo " Git Repository Health"
    echo "==========================================="
    set_color normal

    echo
    set_color yellow
    echo "Repository"
    set_color normal

    echo "Branch:      "(git branch --show-current)
    echo "Last Commit: "(git log -1 --format="%cr by %an")
    echo "Tags:        "(count (git tag))
    echo "Branches:    "(count (git branch))

    echo

    set_color cyan
    echo "=== Top Churn ==="
    set_color normal
    git_churn "1 year ago" 10

    echo
    set_color cyan
    echo "=== Contributors ==="
    set_color normal
    git_authors

    echo
    set_color cyan
    echo "=== Active Contributors (90d) ==="
    set_color normal
    git_hot_authors

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

    echo
    set_color cyan
    echo "=== Stale Branches ==="
    set_color normal
    git_stale | head -10

    echo
    set_color cyan
    echo "=== Unmerged Branches ==="
    set_color normal
    git_unmerged

    echo
    set_color cyan
    echo "=== Largest Files ==="
    set_color normal
    git_biggest_files 10

    echo
    set_color cyan
    echo "=== TODO/FIXME ==="
    set_color normal
    git_todos

    echo
    set_color cyan
    echo "=== Merge Conflict Markers ==="
    set_color normal
    git_conflicts

    echo
    set_color cyan
    echo "=== WIP Commits ==="
    set_color normal
    git_wip

    echo
    set_color cyan
    echo "=== Languages ==="
    set_color normal
    git_extensions | head -10

    echo
    set_color cyan
    echo "=== Releases ==="
    set_color normal
    git_release_tags | head -10

    echo
    set_color cyan
    echo "=== Commit Weekday Distribution ==="
    set_color normal
    git_weekday

    echo
    set_color cyan
    echo "=== Commit Hour Distribution ==="
    set_color normal
    git_hourly
end
