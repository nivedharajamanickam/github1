#!/bin/bash

echo "Enter a number:"
read number

echo "Multiplication table for $number:"

for i in {1..10}
do
  result=$(( number * i ))
  echo "$number x $i = $result"
done
