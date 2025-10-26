# 📊 SQL Veri Analizi Projesi

İş zekası ve veri odaklı karar verme için tasarlanmış kapsamlı bir SQL veri analizi projesi. Bu proje, müşteri davranış analizi, ürün performans değerlendirmesi ve satış trend analizi için gelişmiş SQL sorguları, veri ambarı mimarisi ve analitik raporlar içerir.

## 🎯 Proje Genel Bakış

Bu veri analizi projesi, SQL Server kullanarak iş verilerini analiz etmek için eksiksiz bir çözüm sunar. Bronz, gümüş ve altın katmanları ile modern bir veri ambarı mimarisi uygular ve müşteri segmentasyonu, ürün analizi, satış performans metrikleri ve zaman serisi trend analizi özelliklerini içerir.

## 🏗️ Proje Yapısı

```
SQL Data Analytics/
├── 📁 datasets/
│   ├── 📁 csv-files/
│   │   ├── 🥇 Altın Katman (Analitik Veri)
│   │   │   ├── gold.dim_customers.csv (18,485 müşteri)
│   │   │   ├── gold.dim_products.csv (296 ürün)
│   │   │   ├── gold.fact_sales.csv (60,398 satış kaydı)
│   │   │   ├── gold.report_customers.csv (Müşteri analitikleri)
│   │   │   └── gold.report_products.csv (Ürün analitikleri)
│   │   └── 📄 placeholder
│   └── 📄 DataWarehouseAnalytics.bak
└── 📁 scripts/
    ├── 00_init_database.sql
    ├── 01_changes_over_time_analysis.sql
    ├── 02_cumulative_analysis.sql
    ├── 03_performance_analysis.sql
    ├── 04_part_to_whole_analysis.sql
    ├── 05_data_segmentation.sql
    ├── 06_customer_report.sql
    └── 07_product_reports.sql
```

## 🚀 Kurulum ve Kullanım

### Ön Gereksinimler
- Microsoft SQL Server 2019 veya üzeri
- SQL Server Management Studio (SSMS) veya Azure Data Studio
- SQL Server desteği olan Windows/Linux ortamı

### Kurulum Adımları

1. **Veritabanını Oluşturun**
   ```sql
   -- Başlatma betiğini çalıştırın
   EXEC scripts/00_init_database.sql
   ```

2. **Veri Genel Bakış**
   - **Altın Katman**: Raporlama için hazır önceden işlenmiş analitik veri
   - **Müşteri Verisi**: Demografik bilgilerle 18,485 benzersiz müşteri
   - **Ürün Verisi**: Birden fazla kategoride 296 ürün
   - **Satış Verisi**: Birden fazla yıla yayılan 60,398 satış işlemi

3. **Analiz Sorgularını Çalıştırın**
   ```sql
   -- Zaman serisi analizi
   EXEC scripts/01_changes_over_time_analysis.sql
   
   -- Müşteri analitikleri
   EXEC scripts/06_customer_report.sql
   
   -- Ürün performansı
   EXEC scripts/07_product_reports.sql
   ```

## 📈 Analiz Türleri

### 1. ⏰ Zaman Serisi Analizi (`01_changes_over_time_analysis.sql`)
- Yıllık satış trendleri ve desenleri
- Aylık performans analizi
- Müşteri büyüme metrikleri
- Miktar bazlı trend analizi
- Zaman içinde gelir ilerlemesi

### 2. 📊 Kümülatif Analiz (`02_cumulative_analysis.sql`)
- Çalışan toplamlar ve kümülatif metrikler
- Büyüme oranı hesaplamaları
- İlerleyici performans takibi
- Hareketli ortalamalarla trend analizi

### 3. 🎯 Performans Analizi (`03_performance_analysis.sql`)
- Anahtar Performans Göstergeleri (KPI)
- Performans kıyaslama
- Dönemler arası karşılaştırmalı analiz
- Verimlilik metrikleri hesaplama

### 4. 🔍 Parça-Bütün Analizi (`04_part_to_whole_analysis.sql`)
- Kategori dağılım analizi
- Pazar payı hesaplamaları
- Segment katkı analizi
- Yüzde dağılımları

### 5. 👥 Veri Segmentasyonu (`05_data_segmentation.sql`)
- Müşteri segmentasyon stratejileri
- Ürün kategorilendirmesi
- Davranışsal gruplandırma analizi
- Demografik segmentasyon

### 6. 👤 Müşteri Analitikleri (`06_customer_report.sql`)
- Müşteri profilleme ve demografikleri
- Yaş grubu analizi
- VIP müşteri tanımlama
- Müşteri yaşam boyu değeri (CLV)
- Yakınlık, Sıklık, Parasal (RFM) analizi
- Müşteri segmentasyonu (VIP, Düzenli, Yeni)

### 7. 🛍️ Ürün Analitikleri (`07_product_reports.sql`)
- Ürün performans metrikleri
- Kategori bazlı satış analizi
- En çok satan ürünlerin tanımlanması
- Ürün karlılık analizi
- Pazar performans değerlendirmesi

## 🎨 Veri Ambarı Mimarisi

### Altın Şema Tabloları

