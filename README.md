# 📊 SQL Data Analytics Project

A comprehensive SQL data analytics project designed for business intelligence and data-driven decision making. This project includes advanced SQL queries, data warehouse architecture, and analytical reports for customer behavior analysis, product performance evaluation, and sales trend analysis.

## 🎯 Project Overview

This data analytics project provides a complete solution for analyzing business data using SQL Server. It implements a modern data warehouse architecture with bronze, silver, and gold layers, featuring customer segmentation, product analysis, sales performance metrics, and time-series trend analysis.

## 🏗️ Project Structure

```
SQL Data Analytics/
├── 📁 datasets/
│   ├── 📁 csv-files/
│   │   ├── 🥇 Gold Layer (Analytical Data)
│   │   │   ├── gold.dim_customers.csv (18,485 customers)
│   │   │   ├── gold.dim_products.csv (296 products)
│   │   │   ├── gold.fact_sales.csv (60,398 sales records)
│   │   │   ├── gold.report_customers.csv (Customer analytics)
│   │   │   └── gold.report_products.csv (Product analytics)
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

## 🚀 Installation and Usage

### Prerequisites
- Microsoft SQL Server 2019 or later
- SQL Server Management Studio (SSMS) or Azure Data Studio
- Windows/Linux environment with SQL Server support

### Installation Steps

1. **Create Database**
   ```sql
   -- Run the initialization script
   EXEC scripts/00_init_database.sql
   ```

2. **Data Overview**
   - **Gold Layer**: Pre-processed analytical data ready for reporting
   - **Customer Data**: 18,485 unique customers with demographic information
   - **Product Data**: 296 products across multiple categories
   - **Sales Data**: 60,398 sales transactions spanning multiple years

3. **Run Analysis Queries**
   ```sql
   -- Time-series analysis
   EXEC scripts/01_changes_over_time_analysis.sql
   
   -- Customer analytics
   EXEC scripts/06_customer_report.sql
   
   -- Product performance
   EXEC scripts/07_product_reports.sql
   ```

## 📈 Analysis Types

### 1. ⏰ Time-Series Analysis (`01_changes_over_time_analysis.sql`)
- Annual sales trends and patterns
- Monthly performance analysis
- Customer growth metrics
- Quantity-based trend analysis
- Revenue progression over time

### 2. 📊 Cumulative Analysis (`02_cumulative_analysis.sql`)
- Running totals and cumulative metrics
- Growth rate calculations
- Progressive performance tracking
- Trend analysis with moving averages

### 3. 🎯 Performance Analysis (`03_performance_analysis.sql`)
- Key Performance Indicators (KPIs)
- Performance benchmarking
- Comparative analysis across periods
- Efficiency metrics calculation

### 4. 🔍 Part-to-Whole Analysis (`04_part_to_whole_analysis.sql`)
- Category distribution analysis
- Market share calculations
- Segment contribution analysis
- Percentage breakdowns

### 5. 👥 Data Segmentation (`05_data_segmentation.sql`)
- Customer segmentation strategies
- Product categorization
- Behavioral grouping analysis
- Demographic segmentation

### 6. 👤 Customer Analytics (`06_customer_report.sql`)
- Customer profiling and demographics
- Age group analysis
- VIP customer identification
- Customer lifetime value (CLV)
- Recency, Frequency, Monetary (RFM) analysis
- Customer segmentation (VIP, Regular, New)

### 7. 🛍️ Product Analytics (`07_product_reports.sql`)
- Product performance metrics
- Category-based sales analysis
- Best-selling products identification
- Product profitability analysis
- Market performance evaluation

## 🎨 Data Warehouse Architecture

### Gold Schema Tables

#### `dim_customers` (Customer Dimension Table)
- **Records**: 18,485 customers
- **Key Fields**: customer_key, customer_id, customer_number, first_name, last_name
- **Demographics**: country, marital_status, gender, birthdate, create_date
- **Purpose**: Customer master data for analytics and reporting

#### `dim_products` (Product Dimension Table)
- **Records**: 296 products
- **Key Fields**: product_key, product_id, product_number, product_name
- **Categories**: category_id, category, subcategory, product_line
- **Financial**: cost, maintenance requirements
- **Purpose**: Product master data with hierarchical categorization

#### `fact_sales` (Sales Fact Table)
- **Records**: 60,398 sales transactions
- **Key Fields**: order_number, product_key, customer_key
- **Dates**: order_date, shipping_date, due_date
- **Metrics**: sales_amount, quantity, price
- **Purpose**: Core transactional data for all sales analysis

#### `report_customers` (Customer Analytics View)
- **Derived Metrics**: total_orders, total_sales, total_quantity, lifespan
- **Segmentation**: customer_segment (VIP, Regular, New), age_group
- **KPIs**: recency, avg_order_value, avg_monthly_spend
- **Purpose**: Pre-calculated customer analytics for reporting

#### `report_products` (Product Analytics View)
- **Performance Metrics**: total_orders, total_sales, total_quantity, total_customers
- **Segmentation**: product_segment (High-Performer, etc.)
- **Financial**: avg_selling_price, avg_order_revenue, avg_monthly_revenue
- **Purpose**: Pre-calculated product performance metrics

## 📊 Key Features

- ✅ **Modern Data Architecture**: Gold layer with optimized analytical tables
- ✅ **Comprehensive Analytics**: 7 different analysis types covering all business aspects
- ✅ **Customer Segmentation**: Advanced RFM analysis with VIP, Regular, New categories
- ✅ **Time-Series Analysis**: Yearly and monthly trend analysis with growth metrics
- ✅ **Performance KPIs**: Pre-calculated metrics for fast reporting
- ✅ **Product Analytics**: Category-based performance and profitability analysis
- ✅ **Scalable Design**: Ready for enterprise-level data volumes
- ✅ **Reporting Views**: Pre-built analytical views for immediate insights

## 🔧 Technical Specifications

- **Database**: Microsoft SQL Server 2019+
- **Architecture**: Gold Layer Data Warehouse
- **Language**: T-SQL
- **Data Format**: CSV, SQL Server Backup (.bak)
- **Data Volume**: 18,485 customers, 296 products, 60,398 sales records
- **Analysis Types**: 7 comprehensive analytical approaches
- **Performance**: Optimized queries with pre-calculated metrics

## 📝 Usage Examples

### Customer Segmentation Analysis
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

### Annual Sales Trends
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

### Product Performance Analysis
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

### Customer Lifetime Value Analysis
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

## 📄 License

This project is licensed under the MIT License - see the `LICENSE` file for details.

## 📞 Contact

For questions about this project, please open an issue or contact the maintainers.

**Developer:** Berkay Akparlar  
**Email:** bakparlarr@gmail.com  
**LinkedIn:** [https://www.linkedin.com/in/berkay-akparlar/](https://www.linkedin.com/in/berkay-akparlar/)


## 🌐 Language / Dil

- 🇺🇸 [English](README.md) - Current language
- 🇹🇷 [Türkçe](README-TR.md) - Turkish version
