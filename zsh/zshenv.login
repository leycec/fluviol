#!/bin/zsh
# ====================[ zshenv.login                       ]====================
#                     [ Time-stamp: "2009-04-18 19:29:24 leycec" ]
#
# --------------------( SYNOPSIS                           )--------------------
# Run before "zprofile", "zshrc", and "zlogin", for login shells. This is the
# first script Zsh calls when starting up.
#
# --------------------( DESCRIPTION                        )--------------------
# This file aggregates all environment variables into one file. Customarily,
# Gentoo disaggregates all environment variables into the "/etc/env.d/" path,
# from which it then dynamically constructs the "/etc/profile.env" file, which
# this file sources. I find that to be a rather clumsy and overly abstracted
# means for defining environment variables, however; I prefer this.

# ....................{ INITIALIZATION                     }....................
echo "zeshy: loading \"${ZSHRC_HOME}/zshenv.login\"..."

# ....................{ DEPENDENCIES                       }....................
# Load environment settings from "profile.env", if that file exists. This is a
# programmatically-generated file created by:
#
# * Under Gentoo, "env-update" from the files in "/etc/env.d/".
# * Under Exherbo, "eclectic env update" from the files in "/etc/env.d/".
[[ -e '/etc/profile.env' ]] && source '/etc/profile.env'

# ....................{ ROOT                               }....................
# Non-empty if the current user is root. Otherwise, empty.
IS_USER_ROOT=$([[ "${EUID}" == "0" || "${USER}" == "root" ]] && echo '1')

# ....................{ PATH                               }....................
# void PATH_append(char *PATHNAME, bool IS_NOT_TESTING_PATH)
#
# Add the passed pathname to this user's "$PATH", if: '
#
# * If "$IS_NOT_TESTING_PATH" is not passed or is passed but is empty, then if
#   that path exists, is readable by this user, and has not already been added.
# * If "$IS_NOT_TESTING_PATH" is passed and is non-empty, then that is
#   sufficient and we perform no path testing. (This should be used sparingly.)
PATH_append() {
    if [[ -z "${1}" ]]; then
        echo 'PATH_append: passed no path to append' 1>&2
        return
    fi
    
    if [[ -n "${2}" || ( -d "${1}" && -r "${1}" ) ]]; then
        if [[ -n "${PATH}" ]]
        then PATH+=":${1}"
        else PATH="${1}"
        fi
    fi
}

# void PATH_append_if_root(char *PATHNAME)
#
# Add the passed pathname to this user's "$PATH", if the above conditions hold
# and if this user is the superuser (i.e., root).
PATH_append_if_root() {
    [[ -n "${IS_USER_ROOT}" ]] && PATH_append "${@}"
}

# Record the prior value of PATH: typically, a user-specific PATH as defined by
# one or several of the dependencies, above.
if [[ -n "${IS_USER_ROOT}" ]]; then
    if [[ -n "${ROOTPATH}" ]]
    then USERPATH="${ROOTPATH}"
    else USERPATH="${PATH}"
    fi
else USERPATH="${PATH}"
fi

# Reset PATH to the empty string now that we've recorded its prior value.
PATH=

# Append all paths onto PATH.
PATH_append         "/usr/lib/colorgcc/bin"
PATH_append_if_root "/usr/local/sbin"
PATH_append         "/usr/local/bin"
PATH_append_if_root "/usr/sbin"
PATH_append         "/usr/bin"
PATH_append_if_root "/sbin"
PATH_append         "/bin"

# Append the prior value of PATH back onto PATH.
PATH+=":${USERPATH}"

# Append a user-specific path "~/bin" onto PATH.
PATH_append         "${HOME}/bin"

#FIXME: Remove, after migrating all non-Zeshy scripts to Zeshy.
PATH_append         "${HOME}/bin/zeshy"

# ....................{ PATHS                              }....................
# Zsh cache path. Make this path if it does not already exist. Note that
# Zsh, itself, is unaware of this path. We find it convenient to centralize
# Zsh caches into this path.
export ZSH_CACHE_HOME="${HOME}/.zsh"

# Directory to which Zsh completions cache themselves.
ZSH_COMPLETION_CACHE_PATH="${ZSH_CACHE_HOME}/zcompcache"

