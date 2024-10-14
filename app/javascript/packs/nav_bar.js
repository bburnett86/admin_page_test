import React from 'react';
import ReactDOM from 'react-dom';
import NavBar from '../components/Dashboard/NavBar/NavBar';

document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById('NavBarComponent');
  const props = JSON.parse(element.getAttribute('data-props'));
  ReactDOM.render(<NavBar {...props} />, element);
});
