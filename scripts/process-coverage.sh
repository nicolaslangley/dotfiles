#!/usr/bin/env bash
xcrun llvm-profdata merge -o unit-coverage.profdata default.profraw
