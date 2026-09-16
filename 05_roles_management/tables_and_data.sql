-- select which role you want/need to use
USE ROLE ice_cream_writer;

-- select the warehouse and db that the user has access to 
USE WAREHOUSE dev_wh;
USE SCHEMA ice_cream_db.public;

DROP TABLE flavors;
DROP TABLE customers;
DROP TABLE transactions;

-- CREATE TABLES 
CREATE TABLE IF NOT EXISTS flavors (
    flavor_id INT AUTOINCREMENT,
    flavor_name STRING,
    price DECIMAL(5, 2),
    PRIMARY KEY (flavor_id)
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTOINCREMENT,
    customer_name STRING,
    email STRING,
    PRIMARY KEY (customer_id)
);

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INT AUTOINCREMENT,
    customer_id INT,
    flavor_id INT,
    quantity INT,
    transaction_date TIMESTAMP,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    FOREIGN KEY (flavor_id) REFERENCES flavors (flavor_id)
);

-- Step 5: Insert sample data
INSERT INTO flavors (flavor_name, price) VALUES
('Vanilla', 2.50),
('Chocolate', 2.75),
('Strawberry', 2.50),
('Mint Chocolate Chip', 3.00),
('Cookie Dough', 3.25);

INSERT INTO customers (customer_name, email) VALUES
('John Doe', 'john.doe@example.com'),
('Jane Smith', 'jane.smith@example.com'),
('Alice Johnson', 'alice.johnson@example.com');

INSERT INTO transactions (
    customer_id, flavor_id, quantity, transaction_date
) VALUES
(1, 1, 2, CURRENT_TIMESTAMP),
(2, 2, 1, CURRENT_TIMESTAMP),
(3, 3, 3, CURRENT_TIMESTAMP),
(1, 4, 1, CURRENT_TIMESTAMP),
(2, 5, 2, CURRENT_TIMESTAMP);

SELECT * FROM flavors;

USE ROLE ice_cream_reader;

SELECT * FROM customers;

-- if this works - check out box "Use secondary roles" under snowflake in vsc
-- should not work in reader
INSERT INTO customers (customer_name, email) VALUES
('John Doe2', 'john.doe2@example.com');

SELECT CURRENT_SECONDARY_ROLES();

SELECT * FROM transactions;