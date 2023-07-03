import React, { useState } from 'react';
import axios from 'axios';

const LoginPage = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const handleUsernameChange = (e) => {
    setUsername(e.target.value);
  };

  const handlePasswordChange = (e) => {
    setPassword(e.target.value);
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    axios.post('http://localhost:1235/api/login', { username, password })
      .then((response) => {
        // Handle the response
        const { loggedIn } = response.data;

        if (loggedIn) {
            console.log("loggedin")

        } else {
          // Handle failed login
          alert('Access Denied');
        }
      })
      .catch((error) => {
        // Handle the error
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
          <input type="text" value={username} onChange={handleUsernameChange} />
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
