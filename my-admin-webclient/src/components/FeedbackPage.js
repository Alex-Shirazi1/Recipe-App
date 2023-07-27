import React, {useContext, useState, useEffect } from "react";
import { UserContext } from "../UserContext";
import api from "../api";

const FeedbackPage = () => {
    const { username } = useContext(UserContext);
    const [feedbackPosts, setFeedbackPosts] = useState([]);

    useEffect(() => {
        if (username) {
            api.get('/api/getFeedback')
            .then((response) => {
                setFeedbackPosts(response.data);
            });
        }
    }, [username]);

    const handleDelete = (id) => {
        api.delete(`/api/deleteFeedback/${id}`)
        .then(() => {
            api.get('/api/getFeedback')
            .then((response) => {
                setFeedbackPosts(response.data);
            });
        });
    };

    return (
        <div>
          <h1 id="feedback-title">Feedback</h1>
          {!username && <p>Please login to see our user feedback!</p>}
          {username && 
            <div className="feedback-grid">
              {feedbackPosts.map((feedbackPost) => (
                <div className="feedback-card" key={feedbackPost._id}>
                  <h2>{feedbackPost.recommend ? '👍' : '👎'}</h2>
                  <p>{feedbackPost.comments}</p>
                  <button className="delete-button" onClick={() => handleDelete(feedbackPost._id)}>Delete</button>
                </div>
              ))}
            </div>
          }
        </div>
      );
};

export default FeedbackPage;
