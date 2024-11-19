CREATE TABLE electricians (
    electrician_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255)
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    wws_pm VARCHAR(255),
    completion_date DATE,
    status VARCHAR(50),
    electrician_id INT REFERENCES electricians(electrician_id),
    customer_id INT REFERENCES customers(customer_id)
);

CREATE TABLE contracts (
    contract_id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(project_id),
    contract_value DECIMAL,
    contract_ind BOOLEAN
);