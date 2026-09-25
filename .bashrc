#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='eza --icons'
alias ll='eza -l --icons --git'
alias la='eza -la --icons --git'
alias grep='grep --color=auto'

# Reveals a multi-line block of text ($1, newline-separated) with a
# left-to-right decode wipe: every line's not-yet-revealed characters show
# as noise, and the reveal boundary sweeps across all lines together over
# ~1 second. Used for the whole login banner (ascii name + quote).
_glitch_reveal_block() {
	local content=$1
	local noise='!<>-_\/[]{}=+*^?#$%&~;:.,'
	local -a lines
	local IFS=$'\n'
	lines=($content)
	IFS=$' \t\n'

	local nlines=${#lines[@]}
	local maxlen=0 l
	for l in "${lines[@]}"; do
		[ ${#l} -gt "$maxlen" ] && maxlen=${#l}
	done
	[ "$maxlen" -eq 0 ] && maxlen=1

	local frames=10 i=0 j out ch thresh idx line

	local k=0
	while [ "$k" -lt "$nlines" ]; do printf '\n'; k=$((k + 1)); done

	while [ "$i" -lt "$frames" ]; do
		printf '\033[%dA' "$nlines"
		for line in "${lines[@]}"; do
			out=""
			j=0
			while [ "$j" -lt "${#line}" ]; do
				ch="${line:$j:1}"
				thresh=$(( (j * frames) / maxlen ))
				if [ "$ch" = " " ] || [ "$thresh" -le "$i" ]; then
					out="$out$ch"
				else
					idx=$(( RANDOM % ${#noise} ))
					out="$out${noise:$idx:1}"
				fi
				j=$((j + 1))
			done
			printf '\033[1;34m%s\033[0m\033[K\n' "$out"
		done
		sleep 0.05
		i=$((i + 1))
	done

	printf '\033[%dA' "$nlines"
	for line in "${lines[@]}"; do
		printf '\033[1;34m%s\033[0m\033[K\n' "$line"
	done
}

# Only show the banner when this terminal is the sole window on the current
# bspwm desktop (i.e. a genuinely fresh workspace, not one you're tiling
# into). Deferred via PROMPT_COMMAND until the first prompt so bspwm/the
# terminal have finished mapping/tiling before we check.
_print_hacker_banner() {
	PROMPT_COMMAND=${PROMPT_COMMAND//_print_hacker_banner;/}
	unset -f _print_hacker_banner

	if command -v bspc >/dev/null 2>&1; then
		win_count=$(bspc query -N -n .window -d 2>/dev/null | wc -l)
		[ "$win_count" -gt 1 ] && return
	fi

	command -v figlet >/dev/null 2>&1 || return

	cols=${COLUMNS:-80}
	banner=$(figlet -f big "${HOSTNAME:-x230}" 2>/dev/null)
	needed=$(printf '%s\n' "$banner" | awk '{ if (length > m) m = length } END { print m+0 }')
	if [ "$needed" -eq 0 ] || [ "$cols" -lt "$needed" ]; then
		banner="${HOSTNAME:-x230}"
	fi

	_glitch_reveal_block "${banner}"
}
PROMPT_COMMAND="_print_hacker_banner;${PROMPT_COMMAND}"

PS1='\[\e[1;34m\]┌──(\u@\h)-[\w]\n└─\[\e[1;34m\]λ\[\e[0m\] '

export PATH="$HOME/.local/bin:$PATH"


# Added by Antigravity CLI installer
export PATH="/home/cybernoumena/.local/bin:$PATH"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
