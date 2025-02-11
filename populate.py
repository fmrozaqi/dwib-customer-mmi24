import pandas as pd
import psycopg2

# Database connection parameters (adjust these based on your setup)
DB_HOST = 'localhost'
DB_PORT = '5432'
DB_NAME = 'postgres'
DB_USER = 'postgres'

# Establish connection to your PostgreSQL database
conn = psycopg2.connect(
    host=DB_HOST,
    port=DB_PORT,
    dbname=DB_NAME,
    user=DB_USER
)

# Create a cursor to execute SQL commands
cur = conn.cursor()

# Load the CSV data into a pandas DataFrame
df = pd.read_csv('customer2024.csv')

# Step 1: Insert data into Dim_Pelanggan
for _, row in df.iterrows():
    cur.execute("""
        INSERT INTO Dim_Pelanggan (ID_Pelanggan, Usia_Pelanggan, Jenis_Kelamin, Tanggungan, Pendidikan, Status_Kawin, Kontak)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT (ID_Pelanggan) DO NOTHING;
    """, (row['ID_Pelanggan'], row['Usia_Pelanggan'], row['Jenis_kelamin'], row['Tanggungan'], row['Pendidikan'], row['Status_Kawin'], row['Kontak']))
print("Dim_Pelanggan inserted successfully.")

# Step 2: Insert data into Dim_Lokasi
for _, row in df.iterrows():
    cur.execute("""
        INSERT INTO Dim_Lokasi (Kode_Kota)
        VALUES (%s)
        ON CONFLICT (Kode_Kota) DO NOTHING;
    """, (row['Kode_Kota'],))
print("Dim_Lokasi inserted successfully.")

# Step 3: Insert data into Dim_Aset
for _, row in df.iterrows():
    cur.execute("""
        INSERT INTO Dim_Aset (ID_Pelanggan, Punya_Kendaraan, Punya_Rumah)
        VALUES (%s, %s, %s)
        ON CONFLICT (ID_Pelanggan) DO NOTHING;
    """, (row['ID_Pelanggan'], row['Punya_Kendaraan'] == 'yes', row['Punya_Rumah'] == 'yes'))
print("Dim_Aset inserted successfully.")

# Step 4: Insert data into Dim_Pekerjaan
# Create a set to ensure no duplicate job entries are inserted
job_set = set(df['Pekerjaan'].dropna())
for job in job_set:
    cur.execute("""
        INSERT INTO Dim_Pekerjaan (Deskripsi)
        VALUES (%s)
        ON CONFLICT (Deskripsi) DO NOTHING;
    """, (job,))
print("Dim_Pekerjaan inserted successfully.")

# Step 5: Map pekerjaan to ID_Pekerjaan
pekerjaan_map = {}
for _, row in df.iterrows():
    if row['Pekerjaan'] not in pekerjaan_map:
        cur.execute("""
            SELECT ID_Pekerjaan FROM Dim_Pekerjaan WHERE Deskripsi = %s;
        """, (row['Pekerjaan'],))
        pekerjaan_map[row['Pekerjaan']] = cur.fetchone()[0]
print("Pekerjaan mapped successfully.")

# Step 6: Insert data into Fact_Pinjaman
for _, row in df.iterrows():
    cur.execute("""
        INSERT INTO Fact_Pinjaman_Pelanggan (ID_Pelanggan, Kode_Kota, ID_Pekerjaan, Penghasilan, Pinjaman)
        VALUES (%s, %s, %s, %s, %s)
        ON CONFLICT (ID_Pelanggan) DO NOTHING;
    """, (row['ID_Pelanggan'], row['Kode_Kota'], pekerjaan_map[row['Pekerjaan']], row['Penghasilan'], row['Pinjaman'] == 'yes'))
print("Fact_Pinjaman inserted successfully.")

# Commit the changes to the database
conn.commit()

# Close the cursor and connection
cur.close()
conn.close()

print("Data inserted successfully.")
