#!/bin/bash

read -p "Optional extra? (e.g. y/N)" $testvar
if [ $testvar -eq "y" ]; then;
    echo "Yes!";
fi;