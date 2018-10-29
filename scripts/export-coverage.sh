#!/usr/bin/env bash
xcrun llvm-cov show -format="html" -output-dir=./coverage-output -instr-profile=unit-coverage.profdata $1 $2
