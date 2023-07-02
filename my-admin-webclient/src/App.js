import React from 'react';
import { BrowserRouter as Router, Route, Routes, Link } from 'react-router-dom';
import LoginPage from './components/LoginPage';

const App = () => {
  return (
    <Router>
      <div>
        <nav>
          <Link to="/login">Login</Link>
        </nav>

        <Routes>
          <Route path="/login" element={<LoginPage />} />
        </Routes>
      </div>
    </Router>
  );
};

export default App;
