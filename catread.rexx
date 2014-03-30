#!/usr/bin/rexx
parse arg fileInfo
address SYSTEM "cat "fileInfo with output stem fileStem.
do i = 1 to fileStem.0 by 1
   say fileStem.i 
end	

