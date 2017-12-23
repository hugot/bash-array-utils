#!/bin/bash
##
# Utility functions for common array operations.
# To prevent circular references, none of the functions allow
# usage on an array named "array", and some won't allow the usage
# of an array by the name "oth_array" for a second arrayname that is passed.
# Functions that do variable assignment won't allow the usage of a variable
# by the name "variable".
##

##
# Check if an array is eligible to use the functions on.
# return values:
# 1: Array variable has not been set.
# 2: The array variable is named "array"
#
# $1: array_name
function Array_isValid() {
  if ! declare -p "$1" &>>/dev/null; then
    echo 'Array: Array variable needs to be set.' >&2
    return 1
  elif [[ $1 == array ]]; then
    echo 'Array: Array variable can not be named "array"' >&2
    return 2
  fi
}

##
# Check if a variable can be assigned.
# return values:
# 3: The variable has not yet been declared
# 5: The variable is named "variable"
#
# $1 variable_name
function Array_varIsValid() {
  if ! [[ -v $1 ]]; then
    echo 'Array: Variable needs to be declared before assigning to it.' >&2
    return 3
  elif [[ $1 == variable ]]; then
    echo 'Array: Variable cannot be named "variable"' &
    2
    return 5
  fi
}

##
# pop an array
# return values:
# 4: array size is 0
# other: see Array_isValid
#
# $1: array_name
function Array_pop() {
  Array_isValid "$1" || return $?

  declare -n array="$1"
  [[ ${#array[@]} -gt 0 ]] || return 4

  unset 'array[-1]'
}

##
# Pop an array and assign the popped value to a variable
# return values:
# 4: array size is 0
# other: see Array_isValid and Array_varIsValid
#
# $1: array_name
# $2: variable_name
function Array_popToVar() {
  Array_isValid "$1" || return $?
  Array_varIsValid "$2" || return $?

  declare -n array="$1" variable="$2"
  [[ ${#array[@]} -gt 0 ]] || return 4
  variable="${array[-1]}"

  Array_pop "$1"
}

##
# Shift an array.
# $1: array_name
function Array_shift() {
  Array_isValid "$1" || return $?

  declare -n array="$1"
  declare -i shift_amount="$2"
  ((shift_amount = shift_amount == 0 ? ++shift_amount : shift_amount))
  [[ ${#array[@]} -gt 0 ]] || return 4
  set -- "${array[@]}"
  shift $shift_amount

  array=("$@")
}

##
# Shift an array and assign the shifted value to a variable
# $1: array_name
# $2: variable_name
function Array_shiftToVar() {
  Array_isValid "$1" || return $?
  Array_varIsValid "$2" || return $?

  # TODO: Add shifting to multiple variables
  declare -n array="$1" variable="$2"
  [[ ${#array[@]} -gt 0 ]] || return 4
  variable="${array[0]}"

  Array_shift "$1"
}

##
# Push a value to an array
# $1: array_name
# $2: value
function Array_push() {
  Array_isValid "$1" || return $?
  declare -n array="$1"
  shift

  array=("${array[@]}" "$@")
}

##
# Unshift a value to an array
# $1: array_name
# $*: values
function Array_unshift() {
  Array_isValid "$1" || return $?
  declare -n array="$1"
  shift

  array=("$@" "${array[@]}")
}

##
# Map through an array with a callback and assign the yielded values
# to the defined array.
# $1: array_name
# $2: array_to_be_assigned_to_name (may not be "oth_array")
# $3: callback_name
function Array_map() {
  if ! declare -F "$3" &>>/dev/null; then
    echo 'Array: Error, $3 for Array_map must be a function name'
    return 6
  fi
  Array_isValid "$1" || return $?
  Array_isValid "$2" || return $?

  declare -n array="$1"
  declare -a oth_array=()
  declare func="$3" in_Array_map="true"

  for item in "${array[@]}"; do
    "$func" "$item"
  done

  declare -n array="$2"

  array=("${oth_array[@]}")
}

##
# Strictly for use in Array_map callbacks.
# $1: Variable that should be added to the new array
function Array_yield() {
  $in_Array_map && oth_array=("${oth_array[@]}" "$@")
}

##
# Check if an array has a certain value stored in it.
# TODO: make this work with non-string values as well.
# $1: arrayname
# $2: value
function Array_hasValue() {
  if ! Array_isValid "$1"; then
    echo "$(caller): $1 is not a valid array."
    exit 1
  fi

  declare -n array="$1"

  for item in "${array[@]}"; do
    [[ "$2" == "$item" ]] && return 0
  done
  return 1
}