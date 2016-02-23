#!/usr/bin/bash
dfmt -i --brace_style=allman --indent_style=space --indent_size=2 \
    --max_line_length=100 $@
