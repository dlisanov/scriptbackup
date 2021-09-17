:local date [/sys clock get date];
:local day [ :pick $date 4 6 ]
:local month [ :pick $date 0 3 ]
:local year [ :pick $date 7 11 ]
:local datetext "$year-$month-$day";
:local size;
:local filename "history.txt";
:local backupfilename "mikrotik";
:local fullbackupfilename ($backupfilename . ".backup");
:local copyftp true;
:local ftpaddr "";
:local ftpuser "";
:local ftppass "";
:local ftpputremote "/";
:local noticeonmail true;
:local copytoemail true;
:local mailfrom "";
:local mailto "";
:local smtpaddr "";
:local mailuser "";
:local mailpass "";
:local mailbody "";
:local mailsubj "Mikrotik backup";
:local mailport 25;
:local mailtls "yes";
/system history print terse file=$filename where time~$date;
:set $size [/file get value-name=size [find name=$filename]];
:if ($size>124) do {
    /system backup save name=$backupfilename;
    :if ($copyftp=true) do={ 
        /tool fetch address=$ftpaddr src-path=$fullbackupfilename user=$ftpuser password=$ftppass port=21 upload=yes mode=ftp dst-path=($ftpputremote . $datetext . ".backup");
        delay 15s;
        :set mailbody ("Mirotik backup copy to ftp - " . $ftpaddr . " file name - " . $ftpputremote . $datetext . "backup");
     }
     :if (($copytoemail && $noticeonmail) || ($copytoemail)) do={ 
        /tool e-mail send from=$mailfrom to=$mailto server=$smtpaddr port=$mailport user=$mailuser password=$mailpass start-tls=$mailtls file=$fullbackupfilename subject=$mailsubj body=$mailbody;
      } else= {
          :if ($noticeonmail) do={ 
              /tool e-mail send from=$mailfrom to=$mailto server=$smtpaddr port=mailport user=$mailuser password=$mailpass start-tls=$mailtls subject=$mailsubj body=$mailbody;
           }
      }
}