# Filename to which the compinit() function dumps its configuration. 
ZSH_COMPINIT_DUMP_FILE="${ZSH_CACHE_HOME}/zcompdump"

# Read X.Org application defaults from this path.
export XAPPLRESDIR="${HOME}/.X"
export XUSERFILESEARCHPATH="${XAPPLRESDIR}/%N"

# Make above directories, if not already made.
mkdir --parents \
    "${ZSH_CACHE_HOME}" \
    "${ZSH_COMPLETION_CACHE_PATH}" \
    "${XAPPLRESDIR}" \
    "${XUSERFILESEARCHPATH}"

# ....................{ *NIX                               }--------------------
# Enable Unicode support.
export LANG="en_US.utf8"
export LC_ALL="en_US.utf8"

# Select a default command-line editor and pager.
export EDITOR="/usr/bin/vim"
export PAGER="/usr/bin/less"

# Export default grep options. (Note these options are not respected by grep
# binaries; they are specific to our grep aliases, defined elsewhere.)
#
# Do not define "GREP_OPTION"! When defined, all invocations of grep use these
# options. However, most such invocations do not expect grep to emit line
# numbers, colors, or other colorful noise. They expect grep -- plain grep, no
# ornamentation. (Let us avoid breaking the entire system, shall we?)
export GREPC_OPTIONS="-1 --color=always --line-number --no-messages --extended-regexp --with-filename"
export GREPI_OPTIONS="${GREP_OPTIONS} --ignore-case"

# ....................{ SYSTEM                             }--------------------
# Grep the system's total available memory in Kb.
export SYSTEM_RAM_KB=$(cat /proc/meminfo | awk -F '[ ]+' '/^MemTotal/ { print $2 }')

# Mark systems having more than 1GB memory as high-end, and all others as low-
# end. This simple test permits conditional logic based on system quality.
export IS_SYSTEM_HIGH_END=$([[ "${SYSTEM_RAM_KB}" -gt 1000000 ]] && echo 1)

# ....................{ ZSH                                }....................
# Enable an in-memory cache of ZSH history; persist this history to some file.
export HISTSIZE=1024  # maintain this number of lines of history
export SAVEHIST=1024  # ..retain this number of lines of history between logins
export HISTFILE="${ZSHRC_HOME}/history"

# ....................{ NET                                }--------------------
# Enable Firefox's Pango-enabled font antialiasing on high-end machines, but
# disable the same on low-end machines.
export MOZ_DISABLE_PANGO=$([[ -n "${IS_SYSTEM_HIGH_END}" ]] || echo 1)

# Enable SSH over non-anonymous (i.e., non-pserver) CVS.
export CVS_RSH=ssh

# ....................{ TEX                                }--------------------
# Locate user-specific "TeX" trees at this user-specific path. This variable
# defaults to "~/texmf/" in "/etc/texmf/texmf.d/05searchpaths.cnf", which as
# defaults go is rather clumsy. Thus, this. (Environment variables of the same
# name take precedence over "/etc/texmf/web2c/texmf.cnf" variables and also do
# not require updating on change. So, this is an elegant solution. Somewhat.)
#
# User-specific "TeX" trees should have directory structure resembling that of
# system-specific "TeX" trees (e.g., "/usr/share/texmf-dist/") but probably not.
# the overarching "TeX" tree at "/usr/share/texmf/".
#export TEXMFHOME="$HOME/share/texmf"

# Absolute path to your TeX Live installation. Note this is specific to this
# file and thus not exported.
LOCAL_TEXDIR="/usr/share/texlive/2009"
PATH="${LOCAL_TEXDIR}/bin/x86_64-linux:${PATH}"
MANPATH="${LOCAL_TEXDIR}/texmf/doc/man:${MANPATH}"
INFOPATH="${LOCAL_TEXDIR}/texmf/doc/info:${INFOPATH}"

# ....................{ EOF                                }--------------------
# Lastly, export munged paths into our caller's shell environment.
export PATH MANPATH INFOPATH

# --------------------( COPYRIGHT AND LICENSE              )--------------------
# The information below applies to everything in this distribution,
# except where noted.
#              
# Copyleft 2007-2010 by Cecil Curry.
#   
#   http://www.raiazome.com
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
