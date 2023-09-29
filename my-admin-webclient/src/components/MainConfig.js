import React, { useState, useEffect } from 'react';
import axios from 'axios';
import '../App.css';

const API_URL = 'http://localhost:1235/api/config';

const MainConfig = () => {
  const [version, setVersion] = useState("");
  const [edit, setEdit] = useState(false);

  useEffect(() => {
    axios.get(API_URL).then((response) => {
      setVersion(response.data.version);
    });
  }, []);

  const handleEdit = () => setEdit(true);

  const handleCancel = () => {
    setEdit(false);
    axios.get(API_URL).then((response) => {
      setVersion(response.data.version);
    });
  };

  const handleDone = () => {
    axios.post(API_URL, { version }).then(() => {
      setEdit(false);
    });
  };

  return (
    <div className="form-container">
      <h2 className="form-title">Main Config</h2>
      <form>
        <label>Version</label>
        <input className="form-input" type="text" value={version} disabled={!edit} onChange={e => setVersion(e.target.value)} />
        {edit ? (
          <div>
            <button className="delete-button" onClick={handleCancel}>Cancel</button>
            <button className="form-button" onSubmit={handleDone}>Done</button>
          </div>
        ) : (
          <button className="form-button" onClick={handleEdit}>Edit</button>
        )}
      </form>
    </div>
  );
};

export default MainConfig;
