#!/usr/bin/env bash
xcrun llvm-cov show -instr-profile=unit-coverage.profdata $1 $2
