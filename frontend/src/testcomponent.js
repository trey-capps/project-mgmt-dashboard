import React, { useState } from 'react';

const AddProject = () => {
  // State for form data
  const [project, setProject] = useState({
    name: '',
    description: '',
    start_date: '',
    end_date: '',
    budget: 0,
  });

  // State for success or error message
  const [message, setMessage] = useState('');

  // Handle input change
  const handleChange = (e) => {
    const { name, value } = e.target;
    setProject({ ...project, [name]: value });
  };

  // Submit the form data
  const handleSubmit = async (e) => {
    e.preventDefault(); // Prevent default form submission

    try {
      const response = await fetch('http://localhost:3001/api/projects', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(project),
      });

      if (response.ok) {
        const result = await response.json();
        setMessage(`Project added successfully: ${result.name}`);
        // Clear form fields
        setProject({ name: '', description: '', start_date: '', end_date: '', budget: 0 });
      } else {
        const error = await response.json();
        setMessage(`Error: ${error.error}`);
      }
    } catch (error) {
      setMessage(`Error: ${error.message}`);
    }
  };

  return (
    <div>
      <h2>Add New Project</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label>Project Name:</label>
          <input
            type="text"
            name="name"
            value={project.name}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Description:</label>
          <textarea
            name="description"
            value={project.description}
            onChange={handleChange}
          />
        </div>
        <div>
          <label>Start Date:</label>
          <input
            type="date"
            name="start_date"
            value={project.start_date}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>End Date:</label>
          <input
            type="date"
            name="end_date"
            value={project.end_date}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Budget:</label>
          <input
            type="number"
            name="budget"
            value={project.budget}
            onChange={handleChange}
            required
          />
        </div>
        <button type="submit">Add Project</button>
      </form>
      {message && <p>{message}</p>}
    </div>
  );
};

export default AddProject;