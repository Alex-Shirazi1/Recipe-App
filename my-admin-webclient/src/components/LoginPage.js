import React, { useState, useContext } from 'react';
import { useNavigate } from 'react-router-dom';
import { UserContext } from '../UserContext';
import '../App.css';
import api from '../api';

const LoginPage = () => {
  const [usernameInput, setUsernameInput] = useState('');
  const [password, setPassword] = useState('');
  const { setUsername, setLoggedIn } = useContext(UserContext);
  const [loginError, setLoginError] = useState('');
  const navigate = useNavigate();

  const handleUsernameChange = (e) => {
    setUsernameInput(e.target.value);
  };

  const handlePasswordChange = (e) => {
    setPassword(e.target.value);
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    api.post('/api/login', { username: usernameInput, password })
      .then((response) => {
        const { loggedIn } = response.data;

        if (loggedIn) {
          setUsername(usernameInput);
          setLoggedIn(true);
          navigate('/'); 
        } else {
          setLoginError('Username/Password Incorrect');
        }
      })
      .catch((error) => {
        console.error('Login failed:', error);
        setLoginError('An error occurred during login');
      });
  };

  return (
    <div className="form-container">
      <h2 className="form-title">Login</h2>
      <form onSubmit={handleSubmit}>
        <input type="text" placeholder="Username" value={usernameInput} onChange={handleUsernameChange} />
        <br />
        <input type="password" placeholder="Password" value={password} onChange={handlePasswordChange} />
        <br />
        <button type="submit">Login</button>
      </form>
      {loginError && <p className="error-message">{loginError}</p>}
    </div>
  );
};

export default LoginPage;
