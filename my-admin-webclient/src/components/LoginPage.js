import React, { useState, useContext } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import { UserContext } from '../UserContext';
import '../App.css';

const LoginPage = () => {
  const [usernameInput, setUsernameInput] = useState('');
  const [password, setPassword] = useState('');
  const { setUsername } = useContext(UserContext);
  const navigate = useNavigate();

  const handleUsernameChange = (e) => {
    setUsernameInput(e.target.value);
  };

  const handlePasswordChange = (e) => {
    setPassword(e.target.value);
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    axios.post('http://localhost:1235/api/login', { username: usernameInput, password })
      .then((response) => {
        const { loggedIn } = response.data;

        if (loggedIn) {
            setUsername(usernameInput);
            navigate('/home');
          alert('Access Denied');
        }
      })
      .catch((error) => {
        console.error('Login failed:', error);
        alert('An error occurred during login');
      });
  };

  return (
    <div>
      <h1>Login With Administrator Credentials</h1>
      <form onSubmit={handleSubmit}>
        <label>
          Username:
          <input type="text" value={usernameInput} onChange={handleUsernameChange} />
        </label>
        <br />
        <label>
          Password:
          <input type="password" value={password} onChange={handlePasswordChange} />
        </label>
        <br />
        <button type="submit">Login</button>
      </form>
    </div>
  );
};

export default LoginPage;
