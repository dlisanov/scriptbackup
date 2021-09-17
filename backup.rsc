:local date [/sys clock get date];
:local day [ :pick $date 4 6 ]
:local month [ :pick $date 0 3 ]
:local year [ :pick $date 7 11 ]
:local size;
:local filename "history.txt";
:local backupfilename "backup";
:local copyftp true;
:local ftpip "0";
:local ftpuser "0";
:local ftppass "0";
:local ftpputremote "/";
/system history print terse file=$filename where time~$date
:set $size [/file get value-name=size [find name=$filename]];
:if ($size>124) do {
    /system backup save name=$backupfilename;
    :if($copyftp) do={ 

     }
}