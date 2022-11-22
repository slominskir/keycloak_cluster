#!/bin/bash

dsconf localhost backend create --suffix="dc=example,dc=com" --be-name="example"

dsidm -b "dc=example,dc=com" localhost initialise