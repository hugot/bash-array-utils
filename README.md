# bash-array-utils
Utility functions  for common array operations in bash

## Usage
Usage is fairly straight-forward. You can source the file and start using its functions.
All of the functions are prefixed with the name of the lib, to prevent collisions with already defined functions.

### Usage example
```bash
source path/to/dir/lib/Array.bash

declare -a example=(item1 item2 item3)

Array::popToVar example somevar

echo "The array values are now: ${example[*]}" # Will be item1 item2
echo "the value of 'somevar' is now $somevar"  # Will be item3
```

### Return values
The functions will have a range of return values depending on what happened/went wrong. You can rest assured that
they will always return 0 if the operation that they should perform was performed successfully. For more information
on the return values, please refer to the comments in Array.bash.

## Installation
Installation is fairly straight forward. The lib has no dependencies except for bash itself. You can simply clone the
repo and start using the lib:
`git clone https://github.com/redrock9/bash-array-utils`

You could also use [basher](https://github.com/basherpm/basher) to install the lib and source the file with its recently added
`include` function:
`basher install redrock9/bash-array-utils`

### Usage with bashers include function:
```bash
include redrock9/bash-array-utils lib/Array.bash

declare -a example=(item1 item2 item3)

Array::popToVar example somevar

echo "The array values are now: ${example[*]}" # Will be item1 item2
echo "the value of 'somevar' is now $somevar"  # Will be item3

```
