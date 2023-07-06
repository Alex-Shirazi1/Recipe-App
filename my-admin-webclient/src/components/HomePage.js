import React, { useContext, useEffect } from 'react';
import axios from 'axios';
import { UserContext } from '../UserContext';
import '../App.css';

const HomePage = () => {
  const { username, setUsername } = useContext(UserContext);

  useEffect(() => {
    axios.get('http://localhost:1235/api/session')
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
