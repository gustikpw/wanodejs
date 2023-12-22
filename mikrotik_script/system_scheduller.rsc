add interval=7s name=wa_getupdate on-event="/system script run wa_getupdate" \
    policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=oct/14/2023 start-time=14:20:06
add interval=1d10s name=wa_tagihan on-event=":local hariini [/system clock get\
    \_date];\r\
    \n:local timeini [/system clock get time];\r\
    \n\r\
    \n:local timestamp (\"\$hariini / \$timeini\");\r\
    \n:put \"Waktu Sekarang \$timestamp\";\r\
    \n\r\
    \n:global header;\r\
    \n:global footer;\r\
    \n:global infoadmin;\r\
    \n:global pesanisolir;\r\
    \n:global tnggalisolir;\r\
    \n:global tnggaltagihan;\r\
    \n:global tnggalpengingat;\r\
    \n:global pesanoutbox;\r\
    \n:global nomoruser;\r\
    \n:global pesanoutboxuser;\r\
    \n\r\
    \n:local listbelum \"List Pengguna PPPoE Belum Bayar & Terisolir\\\\n:\\\\\
    n\";\r\
    \n:local listsudah \"List Pengguna PPPoE Sudah Bayar\\\\n:\\\\n\";\r\
    \n\r\
    \n\r\
    \n:if (\$hariini~\"/\$tnggaltagihan/\") do={\r\
    \n  :log warning \"Data tanggal sekarang \$hariini sama dengan data tangga\
    l tagihan \$tnggaltagihan. Memproses pengiriman tagihan.\";\r\
    \n  :set pesanoutbox \"Waktu Sekarang \$timestamp\\\\n\\\\nTanggal sesuai \
    dengan ketentuan tanggal tagihan yaitu \$tnggaltagihan. Memproses pengirim\
    an tagihan.\";\r\
    \n  /system script run wa_fetch_pesan;\r\
    \n  /system script run wa_template_tagihan_pppoe;\r\
    \n  :set pesanoutbox \"Tagihan sudah dikirimkan\";\r\
    \n  /system script run wa_fetch_pesan;\r\
    \n  :log warning \"Pengiriman tagihan selesai\";\r\
    \n} else={\r\
    \n  :put \"Bukan Tanggal \$tnggaltagihan\";\r\
    \n\r\
    \n  :if (\$hariini~\"/\$tnggalpengingat/\") do={\r\
    \n    :log warning \"Data tanggal sekarang \$hariini sama dengan data tang\
    gal penggingat tagihan \$tnggalpengingat. Memproses pengiriman penggingat \
    tagihan.\";\r\
    \n    :set pesanoutbox \"Waktu Sekarang \$timestamp\\\\n\\\\nTanggal sesua\
    i dengan ketentuan tanggal pengingat tagihan yaitu \$tnggalpengingat. Memp\
    roses pengiriman penginggat tagihan.\";\r\
    \n    /system script run wa_fetch_pesan;\r\
    \n    /system script run wa_template_pengingat_pppoe;\r\
    \n    :set pesanoutbox \"Pengingat tagihan sudah dikirimkan\";\r\
    \n    /system script run wa_fetch_pesan;\r\
    \n    :log warning \"Pengiriman pengingat tagihan selesai\";\r\
    \n  } else={\r\
    \n    :put \"Bukan Tanggal \$tnggalpengingat\";\r\
    \n\r\
    \n    :if (\$hariini~\"/\$tnggalisolir/\") do={\r\
    \n        :log warning \"Data tanggal sekarang \$hariini sama dengan data \
    tanggal isolir pelanggan \$tnggalisolir. Memproses isolir pelanggan dimula\
    i.\";\r\
    \n        :foreach pppSecretId in=[/ppp secret find service=\"pppoe\"] do=\
    {\r\
    \n            :local comment [/ppp secret get \$pppSecretId comment];\r\
    \n            :if ([:len \$comment] > 0) do={\r\
    \n                :local delimiter ([:find \$comment \"|\"]);\r\
    \n                :local number [:pick \$comment 0 \$delimiter];\r\
    \n                :local remaining [:pick \$comment (\$delimiter + 1) [:le\
    n \$comment]];\r\
    \n                :local name ([:pick \$remaining 0 ([:find \$remaining \"\
    |\"])]);\r\
    \n                \r\
    \n                :local remaining2 [:pick \$remaining ([:find \$remaining\
    \_\"|\"] + 1) [:len \$remaining]];\r\
    \n                :local tagihan ([:pick \$remaining2 0 ([:find \$remainin\
    g2 \"|\"])]);\r\
    \n                :local remaining3 ([:pick \$remaining2 ([:find \$remaini\
    ng2 \"|\"] + 1) [:len \$remaining2]]);\r\
    \n                :local paket ([:pick \$remaining3 0 ([:find \$remaining3\
    \_\"|\"])]);\r\
    \n                :local status ([:pick \$remaining3 ([:find \$remaining3 \
    \"|\"] + 1) [:len \$remaining3]]);\r\
    \n\r\
    \n                :if ( \$status = \"BELUM\") do={\r\
    \n                    :set pesanoutboxuser \"\$header\\\\n\\\\nPelanggan *\
    \$name*\\\\n\\\\nInternet Telah Dimatikan, dikarenakan belum melakukan pem\
    bayaran. Jika sudah melakukan pembayaran silakan hubungi nomor admin terte\
    ra di bawah.\\\\n\\\\n\$infoadmin\\\\n\\\\n\$footer\";\r\
    \n                    :set nomoruser \$number;\r\
    \n                    /system script run wa_fetch_pesan_user;\r\
    \n                    :delay 4s;\r\
    \n                    :set listbelum (\$listbelum + \"*\" + \$name + \"*, \
    \");\r\
    \n                    :local addresspppoe [ppp secret get dito remote-addr\
    ess];\r\
    \n                    :log warning \"Pelanggan \$name IP \$addresspppoe di\
    \_ISOLIR karena belum melakukan pembayaran\";\r\
    \n                    :set pesanisolir \".isolir|tambah|\$addresspppoe\";\
    \r\
    \n                    /system script run wa_isolir\r\
    \n                } else={\r\
    \n                    :set listsudah (\$listsudah + \"*\" + \$name + \"*, \
    \");\r\
    \n                }\r\
    \n            }\r\
    \n        }\r\
    \n        :set pesanoutbox \"Berikut Data PPPoE\\\\n\\\\n\\\\n\$listbelum\
    \\\\n\\\\n\$listsudah\";\r\
    \n        /system script run wa_fetch_pesan\r\
    \n        :log warning \"Proses isolir pelanggan berhenti\";\r\
    \n    } else={\r\
    \n        :put \"Bukan Tanggal \$tnggalisolir\";\r\
    \n    }\r\
    \n  };\r\
    \n};" policy=read,write,policy,test,sensitive start-date=jun/01/2023 \
    start-time=00:00:00