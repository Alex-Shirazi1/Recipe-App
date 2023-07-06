import React, { useState } from 'react';
import { BrowserRouter as Router, Route, Routes, Link } from 'react-router-dom';
import { UserContext } from './UserContext';
import LoginPage from './components/LoginPage';
import HomePage from './components/HomePage';
import RegisterPage from './components/RegisterPage';

const App = () => {
  const [username, setUsername] = useState(null);

  return (
    <UserContext.Provider value={{ username, setUsername }}>
      <Router>
        <div>
          <nav>
            <Link to="/login">Login</Link>
            <Link to="/home">Home</Link>
            <Link to="/register">Register</Link>
          </nav>

          <Routes>
            <Route path ="/register" element={<RegisterPage />}/>
            <Route path="/login" element={<LoginPage />} />
            <Route path="/home" element={<HomePage />} />
          </Routes>
        </div>
      </Router>
    </UserContext.Provider>
  );
};

export default App;
