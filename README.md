[![Build Status](https://travis-ci.org/mumuki/mumuki-gobstones-runner.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-gobstones-runner)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-gobstones-runner/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-gobstones-runner)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-gobstones-runner/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-gobstones-runner)

# Install the server

## Clone the project

```
git clone https://github.com/mumuki/mumuki-gobstones-runner
cd mumuki-gobstones-runner
```

## Install global dependencies

```bash
rbenv install 2.3.1
rbenv rehash
gem install bundler
```

## Install local dependencies

```bash
bundle install
./bin/pull_worker.sh
```

# Run tests

```bash
bundle exec rake
```

# Run the server

```bash
RACK_ENV=development bundle exec rackup -p 4000 --host 0.0.0.0
```

# Deploy docker image

```bash
cd worker/
# docker login
docker rmi mumuki/mumuki-gobstones-worker
docker build -t mumuki/mumuki-gobstones-worker .
docker push mumuki/mumuki-gobstones-worker
```


# Test syntax

The syntax of a gobstones test is the following:

OPTIONS  
examples: [EXAMPLE]

Where:
  
* OPTIONS can be zero or more of these:
  
  * show_initial_board. Whether to show initial board. Default: true
  * show_final_board. Whether to show final board. Default: true
  * check_head_position. Whether the final head position is checked in the test. Default: false
  * expect_endless_while. Whether the test contains an infinite loop. Default: false.
  * subject. Function or procedure being evaluated. Default: nil.

* The EXAMPLE array is required and needs at least one EXAMPLE. The EXAMPLE has the following structure:

  TITLE  
  ARGUMENTS  
  INITIAL_BOARD   
  FINAL_BOARD   
  ERROR  
 
   Where:

   * TITLE is optional and represents the title that will be shown for that example. For example:
   ```yaml
   title: 'A title'
   ```
   * ARGUMENTS array is optional. It represents the arguments for the given subject. For example:
   ```yaml
   arguments: 
    - Sur
    - Verde
   ```

  * INITIAL_BOARD is required unless an ERROR is provided and has the following structure:

     _GBB/1.0_    
     SIZE    
     [CELL]    
     HEAD_POSITION    

     Where:

      * SIZE is required and receives width and height as arguments. For example:
        ```yaml
        size 5 1
        ```

      This will result in a board with 5 cells wide and 1 cell high

      * CELL array is optional. Each CELL takes two required arguments which represents the horizontal and vertical coordinates and an array of balls that will be located in that cell. For example:

        ```yaml
        cell 0 1 Verde Rojo Negro
        ```

        This will result in a green, red and black ball placed in (0,1).

      * HEAD_POSITION is required and represents the position of the head in the board. It takes two required arguments which represents the horizontal and vertical coordinates.

        ```yaml
        head 3 2
        ```

        In this case the head will start at (3,2)


  * FINAL_BOARD has the same structure as the INITIAL_BOARD with the exception that HEAD_POSITION is required only when check_head_position option is set to true. (In fact it isn't required but the test will always fail if it isn't provided)

  * ERROR isn't required. It represents an expected error, so the test will pass only if the given error occurs. Only one ERROR can be provided in a test. When providing an ERROR, FINAL_BOARD isn't required (or needed). INITIAL_BOARD is required only on those errors that need to draw the board for being executed (no_stones and out_of_board).

    Existing errors:

     * no_stones: This error occurs when a ball is tried to be removed but there were no balls in that cell.
     * out_of_board: This error occurs when a move is made that falls out of the board.
     * wrong_argument_type: This error occurs when a function is called with the incorrect type of argument. For example: `Mover(Rojo)`
     * unassigned_variable: This error occurs when a variable is used without previous declaration.

# Kids tests considerations

## Unsupported operations

Currently the runner doesn't support a subject when the solution is sent in xml format

## Operations that doesn't make sense

Because of the layout and the pedagogic considerations, there are certain operations supported by the runner that doesn't make sense to use in kids mode:

* show_initial_board and show_final_board: Because of kids layout, the boards are always being displayed.
* check_head_position: For the kids this may be a bit difficult to understand and there is no pedagogic benefit in using it.

