# fzf completion and key bindings. Install paths differ per platform.
case "$(uname -s)" in
  Darwin)
    # Homebrew's fzf ships these under $(brew --prefix)/opt/fzf/shell
    _fzf_shell="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fzf/shell"
    ;;
  *)
    # Debian/Ubuntu ship them as examples alongside the docs
    _fzf_shell="/usr/share/doc/fzf/examples"
    ;;
esac

[[ $- == *i* ]] && [ -r "$_fzf_shell/completion.zsh" ] && \
  source "$_fzf_shell/completion.zsh" 2> /dev/null
[ -r "$_fzf_shell/key-bindings.zsh" ] && source "$_fzf_shell/key-bindings.zsh"

unset _fzf_shell
