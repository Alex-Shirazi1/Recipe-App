import React, { useState, useContext } from 'react';
import { UserContext } from '../UserContext';
import api from '../api';

const CreatePost = () => {
    const { username } = useContext(UserContext);
    const [title, setTitle] = useState('');
    const [body, setBody] = useState('');
    const [image, setImage] = useState(null);

    const handleSubmit = (event) => {
        event.preventDefault();

        const formData = new FormData();
        formData.append('title', title);
        formData.append('body', body);
        formData.append('image', image);

        api.post('/api/createPost', formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        }).then(() => {
            setTitle('');
            setBody('');
            setImage(null);
            // TODO: handle response
        });
    };

    return (
        <form onSubmit={handleSubmit}>
            <input type="text" value={title} onChange={(e) => setTitle(e.target.value)} placeholder="Title" required />
            <textarea value={body} onChange={(e) => setBody(e.target.value)} placeholder="Body" required />
            <input type="file" onChange={(e) => setImage(e.target.files[0])} required />
            <button type="submit">Create Post</button>
        </form>
    );
};

export default CreatePost;
