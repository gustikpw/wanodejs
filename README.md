# Aplikasi Simpel Whatsapp Api
- Repositori ini berisi kode untuk menghubungkan aplikasi Anda ke WhatsApp melalui API. Dengan menggunakan repositori ini, Anda dapat mengirim pesan WhatsApp dari aplikasi Anda dengan cara yang mudah dan terotomatisasi.
- Repositori ini menggunakan whatsapp-web.js untuk berinteraksi dengan WhatsApp, express sebagai server, dan qrcode-terminal untuk menampilkan kode QR yang diperlukan untuk mengautentikasi dengan WhatsApp.


## Persiapan
1. Install nodejs : Dapat mengunduh di https://nodejs.org/ dan ikuti panduan instalasi sesuai dengan OS yang digunakan
2. Download atau clone repository https://github.com/AknalRe/whatsappapi
3. Setelahnya konfigurasi file .env dengan keinginan, dengan contoh berikut
    ```bash
    Nomor_ADMIN=nomor_admin_anda
    SECRET_APP=kode_rahasia_anda
    PORT=port_yang_ingin_digunakan
    ```
4. Buka Command Prompt (CMD) untuk Windows dan Terminal untuk Linux
5. Arahkan ke tempat penyimpanan hasil download atau clone sebelumnya
    ```bash
    cd /nodejs/whatsapp-main/
    ```
6. Install module yang di butuhkan dengan perintah berikut :
    ```bash
    npm install
    ```
    Terkhusus Linux :
    - Jika terdapat kegagalan instalasi di linux, buka dokumentasi ini https://wwebjs.dev/guide/#installation
    - Jika masih berlanjut kesalahan tersebut coba untuk menginstall chromium atau google-chrome :
        - apt-get install chromium-browser
        - apt-get install google-chrome-stable
    - Beberapa pemecahan masalah dengan bersumber pada stackoverflow berikut
    https://stackoverflow.com/questions/72995651/error-failed-to-launch-the-browser-process-whatsapp-web-js-azure-portal-linu
7. Setelah installasi module yang dibutuhkan berhasil tanpa kendala, jalankan berikut:
    ```bash
    node app.js
    ```
8. Jika penyiapan sebelumnya sudah di lakukan tanpa kendala semuanya, maka seharusnya aplikasi sudah berjalan dengan semestinya. Aplikasi di atur berjalan secara default di port 180, jika nilai port pada .env sudah di atur sebelumnya maka aplikasi berjalan di port sesuai dengan yang di atur.

## API Endpoint
 - POST /messsage
    Mengirim pesan WhatsApp ke nomor yang ditentukan.
 - Permintaan
    Body JSON: 
    - secretApp (String): Kode rahasia untuk otorisasi.
    - phoneNumber (String): Nomor telepon tujuan.
    - message (String): Pesan yang akan dikirim.
 - Respon
    -   Status 200: Pesan berhasil terkirim.
    -   Status 500: Kesalahan dalam proses pengiriman pesan atau kode rahasia tidak cocok.


## Contoh Mengirimkan Permintaan POST
1. WINDOWS
    - Pastikan Anda telah menginstal curl di sistem Anda sebelum melanjutkan.
    - Buka Command Prompt Windows.
    - Gunakan perintah CURL untuk mengirimkan permintaan POST erikut dan menganti port , nilai nya :
        ```bash
        curl -X POST http://localhost:180/message -H "Content-Type: application/json" -d "{\"secretApp\":\"isi dengan secret\",\"phoneNumber\":\"isi dengan nomor\",\"message\":\"isi pesan\"}"
        ```
        Pastikan untuk menggantikan "isi dengan secret," "isi dengan nomor," dan "isi pesan" dengan nilai yang sesuai.
2. Mikrotik
    - Buka Winbox
    - Buka menu system->script dan buat script baru dengan nama test_wa
        ```bash
        :local apiwa "http://localhost:180/message"
        :local secret "isi dengan secret"
        :local nomor "isi dengan nomor"
        :local pesan "isi pesan"
        
        /tool fetch url=($apiwa) mode=http \
             http-method=post \
             http-header-field="Content-Type: application/json" \
             http-data="{\"secretApp\":\"$secret\",\"phoneNumber\":\"$nomor\",\"message\":\"$pesan\"}" \
             keep-result=no
        ```
        Pastikan Anda telah menggantikan "isi dengan secret," "isi dengan nomor," dan "isi pesan" dengan nilai yang sesuai.
    - Lalu buka terminal pada winbox dan ketikkan berikut :
        ```bash
        system script run test_wa
        ```
    - Contoh langsung di terminal :
        ```bash
        [Renaldi@LenovoG40-80] > :global secret ;:global nomoradmin ;:global urlapi ;:local endpoint "/message";:local api ($urlapi . $endpoint);:local response [/tool fetch url=($api) mode=http http-method=post http-header-field="Content-
        Type: application/json" http-data="{\"secretApp\":\"$secret\",\"phoneNumber\":\"$nomoradmin\",\"message\":\"Haloo\"}" keep-result=no ];:put ($response)
              status: finished
          downloaded: 0KiBC-z pause]
               total: 0KiB
            duration: 1s
        
        
        [Renaldi@LenovoG40-80] >
        ```
        

### Update
1. 17-10-2023
    - Penambahan Nodejs
        - Penambahan Endpoint GET /message dan /logpesan/adminnumber/secret
            - Mengakses Endpoint GET /message :
                ```bash
                http://localhost:180/message?secretApp=isi_secret&phoneNumber=isi_nomor_tujuan&message=isi_pesan
                ```
                Dapat dikombinasikan dengan phpnuxbill
            - Mengakses Endpoint GET /logpesan :
                ```bash
                http://localhost:180/logpesan/isi_dengan_nomoradmin/isi_dengan_secret/
                ```
    - Penambahan Mikrotik Script
        - Menerima pesan dan memproses pesan (Interaksi Whatsapp dengan Mikrotik)
        - Cek status, interface, ppp, dhcp, hotspot user dengan pesan whatsapp
        - Memproses dan mengirimkan tagihan atau iuran ke pelanggan pppoe secara otomatis ataupun manual dengan perintah melalui whatsapp
    
2. 20-10-2023
    - Penambahan Nodejs
        - Penambahan Endpoint GET
            - /error :
            ```bash
            http://localhost:180/error
            ```
            Di buat untuk di download di jadikan webproxy isolir.html pada mikrotik
    - Penambahan Mikrotik Script
        - Script Profile Hotspot
            - Notifikasi/Hapus otomatis user hotspot yang terkoneksi
        - Manual Blokir/Isolir User Mikrotik
