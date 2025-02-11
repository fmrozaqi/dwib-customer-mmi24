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

-- Get Aggregate Jenis_Kelamin and Kelompok Usia Pelanggan
select 
	count(*) as "Jumlah Pelanggan", 
	t.range as "Kelompok Usia", 
	t.jenis_kelamin as "Jenis Kelamin"
from (
      select ID_Pelanggan, jenis_kelamin,
         case 
         	when usia_pelanggan < 30 then 'Kurang dari 30'
         	when usia_pelanggan >= 30 and usia_pelanggan < 40 then '30 sampai 40'
         	when usia_pelanggan >= 40 and usia_pelanggan < 50 then '40 sampai 50'
         	when usia_pelanggan >= 50 and usia_pelanggan <= 60 then '50 sampai 60'
         	else '60+' 
         end as range
     from dim_pelanggan dp) t
group by t.jenis_kelamin, t.range order by "Jumlah Pelanggan" asc ;

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
