
source src/ArrayUtils.bash

setup(){
  declare -ga test_array=(item1 item2 item3)
}

teardown(){
  declare -ga test_array=()
}

@test "Array_pop" {
  declare -a expected=(item1 item2)
  Array_pop test_array

  [[ ${expected[@]} == ${test_array[@]} ]]
}

@test "Array_pop empty array" {
  declare -a test_array=()
  run Array_pop test_array

  [[ $status -eq 4 ]]
}

@test "Array_popToVar" {
  declare expected="${test_array[-1]}"
  declare var=''
  echo $expected $var
  Array_popToVar test_array var

  [[ $expected == $var ]]
}

@test "Array_shift" {
  Array_shift test_array
  declare -a expected=(item2 item3)

  [[ ${expected[@]} ==  ${test_array[@]} ]]
}

@test "Array_shiftToVar" {
  declare var='' expected="${test_array[0]}"
  Array_shiftToVar test_array var

  [[ $expected == $var ]]
}

@test "Array_push" {
  declare -a expected=("${test_array[@]}" "item4")
  Array_push test_array "item4"

  [[ ${expected[@]} ==  ${test_array[@]} ]]
}

@test "Array_push multiple values" {
  declare -a expected=("${test_array[@]}" "item4" "item5")
  Array_push test_array "item4" "item5"

  [[ ${expected[@]} ==  ${test_array[@]} ]]
}

@test "Array_unshift" {
  declare -a expected=("item0" "${test_array[@]}")
  Array_unshift test_array "item0"

  [[ ${expected[@]} ==  ${test_array[@]} ]]
}

@test "Array_unshift multiple values" {
  declare -a expected=("item-1" "item0" "${test_array[@]}")
  Array_unshift test_array "item-1" "item0"

  [[ ${expected[@]} ==  ${test_array[@]} ]]
}

@test "Array_yield" {
  declare -a oth_array=() expected=(item1)
  declare in_Array_map="true"
  Array_yield item1

  [[ ${expected[@]} ==  ${oth_array[@]} ]]
}

@test "Array_yield not in Array_map" {
  declare -a oth_array=() expected=()
  declare in_Array_map="false"
  run Array_yield item1

  [[ ${expected[@]} ==  ${oth_array[@]} ]]
}

@test "Array_map" {
  declare -a new_array=()
  declare -a expected=(item1 item3)
  function example {
    case $1 in item1|item3)
        Array_yield "$1"
    esac
  }
  Array_map test_array new_array example
  unset -f example

  [[ ${expected[@]} ==  ${new_array[@]} ]]
}

@test "Array_map no callback" {
  run Array_map randomFuncName

  [[ $status -eq 6 ]]
}
