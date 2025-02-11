-- Get Aggregate Jenis_Kelamin and Usia_Pelanggan
SELECT 
    Jenis_Kelamin, 
    COUNT(*) AS Jumlah_Pelanggan
FROM 
    Dim_Pelanggan
WHERE 
    Usia_Pelanggan < 30
GROUP BY 
    Jenis_Kelamin;

-- Get Aggregate Jenis_Kelamin and Pinjaman
SELECT 
    dp.Jenis_Kelamin, 
    COUNT(*) AS Jumlah_Pelanggan
FROM 
    Dim_Pelanggan dp
JOIN 
    Fact_Pinjaman_Pelanggan fpp ON dp.ID_Pelanggan = fpp.ID_Pelanggan
WHERE 
    fpp.Pinjaman = TRUE
GROUP BY 
    dp.Jenis_Kelamin;

-- Get Aggregate Jenis_Kelamin and Penghasilan
SELECT 
    dp.Jenis_Kelamin, 
    COUNT(*) AS Jumlah_Pelanggan
FROM 
    Dim_Pelanggan dp
JOIN 
    Fact_Pinjaman_Pelanggan fpp ON dp.ID_Pelanggan = fpp.ID_Pelanggan
WHERE 
    fpp.Pinjaman = FALSE 
    AND fpp.Penghasilan < 35000
GROUP BY 
    dp.Jenis_Kelamin;

-- Get Aggregate Jenis_Kelamin and Penghasilan
SELECT 
    dp.Jenis_Kelamin, 
    CASE 
        WHEN fpp.Penghasilan < 35000 THEN '< 35,000'
        WHEN fpp.Penghasilan >= 35000 AND fpp.Penghasilan < 70000 THEN '35,000 - 69,999'
        ELSE '> 70,000'
    END AS Kategori_Penghasilan,
    COUNT(*) AS Jumlah_Pelanggan
FROM 
    Dim_Pelanggan dp
JOIN 
    Fact_Pinjaman_Pelanggan fpp ON dp.ID_Pelanggan = fpp.ID_Pelanggan
WHERE 
    fpp.Pinjaman = FALSE
GROUP BY 
    dp.Jenis_Kelamin, 
    Kategori_Penghasilan;
