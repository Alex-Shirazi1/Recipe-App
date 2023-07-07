import React, { useContext, useEffect } from 'react';
import { UserContext } from '../UserContext';
import { useNavigate } from 'react-router-dom';
import api from '../api';

const LogoutPage = () => {
  const { setUsername, setLoggedIn } = useContext(UserContext);
  const navigate = useNavigate();

  useEffect(() => {
    setUsername('');
    setLoggedIn(false);

    api.get('/api/logout');

    navigate('/login');
  }, [navigate, setUsername, setLoggedIn]);

  return null;
}
export default LogoutPage;
