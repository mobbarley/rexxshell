#!/usr/bin/rexx
lineNum = 0
do while (lines() <> 0)
  parse LINEIN line
  if line <> '' then do
     lineNum = lineNum + 1
     say "Line #"lineNum "is" lineNum
  end
  else leave
end