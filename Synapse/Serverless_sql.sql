 
 -- load CSV files
 SELECT *
 FROM
     OPENROWSET(
         BULK 'csv/*.csv',
         DATA_SOURCE = 'sales_data',
         FORMAT = 'CSV',
         PARSER_VERSION = '2.0'
     ) AS orders



-- Load Parquet files
 SELECT *
 FROM  
     OPENROWSET(
         BULK 'parquet/year=*/*.snappy.parquet',
         DATA_SOURCE = 'sales_data',
         FORMAT='PARQUET'
     ) AS orders
 WHERE orders.filepath(1) = '2019'



 --Create Extenral tables/ file formats
  CREATE EXTERNAL FILE FORMAT CsvFormat
     WITH (
         FORMAT_TYPE = DELIMITEDTEXT,
         FORMAT_OPTIONS(
         FIELD_TERMINATOR = ',',
         STRING_DELIMITER = '"'
         )
     );
 GO;

 CREATE EXTERNAL TABLE dbo.orders
 (
     SalesOrderNumber VARCHAR(10),
     SalesOrderLineNumber INT,
     OrderDate DATE,
     CustomerName VARCHAR(25),
     EmailAddress VARCHAR(50),
     Item VARCHAR(30),
     Quantity INT,
     UnitPrice DECIMAL(18,2),
     TaxAmount DECIMAL (18,2)
 )
 WITH
 (
     DATA_SOURCE =sales_data,
     LOCATION = 'csv/*.csv',
     FILE_FORMAT = CsvFormat
 );
 GO
