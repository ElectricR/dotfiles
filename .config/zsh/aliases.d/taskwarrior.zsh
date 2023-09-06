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
    _t_id=$(_t_memo_parse $_output)
    if _is_num $_t_id; then
        _t_memo_store $_t_id
        echo $_output
        return 0
    fi
    return 1
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

function tan { _t_memo_subcommand annotate $@ }
function tm { _t_memo_subcommand mod $@ }
function ti { _t_memo_subcommand info $@ }
function te { _t_memo_subcommand edit $@ }
function tdel {
    _t_memo_subcommand delete $@
    if [[ $? != 0 ]]; then
        return 1
    fi
    _t_memo_reset
}

# Helper for learning aliases
function t() {
    if [[ $1 == "info" ]] || [[ $1 == "annotate" ]] || [[ $1 == "delete" ]] || [[ $1 == "edit" ]]; then
        echo 'Use alias'
        return 1
    fi
    task $@
}

alias tl="task list"
alias td="task done"