#### `dim_customers` (Müşteri Boyut Tablosu)
- **Kayıtlar**: 18,485 müşteri
- **Anahtar Alanlar**: customer_key, customer_id, customer_number, first_name, last_name
- **Demografikler**: country, marital_status, gender, birthdate, create_date
- **Amaç**: Analitik ve raporlama için müşteri ana verisi

#### `dim_products` (Ürün Boyut Tablosu)
- **Kayıtlar**: 296 ürün
- **Anahtar Alanlar**: product_key, product_id, product_number, product_name
- **Kategoriler**: category_id, category, subcategory, product_line
- **Finansal**: cost, maintenance requirements
- **Amaç**: Hiyerarşik kategorilendirme ile ürün ana verisi

#### `fact_sales` (Satış Olgu Tablosu)
- **Kayıtlar**: 60,398 satış işlemi
- **Anahtar Alanlar**: order_number, product_key, customer_key
- **Tarihler**: order_date, shipping_date, due_date
- **Metrikler**: sales_amount, quantity, price
- **Amaç**: Tüm satış analizleri için temel işlem verisi

#### `report_customers` (Müşteri Analitik Görünümü)
- **Türetilmiş Metrikler**: total_orders, total_sales, total_quantity, lifespan
- **Segmentasyon**: customer_segment (VIP, Regular, New), age_group
- **KPI'lar**: recency, avg_order_value, avg_monthly_spend
- **Amaç**: Raporlama için önceden hesaplanmış müşteri analitikleri

#### `report_products` (Ürün Analitik Görünümü)
- **Performans Metrikleri**: total_orders, total_sales, total_quantity, total_customers
- **Segmentasyon**: product_segment (High-Performer, vb.)
- **Finansal**: avg_selling_price, avg_order_revenue, avg_monthly_revenue
- **Amaç**: Önceden hesaplanmış ürün performans metrikleri

## 📊 Temel Özellikler

- ✅ **Modern Veri Mimarisi**: Optimize edilmiş analitik tablolarla altın katman
- ✅ **Kapsamlı Analitikler**: Tüm iş yönlerini kapsayan 7 farklı analiz türü
- ✅ **Müşteri Segmentasyonu**: VIP, Düzenli, Yeni kategorileriyle gelişmiş RFM analizi
- ✅ **Zaman Serisi Analizi**: Büyüme metrikleriyle yıllık ve aylık trend analizi
- ✅ **Performans KPI'ları**: Hızlı raporlama için önceden hesaplanmış metrikler
- ✅ **Ürün Analitikleri**: Kategori bazlı performans ve karlılık analizi
- ✅ **Ölçeklenebilir Tasarım**: Kurumsal seviye veri hacimleri için hazır
- ✅ **Raporlama Görünümleri**: Anında içgörüler için önceden oluşturulmuş analitik görünümler

## 🔧 Teknik Özellikler

- **Veritabanı**: Microsoft SQL Server 2019+
- **Mimari**: Altın Katman Veri Ambarı
- **Dil**: T-SQL
- **Veri Formatı**: CSV, SQL Server Backup (.bak)
- **Veri Hacmi**: 18,485 müşteri, 296 ürün, 60,398 satış kaydı
- **Analiz Türleri**: 7 kapsamlı analitik yaklaşım
- **Performans**: Önceden hesaplanmış metriklerle optimize edilmiş sorgular

## 📝 Kullanım Örnekleri

### Müşteri Segmentasyon Analizi
```sql
SELECT 
    customer_segment,
    COUNT(*) as customer_count,
    SUM(total_sales) as total_revenue,
    AVG(average_order_value) as average_order_value
FROM gold.report_customers
GROUP BY customer_segment
ORDER BY total_revenue DESC;
```

### Yıllık Satış Trendleri
```sql
SELECT 
    YEAR(order_date) as year,
    SUM(sales_amount) as total_sales,
    COUNT(DISTINCT customer_key) as unique_customers,
    COUNT(DISTINCT product_key) as unique_products
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY year;
```

### Ürün Performans Analizi
```sql
SELECT 
    category,
    subcategory,
    COUNT(*) as product_count,
    SUM(total_sales) as category_revenue,
    AVG(price) as avg_price
FROM gold.report_products
GROUP BY category, subcategory
ORDER BY category_revenue DESC;
```

### Müşteri Yaşam Boyu Değer Analizi
```sql
SELECT 
    age_group,
    customer_segment,
    COUNT(*) as customer_count,
    AVG(total_sales) as avg_lifetime_value,
    AVG(lifespan) as avg_customer_lifespan
FROM gold.report_customers
GROUP BY age_group, customer_segment
ORDER BY avg_lifetime_value DESC;
```

## 📄 Lisans

Bu proje MIT Lisansı altında lisanslanmıştır - detaylar için `LICENSE` dosyasına bakın.

## 📞 İletişim

Bu proje hakkında sorularınız için lütfen bir issue açın veya bakımcılarla iletişime geçin.

**Geliştirici:** Berkay Akparlar  
**E-posta:** bakparlarr@gmail.com  
**LinkedIn:** [https://www.linkedin.com/in/berkay-akparlar/](https://www.linkedin.com/in/berkay-akparlar/)


## 🌐 Dil / Language

- 🇹🇷 [Türkçe](README-TR.md) - Mevcut dil
- 🇺🇸 [English](README.md) - English version