#!/usr/bin/env bash
export CXXFLAGS="-fprofile-instr-generate -fcoverage-mapping"
export LDFLAGS="--coverage"
