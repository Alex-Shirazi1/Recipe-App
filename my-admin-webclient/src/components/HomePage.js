import React, { useContext, useState, useEffect } from 'react';
import { UserContext } from '../UserContext';
import '../App.css';
import api from '../api';

const HomePage = () => {
  const { username, setUsername } = useContext(UserContext);
  const [posts, setPosts] = useState([]);

  useEffect(() => {
    api.get('/api/session')
      .then((response) => {
        const { loggedIn, username } = response.data;
        if (loggedIn) {
          setUsername(username);
        }
      });

    api.get('/api/posts')
      .then((response) => {
        setPosts(response.data);
      });
  }, []);


  return (
    <div>
      <h1>Welcome, {username || 'Guest'}!</h1>
      {!username && <p>Please login.</p>}
      {username && posts.map((post) => (
        <div className="post-card" key={post.id}>
          <img src={post.image} alt="post" />
          <h2>{post.title}</h2>
          
        </div>
      ))}
    </div>
  );
};

export default HomePage;
