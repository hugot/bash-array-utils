
source lib/Array.bash

function setup () {
  declare -ga test_array=(item1 item2 item3)
}

teardown () {
  declare -ga test_array=()
}

@test "Array::pop" {
  declare -a expected=(item1 item2)
  Array::pop test_array

  [[ ${expected[@]} == ${test_array[@]} ]]
}

@test "Array::pop empty array" {
  declare -a test_array=()
  run Array::pop test_array

  [[ $status -eq 4 ]]
}

@test "Array::popToVar" {
  declare expected="${test_array[-1]}"
  declare var=''
  echo $expected $var
  Array::popToVar test_array var

  [[ $expected == $var ]]
}

@test "Array::shift" {
  Array::shift test_array
  declare -a expected=(item2 item3)

  [[ ${expected[@]} ==  ${test_array[@]} ]]
}

@test "Array::shiftToVar" {
  declare var='' expected="${test_array[0]}"
  Array::shiftToVar test_array var

  [[ $expected == $var ]]
}

@test "Array::push" {
  declare -a expected=("${test_array[@]}" "item4")
  Array::push test_array "item4"

  [[ ${expected[@]} ==  ${test_array[@]} ]]
}

@test "Array::push multiple values" {
  declare -a expected=("${test_array[@]}" "item4" "item5")
  Array::push test_array "item4" "item5"

  [[ ${expected[@]} ==  ${test_array[@]} ]]
}

@test "Array::unshift" {
  declare -a expected=("item0" "${test_array[@]}")
  Array::unshift test_array "item0"

  [[ ${expected[@]} ==  ${test_array[@]} ]]
}

@test "Array::unshift multiple values" {
  declare -a expected=("item-1" "item0" "${test_array[@]}")
  Array::unshift test_array "item-1" "item0"

  [[ ${expected[@]} ==  ${test_array[@]} ]]
}

@test "Array::yield" {
  declare -a oth_array=() expected=(item1)
  declare in_Array_map="true"
  Array::yield item1

  [[ ${expected[@]} ==  ${oth_array[@]} ]]
}

@test "Array::yield not in Array::map" {
  declare -a oth_array=() expected=()
  declare in_Array_map="false"
  run Array::yield item1

  [[ ${expected[@]} ==  ${oth_array[@]} ]]
}

@test "Array::map" {
  declare -a new_array=()
  declare -a expected=(item1 item3)
  function example {
    case $1 in item1|item3)
        Array::yield "$1"
    esac
  }
  Array::map test_array new_array example
  unset -f example

  [[ ${expected[@]} ==  ${new_array[@]} ]]
}

@test "Array::map no callback" {
  run Array::map randomFuncName

  [[ $status -eq 6 ]]
}

@test "Array::hasValue true" {
  run Array::hasValue test_array "item1"

  [[ $status -eq 0 ]]
}

@test "Array::hasValue false" {
  run Array::hasValue test_array "randomvalue"

  [[ $status -gt 0 ]]
}

@test "Array::hasValue (integer) true" {
  declare int_array=(1 2 3 4)
  run Array::hasValue int_array 1

  [[ $status -eq 0 ]]
}

@test "Array::hasValue (integer) false" {
  declare int_array=(1 2 3 4)
  run Array::hasValue int_array 9

  [[ $status -gt 0 ]]
}

@test "Array::indexToVar found" {
  declare var=
  Array::indexToVar test_array item1 var

  [[ $var == 0 ]]
}

@test "Array::indexToVar first occurrence" {
  declare -a my_array=(hello world world)
  declare var=
  Array::indexToVar my_array world var

  [[ $var == 1 ]]
}

@test "Array::indexToVar holes" {
  declare -a my_array=(hello world world)
  declare var=
  Array::indexToVar my_array world var
  unset my_array[$var]
  Array::indexToVar my_array world var

  [[ $var == 2 ]]
}
