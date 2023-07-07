import React, { useState } from 'react';
import { BrowserRouter as Router, Route, Routes, Link } from 'react-router-dom';
import { UserContext } from './UserContext';
import LoginPage from './components/LoginPage';
import LogoutPage from './components/LogoutPage';
import HomePage from './components/HomePage';
import RegisterPage from './components/RegisterPage';
import Notifications from './components/Notifications';

const App = () => {
  const [username, setUsername] = useState(null);
  const [loggedIn, setLoggedIn] = useState(false);

  return (
    <UserContext.Provider value={{ username, setUsername, loggedIn, setLoggedIn }}>
      <Router>
        <div>
          <nav>
            <Link to="/">Home</Link>
            <Link to="/register">Register</Link>
           {loggedIn ? (
              <>
                <Link to="/logout">Logout</Link>
                <Notifications />
              </>
            ) : (
              <Link to="/login">Login</Link>
            )}
          </nav>

          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path ="/register" element={<RegisterPage />}/>
            <Route path="/login" element={<LoginPage />} />
            <Route path="/logout" element={<LogoutPage />} />
          </Routes>
        </div>
      </Router>
    </UserContext.Provider>
  );
};

export default App;
