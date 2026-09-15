SELECT current_role();

SELECT current_user();

-- Create the Ice Cream database
CREATE DATABASE IF NOT EXISTS ice_cream_db;

-- Create a table for ice cream flavors
CREATE TABLE flavors (
    flavor_id INT AUTOINCREMENT,
    flavor_name STRING,
    price DECIMAL(5, 2),
    PRIMARY KEY (flavor_id)
);

-- Create a table for customers
CREATE TABLE customers (
    customer_id INT AUTOINCREMENT,
    customer_name STRING,
    email STRING,
    PRIMARY KEY (customer_id)
);

-- Create a table for transactions
CREATE TABLE transactions (
    transaction_id INT AUTOINCREMENT,
    customer_id INT,
    flavor_id INT,
    quantity INT,
    transaction_date TIMESTAMP,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    FOREIGN KEY (flavor_id) REFERENCES flavors (flavor_id)
);