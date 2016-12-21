
DROP TABLE IF EXISTS receipts;
DROP TABLE IF EXISTS basket;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

CREATE TABLE customers (
  id SERIAL4 primary key,
  name VARCHAR(255),
  address_line_1 VARCHAR(255),
  address_line_2 VARCHAR(255),
  postcode VARCHAR(255),
  funds REAL,
  email VARCHAR(255)
);

CREATE TABLE products (
  id SERIAL4 primary key,
  specie VARCHAR(255),
  latin_name VARCHAR(255),
  image VARCHAR(255),
  price REAL,
  quantity INT4,
  comments TEXT
);


CREATE TABLE receipts (
  id SERIAL4 primary key,
  customer_id INT4 references customers(id) ON DELETE CASCADE,
  product_id INT4 references products(id) ON DELETE CASCADE,
  purchase_type VARCHAR(255),
  Purchase_time text,
  delivery_type VARCHAR(255)
);

CREATE TABLE basket (
  id SERIAL4 primary key,
  customer_id INT4 references customers(id) ON DELETE CASCADE,
  specie VARCHAR(255),
  price REAL,
  quantity INT4
)