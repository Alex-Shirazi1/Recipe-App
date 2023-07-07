import React, { useContext, useEffect } from 'react';
import { UserContext } from '../UserContext';
import '../App.css';
import api from '../api';

const HomePage = () => {
  const { username, setUsername } = useContext(UserContext);

  useEffect(() => {
    api.get('/api/session')
    .then((response) => {
      const { loggedIn, username } = response.data;

      if (loggedIn) {
        setUsername(username);
      }
    });
  }, []);

  return (
    <div>
      <h1>Welcome, {username || 'Guest'}!</h1>
      {!username && <p>Please login.</p>}
    </div>
  );
};

export default HomePage;
