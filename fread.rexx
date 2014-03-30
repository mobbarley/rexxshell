#!/usr/bin/rexx
parse arg argString
/*---------------------------------------------------------------------------*/
/* ** REXX FileReader v0.1 ** (c) Polygon Systems, 2012			     */
/*---------------------------------------------------------------------------*/
/* Usage guidelines : fread.rexx --file=[filename] or                        */
/*		      fread.rexx --path=[pathname]                           */
/*---------------------------------------------------------------------------*/
address SYSTEM "pwd" with output STEM sysStem.	/* get the working directory */
dirPath = strip(sysStem.1)			/* set current path	     */
posPath=index(strip(argString),'--path=')	/* information based on the  */
posFile=index(strip(argString),'--file=')	/* given options             */
fileStem.0 = 0

if (posPath > 0) && (posFile > 0) then do	/* valid options             */
      select
	when posPath > 0 then do		/* --path option             */
	  filePath = substr(strip(argString),posPath+length('--path='))
	  if FileCheck(filePath) == 'OK' then   /* check file errors         */
	    address SYSTEM "cat "filePath with output STEM fileStem.
	end
	when posFile > 0 then do		/* --path option             */
	  filename = substr(strip(argString),posFile+length('--file='))
	  filePath = dirPath || '/' || filename /* set path                  */
	  if FileCheck(filePath) == 'OK' then 	/* check file errors         */
	    address SYSTEM "cat "filePath with output STEM fileStem.
	end
	otherwise nop
      end
      if fileStem.0 <> 0 then do		/* display file contents     */
	do i = 1 to fileStem.0
	  say fileStem.i
	end
      end
      else call FileError 'READ' filePath  	
   end
else
  call FileError 'USAGE' argString
call exit_route

/*---------------------------------------------------------------------------*/
/* Procedure to check file errors if any                                     */
/*---------------------------------------------------------------------------*/
FileCheck: procedure
  parse arg filePath
  if FileExists(filePath) then do
    if ReadAccess(filePath) then do
      return('OK')
    end
    else
      call FileError 'ACCESS' filePath
  end
  else call FileError 'NOTFOUND' filePath
return ('ERROR')

/*---------------------------------------------------------------------------*/
/* Procedure to check file if file exists via shell command chkfile          */
/*---------------------------------------------------------------------------*/
FileExists: procedure
  parse arg filePath 
  address SYSTEM "chkfile "filePath with output STEM fileStem.
  return(fileStem.1 == 'FOUND')

/*---------------------------------------------------------------------------*/
/* Procedure to check file read access via shell command chkaccess           */
/*---------------------------------------------------------------------------*/
ReadAccess: procedure
parse arg filePath 
  address SYSTEM "chkaccess -r "filePath with output STEM fileStem.
  return(fileStem.1 == 'OK')
return

/*---------------------------------------------------------------------------*/
/* Procedure to handle file errors                                           */
/*---------------------------------------------------------------------------*/
FileError: procedure
parse arg errType errString
select
  when errType == 'ACCESS' then do
    say "ERROR in ** REXX FileReader v0.1 ** (c) Polygon Systems 2012"
    say "No read permissions for file" errString
    say "Check the read permissions of the file or use chmod"
    call exit_route
  end
  when errType == 'NOTFOUND' then do
    say "ERROR in ** REXX FileReader v0.1 ** (c) Polygon Systems 2012"
    say "File not found" errString
    say "Check if the given file exists!!"
    call exit_route
  end
  when errType == 'READ' then do
    say "ERROR in ** REXX FileReader v0.1 ** (c) Polygon Systems 2012"
    say "Error reading file" errString
    say "Or the given file is empty."
    call exit_route
  end
  when errType == 'USAGE' then do
    say "ERROR in ** REXX FileReader v0.1 ** (c) Polygon Systems 2012"
    say "Invalid parameter string :" errString
    say "Valid usage 'fread.rexx --path=[pathname]' or 'fread.rexx --file=[filename]'" 
    call exit_route
  end
  otherwise nop
end
return

exit_route:
exit