#!/bin/bash

ls -w1 *.[ENTENSAO] | while read line; do mv "$line" "$(echo $line | tr '\ ' '_')"; done 