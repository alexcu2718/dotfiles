if status is-interactive
   set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
    carapace _carapace | source
 # Commands to run in interactive sessions can go here
	starship init fish | source

       carapace --list | awk '{print $1}' | xargs -I{} touch ~/.config/fish/completions/{}.fish #

end
