# generated from colcon_fish/shell/template/prefix.fish.em

# This script extends the environment with all packages contained in this
# prefix path.

# a fish script is able to determine its own path if necessary
if test -z "$COLCON_CURRENT_PREFIX"
  set -l script_path (status -f)
  set -gx _colcon_prefix_fish_COLCON_CURRENT_PREFIX (dirname $script_path)
else
  set -gx _colcon_prefix_fish_COLCON_CURRENT_PREFIX $COLCON_CURRENT_PREFIX
end

# function to convert array-like strings into arrays
function _colcon_prefix_fish_convert_to_array
  set -l _listname $argv[1]
  eval "set -g $argv[1] \$$_listname"
end

# function to prepend a value to a variable
# which uses colons as separators
# duplicates as well as trailing separators are avoided
# first argument: the name of the result variable
# second argument: the value to be prepended
function _colcon_prefix_fish_prepend_unique_value
  # arguments
  set -l _listname $argv[1]
  set -l _value $argv[2]

  # get values from variable
  eval set -l _values \$$_listname
  # start with the new value
  set -l _all_values $_value
  set -l _contained_value ""
  # iterate over existing values in the variable
  for _item in $_values
    # ignore empty strings
    if test -z $_item
      continue
    end
    # ignore duplicates of _value
    if test $_item = $_value
      set _contained_value 1
      continue
    end
    # keep non-duplicate values
    set _all_values $_all_values:$_item
  end
  if test -z "$_contained_value"
    if test -n "$COLCON_TRACE"
      if test "$_all_values" = "$_value"
        echo "set -gx $_listname $_value"
      else
        echo "set -gx $_listname $_value:\$$_listname"
      end
    end
  end

  # export the updated variable
  eval set -gx $_listname (string split ":" $_all_values)
end

# add this prefix to the COLCON_PREFIX_PATH
_colcon_prefix_fish_prepend_unique_value COLCON_PREFIX_PATH "$_colcon_prefix_fish_COLCON_CURRENT_PREFIX"
functions -e _colcon_prefix_fish_prepend_unique_value
functions -e _colcon_prefix_fish_convert_to_array

# check environment variable for custom Python executable
if test -n "$COLCON_PYTHON_EXECUTABLE"
  if test ! -f "$COLCON_PYTHON_EXECUTABLE"
    echo "error: COLCON_PYTHON_EXECUTABLE '$COLCON_PYTHON_EXECUTABLE' doesn't exist"
    return 1
  end
  set -l _colcon_python_executable $COLCON_PYTHON_EXECUTABLE
else
  # try the Python executable known at configure time
  set -l _colcon_python_executable "@(python_executable)"
  # if it doesn't exist try a fall back
  if test ! -f "$_colcon_python_executable"
    if ! /usr/bin/env python3 --version > /dev/null 2> /dev/null
      echo "error: unable to find python3 executable"
      return 1
    end
    set _colcon_python_executable (/usr/bin/env python3 -c "import sys; print(sys.executable)")
  end
end

# function to source another script with conditional trace output
# first argument: the path of the script
function _colcon_prefix_fish_source_script
  if test -f $argv[1]
    if test -n "$COLCON_TRACE"
      echo "# source \"$argv[1]\""
    end
    source $argv[1]
  else
    echo "not found: \"$argv[1]\"" 1>&2
  end
end

# get all commands in topological order
set -l _colcon_ordered_commands (@
$_colcon_python_executable "$_colcon_prefix_fish_COLCON_CURRENT_PREFIX/_local_setup_util_sh.py" fish fish@
@[if merge_install]@
 --merged-install@
@[end if]@
)
set -e _colcon_python_executable
if test -n "$COLCON_TRACE"
  echo "(functions _colcon_prefix_fish_source_script)"
  echo "# Execute generated script:"
  echo "# <<<"
  echo $_colcon_ordered_commands
  echo "# >>>"
  echo "functions -e _colcon_prefix_fish_source_script"
end
eval $_colcon_ordered_commands
set -e _colcon_ordered_commands

functions -e _colcon_prefix_fish_source_script

set -e _colcon_prefix_fish_COLCON_CURRENT_PREFIX
