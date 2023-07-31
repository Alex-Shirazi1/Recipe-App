import React, { useState } from 'react';
import '../App.css';
import api from '../api';

const RegisterPage = () => {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [errorMessage, setErrorMessage] = useState('');
  const [usernameError, setUsernameError] = useState('');
  const [emailError, setEmailError] = useState('');
  const [passwordError, setPasswordError] = useState('');
  const [confirmPasswordError, setConfirmPasswordError] = useState('');
  const [isLoading, setIsLoading] = useState(false); 

  const handleRegister = async (e) => {
    e.preventDefault();
    
    if (!validateInputs() || isLoading) {
      return;
    }

      setIsLoading(true);

    try {
      await api.post('/api/register', {
        username,
        email,
        password,
        isAdmin: true
      });
      alert('Registration successful!');
    } catch (err) {
      setErrorMessage('Error occurred while registering');
    } finally {
      setIsLoading(false);
      setUsername('');
      setEmail('');
      setPassword('');
      setConfirmPassword('');
    }
  };

  const validateInputs = () => {
    let isValid = true;
    if (username.length == 0) {
      setUsernameError('Must input Username');
      isValid = false
    } else if (username.length < 4 || username.length > 20) {
      setUsernameError('Username must be between 4 and 20 characters');
      isValid = false;
    } else {
      setUsernameError('');
    }
    
    if (email.length < 4) {
      setEmailError('Must input valid Email');
      isValid = false
    } else {
      setEmailError('');
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
      {isLoading ? (
        <p>Loading...</p>  // This can be replaced by a custom loading animation
      ) : (
        <form onSubmit={handleRegister}>
          <input type="text" placeholder="Username" value={username} onChange={(e) => setUsername(e.target.value)} />
          {usernameError && <p className="error-message">{usernameError}</p>}
          <br />
          <input type="text" placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} />
          {emailError && <p className="error-message">{emailError}</p>}
          <br />
          <input type="password" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} />
          {passwordError && <p className="error-message">{passwordError}</p>}
          <br />
          <input type="password" placeholder="Confirm Password" value={confirmPassword} onChange={(e) => setConfirmPassword(e.target.value)} />
          {confirmPasswordError && <p className="error-message">{confirmPasswordError}</p>}
          <br />
          <button type="submit" disabled={isLoading}>Register</button>
        </form>
      )}
      {errorMessage && <p className="error-message">{errorMessage}</p>}
    </div>
  );
}
export default RegisterPage;
