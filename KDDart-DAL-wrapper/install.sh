#!/bin/bash

perl Makefile.PL
make
make test
sudo make install
make clean
