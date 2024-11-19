-- Create the customers table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,          -- Auto-incrementing primary key
    name VARCHAR(255) NOT NULL,     -- Customer name
    contact_info VARCHAR(255)       -- Optional contact information
);

-- Create the electricians table
CREATE TABLE electricians (
    id SERIAL PRIMARY KEY,          -- Auto-incrementing primary key
    name VARCHAR(255) NOT NULL,     -- Electrician name
    contact_info VARCHAR(255)       -- Optional contact information
);

-- Create the projects table
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,                 -- Auto-incrementing primary key
    name VARCHAR(255) NOT NULL,            -- Project name
    address TEXT NOT NULL,                 -- Project address
    wws_pm VARCHAR(255),                  -- Optional project manager name
    completion_date DATE,                  -- Optional completion date
    status VARCHAR(50) NOT NULL,           -- Status (e.g., In Progress, Completed)
    electrician_id INT REFERENCES electricians(id) ON DELETE SET NULL, -- Foreign key to electricians
    customer_id INT REFERENCES customers(id) ON DELETE SET NULL        -- Foreign key to customers
);