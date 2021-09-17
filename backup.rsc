:local date [/sys clock get date];
:local day [ :pick $date 4 6 ]
:local month [ :pick $date 0 3 ]
:local year [ :pick $date 7 11 ]
:local datetext "$year-$month-$day";
:local size;
:local filename "history.txt";
:local backupfilename "backup";
:local copyftp true;
:local ftpaddr "0";
:local ftpuser "0";
:local ftppass "0";
:local ftpputremote "/";
:local noticeonmail true;
:local copytoemail true;
:local mailfrom "";
:local mailto "";
:local smtpaddr "";
:local mailuser "";
:local mailpass "";
/system history print terse file=$filename where time~$date
:set $size [/file get value-name=size [find name=$filename]];
:if ($size>124) do {
    /system backup save name=$backupfilename;
    :if($copyftp) do={ 
        /tool fetch address=$ftpaddr src-path=$backupfilename user=$ftpuser password=$ftppass port=21 upload=yes mode=ftp dst-path=($ftpputremote . $datetext . "backup.")
        delay 15s;
     }
     :if($noticeonmail) do={ 

      }
}