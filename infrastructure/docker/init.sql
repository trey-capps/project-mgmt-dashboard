CREATE TABLE projects (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  budget NUMERIC(12, 2) NOT NULL
);

INSERT INTO projects (name, description, start_date, end_date, budget)
VALUES ('Sample Project', 'A sample project for development', '2024-11-16', '2024-12-01', 10000);