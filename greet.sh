nano greet.sh
#!/bin/bash

echo "What is your name?"
read name
echo "Hello, $name! Welcome to shell scripting."
#!/bin/bash

echo "What is your name?"
read  nithi
echo "Hello, $nithi! Welcome to shell scripting."
nano check_even_odd.sh
#!/bin/bash

echo "Enter a number:"
read 2

if (( number % 2 == 0 ))
then
  echo "$number is Even."
else
  echo "$number is Odd."
fi

