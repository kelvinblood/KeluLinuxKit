#!/bin/bash

# STATICS
staticsDir='/etc/kelu/StaticsScript'
$staticsDir/keluNetSum.sh
echo '================================================'
echo ''
$staticsDir/keluSysSum.sh
echo '================================================'
echo ''
$staticsDir/keluPPTPSum.sh
