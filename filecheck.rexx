#!/usr/bin/rexx
parse arg filePath
address SYSTEM "~/code/src/bash/chkfile "filePath with output STEM fileStem.
say (fileStem.1 == 'FOUND')
