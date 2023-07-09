import React, { useContext, useEffect, useState } from 'react';
import { UserContext } from '../UserContext';
import '../App.css';
import api from '../api';

const Notifications = () => {
  const { username } = useContext(UserContext);
  const [notifications, setNotifications] = useState([]);

  useEffect(() => {
    fetchNotifications();
  }, [username]);

  const fetchNotifications = () => {
    if (username) {
      api.get(`/api/notifications/${username}`, { withCredentials: true })
      .then((response) => {
        if(Array.isArray(response.data)) {
          setNotifications(response.data);
        } else if (response.data === "No notifications for user") {
          setNotifications([]);
        } else {
          console.error('Received unexpected data:', response.data);
        }
      })
      .catch((error) => {
        console.error('Notification retrieval failed:', error);
      });
    }
  }

  const handleApprove = (userRequest) => {
    console.log(JSON.stringify(userRequest))
    api.post('/api/user', userRequest)
    .then(() => 
     api.delete(`/api/notifications/${userRequest.username}`))
    .then(() => fetchNotifications())
    .catch(error => console.error('Approval failed:', error));
  }

const handleDisapprove = (userRequest) => {
    api.post('/api/userDecline', userRequest) 
    .then(() => api.delete(`/api/notifications/${userRequest.username}`))
    .then(() => fetchNotifications())
    .catch(error => console.error('Disapproval failed:', error));
  }


  return (
    <div className="notifications">
      <span className="bell-icon">🔔🔔🔔</span>
      {notifications.length > 0 && <span className="notification-count">{notifications.length}</span>}
      {notifications.length > 0 &&
        <div className="notifications-list">
          {notifications.map((notification, index) => (
            <div className="notification-item" key={index}>
              {notification.username} has requested for a new registration
              <button onClick={() => handleApprove(notification)}>✅</button>
              <button onClick={() => handleDisapprove(notification)}>❌</button>
            </div>
          ))}
        </div>
      }
    </div>
  );
};

export default Notifications;
