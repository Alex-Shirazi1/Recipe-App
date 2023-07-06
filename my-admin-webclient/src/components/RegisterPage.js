import React, { useState } from 'react';
import axios from 'axios';
import '../App.css';

const RegisterPage = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [errorMessage, setErrorMessage] = useState('');
  const [usernameError, setUsernameError] = useState('');
  const [passwordError, setPasswordError] = useState('');
  const [confirmPasswordError, setConfirmPasswordError] = useState('');

  const handleRegister = async (e) => {
    e.preventDefault();
    
    if (!validateInputs()) {
      return;
    }

    try {
      await axios.post('http://localhost:1235/api/register', {
        username,
        password,
      });
      alert('Registration successful!');
    } catch (err) {
      setErrorMessage('Error occurred while registering');
    }
  };

  const validateInputs = () => {
    let isValid = true;

    if (username.length < 4 || username.length > 20) {
      setUsernameError('Username must be between 4 and 20 characters');
      isValid = false;
    } else {
      setUsernameError('');
    }

    if (password.length < 4) {
      setPasswordError('Password must be at least 4 characters');
      isValid = false;
    } else {
      setPasswordError('');
    }

    if (password !== confirmPassword) {
      setConfirmPasswordError('Passwords do not match');
      isValid = false;
    } else {
      setConfirmPasswordError('');
    }

    return isValid;
  }

  return (
    <div className="form-container">
      <h2 className="form-title">Register</h2>
      <form onSubmit={handleRegister}>
        <input type="text" placeholder="Username" value={username} onChange={(e) => setUsername(e.target.value)} />
        {usernameError && <p className="error-message">{usernameError}</p>}
        <br />
        <input type="password" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} />
        {passwordError && <p className="error-message">{passwordError}</p>}
        <br />
        <input type="password" placeholder="Confirm Password" value={confirmPassword} onChange={(e) => setConfirmPassword(e.target.value)} />
        {confirmPasswordError && <p className="error-message">{confirmPasswordError}</p>}
        <br />
        <button type="submit">Register</button>
      </form>
      {errorMessage && <p className="error-message">{errorMessage}</p>}
    </div>
  );
}

export default RegisterPage;
