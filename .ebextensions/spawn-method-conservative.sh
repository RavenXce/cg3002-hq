#!/bin/bash
 
# add "--spawn-method conservative" to passenger config if it doesn't exist
sed -E -i.bak '/--spawn-method conservative/! s,(passenger start .*)\\,\1--spawn-method conservative \\,g' /etc/init.d/passenger
