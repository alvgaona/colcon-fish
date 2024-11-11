# generated from colcon_fish/shell/template/prefix_chain.fish.em

# This script extends the environment with the environment of other prefix
# paths which were sourced when this file was generated as well as all packages
# contained in this prefix path.

# function to source another script with conditional trace output
# first argument: the path of the script
function _colcon_prefix_chain_fish_source_script
    if test -f "$argv[1]"
        if test -n "$COLCON_TRACE"
            echo "# source $argv[1]"
        end
        source "$argv[1]"
    else
        echo "not found: \"$argv[1]\"" >&2
    end
end
@[if chained_prefix_path]@

# source chained prefixes
@[  for prefix in reversed(chained_prefix_path)]@
# setting COLCON_CURRENT_PREFIX avoids determining the prefix in the sourced script
set -gx COLCON_CURRENT_PREFIX "@(prefix)"
_colcon_prefix_chain_fish_source_script "$COLCON_CURRENT_PREFIX/@(prefix_script_no_ext).fish"
@[  end for]@
@[end if]@

# source this prefix
# setting COLCON_CURRENT_PREFIX avoids determining the prefix in the sourced script
set -gx COLCON_CURRENT_PREFIX (dirname (status -f))
_colcon_prefix_chain_fish_source_script "$COLCON_CURRENT_PREFIX/@(prefix_script_no_ext).fish"

set -e COLCON_CURRENT_PREFIX
functions -e _colcon_prefix_chain_fish_source_script
