# Stage: Defining
function fg () {
    echo -n "${2};38;5;${1:5}"
    # For bg one should use 48 instead of 38
}

# Stage: Recolor
function () {
    ZSH_HIGHLIGHT_STYLES[arg0]="fg=${COLOR_OBJ:5}"
    ZSH_HIGHLIGHT_STYLES[precommand]="fg=${COLOR_OBJ:5},underline"
    ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=${COLOR_ERR:5},bold"
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=${COLOR_STR:5}"
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=${COLOR_STR:5}"
}

function () {
    local MOD_BOLD="1"

    local C_DIR="di=$(fg $COLOR_NS $MOD_BOLD)"
    local C_EXE="ex=$(fg $COLOR_OBJ)"
    local C_LN="ln=$(fg $COLOR_HINT)"
    local C_BLK="bd=$(fg $COLOR_RAW)"
    local C_MP4="*.mp4=$(fg $COLOR_SEARCH_ACTIVE)"
    LS_COLORS="$C_DIR:$C_EXE:$C_LN:$C_BLK:$C_MP4"

    local C_PERM_EXE_USR_FILE="ux=$(fg $COLOR_OBJ)"
    local C_PERM_EXE_USR_FT="ue=$(fg $COLOR_OBJ)"
    local C_PERM_EXE_GRP="gx=$(fg $COLOR_OBJ)"
    local C_PERM_EXE_OTHER="tx=$(fg $COLOR_OBJ)"
    local C_PERM_EXE="$C_PERM_EXE_USR_FT:$C_PERM_EXE_USR_FILE:$C_PERM_EXE_GRP:$C_PERM_EXE_OTHER"

    local C_PERM_READ_USR_FT="ur=$(fg $COLOR_STR)"
    local C_PERM_READ_GRP="gr=$(fg $COLOR_STR)"
    local C_PERM_READ_OTHER="tr=$(fg $COLOR_STR)"
    local C_PERM_READ="$C_PERM_READ_USR_FT:$C_PERM_READ_USR_FILE:$C_PERM_READ_GRP:$C_PERM_READ_OTHER"

    local C_PERM_WRITE_USR_FT="uw=$(fg $COLOR_OP)"
    local C_PERM_WRITE_GRP="gw=$(fg $COLOR_OP)"
    local C_PERM_WRITE_OTHER="tw=$(fg $COLOR_OP)"
    local C_PERM_WRITE="$C_PERM_WRITE_USR_FT:$C_PERM_WRITE_USR_FILE:$C_PERM_WRITE_GRP:$C_PERM_WRITE_OTHER"

    local C_PERM="$C_PERM_EXE:$C_PERM_READ:$C_PERM_WRITE"

    local C_USR="uu=$(fg $COLOR_KEY)"
    local C_TS="da=$(fg $COLOR_HINT)"
    EXA_COLORS="$C_PERM:$C_USR:$C_TS"
}

export LS_COLORS
export EXA_COLORS

# Stage: Cleaning
unfunction fg
