import React, { useContext, useEffect } from 'react';
import { UserContext } from '../UserContext';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

const LogoutPage = () => {
  const { setUsername, setLoggedIn } = useContext(UserContext);
  const navigate = useNavigate();

  useEffect(() => {
    setUsername('');
    setLoggedIn(false);

    axios.get('http://localhost:1235/api/logout');

    navigate('/login');
  }, [navigate, setUsername, setLoggedIn]);

  return null;
}
export default LogoutPage;
