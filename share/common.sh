# Code common to all unburden-home-dir /etc/X11/Xsession.d/ files.

UNBURDEN_BASENAME=${UNBURDEN_BASENAME:-unburden-home-dir}

if [ -e /etc/default/"${UNBURDEN_BASENAME}" ]; then
    . /etc/default/"${UNBURDEN_BASENAME}"
fi

if [ -e /etc/"${UNBURDEN_BASENAME}" ]; then
    . /etc/"${UNBURDEN_BASENAME}"
fi

if [ -e "${HOME}/.${UNBURDEN_BASENAME}" ]; then
    . "${HOME}/.${UNBURDEN_BASENAME}"
fi

if [ -e "${XDG_CONFIG_HOME:-$HOME/.config}/${UNBURDEN_BASENAME}/config" ]; then
    . "${XDG_CONFIG_HOME:-$HOME/.config}/${UNBURDEN_BASENAME}/config"
fi

unburden_it() {
   [ "${UNBURDEN_HOME}" = "true" ] || [ "${UNBURDEN_HOME}" = "yes" ]
}

UNBURDEN_HOME_DIR_COMMON_SOURCED=yes
