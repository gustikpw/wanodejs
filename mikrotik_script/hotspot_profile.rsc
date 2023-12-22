:global pesanoutbox;
:global header;
:global footer;

:local nama $user;
:local ip $address;
:local prf $profile;
:local mac $"mac-address";
:local tanggal [/system clock get date];
:local waktu [/system clock get time];
:local stringtanggal "$tanggal / $waktu"
:local useraktif [/ip hotspot active print count-only];
:local lby [/ip hotspot active get [find user="$nama"] login-by];
:local host [/ip dhcp-server lease get [find address="$ip"] host-name];


:local namaprf [:pick $prf 0 [:find $prf "|"]];
:local timeprf [:pick $prf ([:find $prf "|"] + 1) [:len $prf]];

:local namasch "User $nama | HAPUS USER HOTSPOT";

/ip hotspot user set [find name=$nama] comment="BERHASIL LOGIN"

:if ([/ip hotspot user get [find name=$nama] comment]="BERHASIL LOGIN") do={
  /ip hotspot user set [find name=$nama] comment="Login : $stringtanggal";
  /ip hotspot user set $nama mac=$mac;
  :log info "User $nama sudah berhasil login dan sudah di bindingkan dengan mac $mac";

  :local emot "{centang}";
  :set pesanoutbox "$header\\n\\n$emot $nama berhasil login hotspot\\nWaktu Login\\t: $stringtanggal\\nIP Address\\t: $ip\\nProfile\\t: $prf\\n\\nTotal User Hotspot Active : $useraktif\\n\\n$footer";
  /system script run wa_fetch_pesan
} else={
  :log warning "User $nama berhasil melakukan login ulang.";
}

:if (:len [/system schedule find name=$namasch] = 0) do={
  /system scheduler add name=$namasch start-date=$tanggal start-time=$waktu interval=$timeprf on-event=":global pesanoutbox;\r\n/ip hotspot active remove [find user=$nama]\r\n/ip hotspot user remove [find name=$nama]\r\n:if ([:len [/ip hotspot user find name=$nama]] = 0 && [:len [/ip hotspot active find user=$nama]] = 0) do={\r\n /system scheduler remove [find name=$namasch]\r\n :set pesanoutbox "User $nama dan scheduller $namasch\\n{centang} Berhasil Dihapus";\r\n /system script run wa_fetch_pesan\r\n}"
}
