# generated from colcon_fish/shell/template/package.fish.em

# This script extends the environment for this package.

# a fish script is able to determine its own path if necessary
if test -z "$COLCON_CURRENT_PREFIX"
  # the prefix is two levels up from the package specific share directory
  set -l current_file_path (status filename)
  set -gx _colcon_package_fish_COLCON_CURRENT_PREFIX (cd (dirname $current_file_path)"/../.." && pwd)
else
  set -gx _colcon_package_fish_COLCON_CURRENT_PREFIX $COLCON_CURRENT_PREFIX
end

# function to source another script with conditional trace output
# first argument: the path of the script
# additional arguments: arguments to the script
function _colcon_package_fish_source_script
  if test -f "$argv[1]"
    if test -n "$COLCON_TRACE"
      echo "# . \"$argv[1]\""
    end
    . $argv
  else
    echo "not found: \"$argv[1]\"" >&2
  end
end

# source sh script of this package
_colcon_package_fish_source_script "$_colcon_package_fish_COLCON_CURRENT_PREFIX/share/@(pkg_name)/package.sh"
@[if hooks]@

# setting COLCON_CURRENT_PREFIX avoids determining the prefix in the sourced scripts
set -gx COLCON_CURRENT_PREFIX $_colcon_package_fish_COLCON_CURRENT_PREFIX

# source fish hooks
@[  for hook in hooks]@
_colcon_package_fish_source_script "$COLCON_CURRENT_PREFIX/@(hook[0])"@
@[    for hook_arg in hook[1]]@
 @(hook_arg)@
@[    end for]
@[  end for]@

set -e COLCON_CURRENT_PREFIX
@[end if]@

set -e _colcon_package_fish_source_script
set -e _colcon_package_fish_COLCON_CURRENT_PREFIX
