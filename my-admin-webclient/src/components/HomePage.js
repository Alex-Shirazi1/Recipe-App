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

  const handleDelete = (id) => {
    console.log("LOL " + id)
    api.delete(`/api/deletePost/${id}`)
    .then(() => {
        // Refresh posts after deleting
        api.get('/api/posts')
        .then((response) => {
            setPosts(response.data);
        });
    });
};

  return (
<div>
  <h1 id="home-title">Welcome, {username || 'Guest'}!</h1>
  {!username && <p>Please login.</p>}
  {username && 
    <div className="post-grid">
      {posts.map((post) => (
        <div className="post-card" key={post._id}>
          <img src={`/api/image/${post.imageFileId}`} alt="post" />
          <h2>{post.title}</h2>
          <button className="delete-button" onClick={() => handleDelete(post._id)}>Delete</button>
        </div>
      ))}
    </div>
  }
</div>

  );
};

export default HomePage;
