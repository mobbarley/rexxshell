#!/usr/bin/rexx
address SYSTEM "pwd" with output STEM sysStem.
dirPath = strip(sysStem.1)
say dirPath
exit