-- Tabel Dimensi
CREATE TABLE Dim_Pelanggan (
    ID_Pelanggan INT PRIMARY KEY,
    Usia_Pelanggan INT,
    Jenis_Kelamin VARCHAR(10),
    Tanggungan INT,
    Pendidikan VARCHAR(50),
    Status_Kawin VARCHAR(20),
    Kontak VARCHAR(50)
);

CREATE TABLE Dim_Lokasi (
    Kode_Kota VARCHAR(10) PRIMARY KEY
);

CREATE TABLE Dim_Aset (
    ID_Pelanggan INT PRIMARY KEY,
    Punya_Kendaraan BOOLEAN,
    Punya_Rumah BOOLEAN,
    FOREIGN KEY (ID_Pelanggan) REFERENCES Fact_Pinjaman_Pelanggan(ID_Pelanggan)
);

CREATE TABLE Dim_Pekerjaan (
    ID_Pekerjaan SERIAL PRIMARY KEY,
    Deskripsi VARCHAR(100) UNIQUE
);

-- Tabel Fakta
CREATE TABLE Fact_Pinjaman_Pelanggan (
    ID_Pelanggan INT PRIMARY KEY,
    Kode_Kota VARCHAR(10),
    ID_Pekerjaan INT,
    Penghasilan DECIMAL(15,2),
    Pinjaman BOOLEAN,
    FOREIGN KEY (ID_Pelanggan) REFERENCES Dim_Pelanggan(ID_Pelanggan),
    FOREIGN KEY (Kode_Kota) REFERENCES Dim_Lokasi(Kode_Kota),
    FOREIGN KEY (ID_Pekerjaan) REFERENCES Dim_Pekerjaan(ID_Pekerjaan)
);