const pool = require('../config/db');

// Fetch all projects
const getAllProjects = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM projects');
    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch projects' });
  }
};

// Create a new project
const createProject = async (req, res) => {
  const { name, description, start_date, end_date, budget } = req.body;

  try {
    const result = await pool.query(
      'INSERT INTO projects (name, description, start_date, end_date, budget) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [name, description, start_date, end_date, budget]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to create project' });
  }
};

// Update a project
const updateProject = async (req, res) => {
  const { id } = req.params;
  const { name, description, start_date, end_date, budget } = req.body;

  try {
    const result = await pool.query(
      'UPDATE projects SET name = $1, description = $2, start_date = $3, end_date = $4, budget = $5 WHERE id = $6 RETURNING *',
      [name, description, start_date, end_date, budget, id]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Project not found' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to update project' });
  }
};

// Delete a project
const deleteProject = async (req, res) => {
  const { id } = req.params;

  try {
    const result = await pool.query('DELETE FROM projects WHERE id = $1 RETURNING *', [id]);
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Project not found' });
    }
    res.sendStatus(204);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to delete project' });
  }
};

module.exports = {
  getAllProjects,
  createProject,
  updateProject,
  deleteProject,
};