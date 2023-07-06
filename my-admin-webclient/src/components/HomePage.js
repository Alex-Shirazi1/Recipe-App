import React, { useContext } from 'react';
import { UserContext } from '../UserContext';

const HomePage = () => {
  const { username } = useContext(UserContext);

  return (
    <div>
      <h1>Welcome, {username}!</h1>
     
    </div>
  );
};

export default HomePage;
