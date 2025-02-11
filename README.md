# Project Setup

## Prerequisites

- Docker
- Python

## Getting Started

1. **Run Docker Compose:**

   ```sh
   docker-compose up -d
   ```

2. **Populate the Table:**
   Ensure the table is populated using the `table.sql` file.

3. **Run the Population Script:**

   ```sh
   python populate.py
   ```

   ## Database Schema

   ```mermaid
   erDiagram
       Dim_Pelanggan {
           INT ID_Pelanggan PK
           INT Usia_Pelanggan
           VARCHAR Jenis_Kelamin
           INT Tanggungan
           VARCHAR Pendidikan
           VARCHAR Status_Kawin
           VARCHAR Kontak
       }

       Dim_Lokasi {
           VARCHAR Kode_Kota PK
       }

       Dim_Aset {
           INT ID_Pelanggan PK
           BOOLEAN Punya_Kendaraan
           BOOLEAN Punya_Rumah
       }

       Dim_Pekerjaan {
           INT ID_Pekerjaan PK
           VARCHAR Deskripsi
       }

       Fact_Pinjaman_Pelanggan {
           INT ID_Pelanggan PK
           VARCHAR Kode_Kota
           INT ID_Pekerjaan
           DECIMAL Penghasilan
           BOOLEAN Pinjaman
       }

       Dim_Aset ||--o{ Fact_Pinjaman_Pelanggan : "has"
       Dim_Pelanggan ||--o{ Fact_Pinjaman_Pelanggan : "has"
       Dim_Lokasi ||--o{ Fact_Pinjaman_Pelanggan : "located in"
       Dim_Pekerjaan ||--o{ Fact_Pinjaman_Pelanggan : "has"
   ```

Follow these steps to set up and run the project. Make sure you have Docker and Python installed on your system.
