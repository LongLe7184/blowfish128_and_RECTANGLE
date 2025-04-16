#!/bin/bash

echo "---Running generateSBoxVal.pl"
echo "---Generating blowfish128_DEF.svh"
perl generateSBoxVal.pl

echo "---Running generateSBoxModel.pl"
echo "---Generating model_DEF.svh"
perl generateSBoxModel.pl
