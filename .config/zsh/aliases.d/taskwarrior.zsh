function _t_memo_parse {
    local prefix='Created task '
    local suffix='.'
    local _temp="${1#$prefix}"
    echo ${_temp%$suffix}
}

function _t_memo_store {
    _t_memo_prev=$1
}

function _t_memo_reset {
    _t_memo_prev=""
}

function _t_memo_read {
    echo $_t_memo_prev
}

function _t_memo_exists {
    ! [[ -z $_t_memo_prev ]]
}

function _is_num {
    [[ $1 =~ '^[0-9]+$' ]]
}

# Task add
function ta {
    _t_memo_reset
    local _output=$(task add $@)
    echo $_output
    _t_id=$(_t_memo_parse $_output)
    if ! _is_num $_t_id; then
        echo "Failed to parse task id"
        return 1
    fi
    _t_memo_store $_t_id
}

# Wrapper for reusing previous task id, if possible
function _t_memo_subcommand {
    if _is_num $2; then
        task $@
        if [[ $? != 0 ]]; then
            return 1
        fi
        _t_memo_store $2
    else
        if _t_memo_exists; then
            task $1 $(_t_memo_read) ${@:2}
        else
            echo "Previous task not found"
            return 1
        fi
    fi
}

function _t_memo_subcommand_with_reset {
    _t_memo_subcommand $@
    if [[ $? != 0 ]]; then
        return 1
    fi
    _t_memo_reset
}


function tan { _t_memo_subcommand annotate $@ }
function tm { _t_memo_subcommand mod $@ }
function ti { _t_memo_subcommand info $@ }
function te { _t_memo_subcommand edit $@ }
function tdel { _t_memo_subcommand_with_reset delete $@ }
function td { _t_memo_subcommand_with_reset done $@ }
function ts { _t_memo_subcommand start $@ }
function tp { _t_memo_subcommand stop $@ }

alias tl="task list"

function to {
    # Double call because of freaking pipe subshells
    ti $1 > /dev/null
    if [[ $? != 0 ]]; then
        return 1
    fi
    ti $1 | grep -o 'https.*$' | head -n1 | nc -N localhost 44444
}

# Completions
_tan () {
    local -a words=( task annotate $words[1,-1] )
    local -i CURRENT=$(( CURRENT + 1 ))
    _normal
}
compdef _tan tan

_tm () {
    local -a words=( task mod $words[1,-1] )
    local -i CURRENT=$(( CURRENT + 1 ))
    _normal
}
compdef _tm tm

_ti () {
    local -a words=( task info $words[1,-1] )
    local -i CURRENT=$(( CURRENT + 1 ))
    _normal
}
compdef _ti ti

_te () {
    local -a words=( task edit $words[1,-1] )
    local -i CURRENT=$(( CURRENT + 1 ))
    _normal
}
compdef _te te

_tdel () {
    local -a words=( task delete $words[1,-1] )
    local -i CURRENT=$(( CURRENT + 1 ))
    _normal
}
compdef _tdel tdel

_td () {
    local -a words=( task done $words[1,-1] )
    local -i CURRENT=$(( CURRENT + 1 ))
    _normal
}
compdef _td td
