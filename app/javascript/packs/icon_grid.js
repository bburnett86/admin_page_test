import React from 'react';
import ReactDOM from 'react-dom';
import IconGrid from '../components/Dashboard/IconGrid/IconGrid';

document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById('IconGridComponent');
  const props = JSON.parse(element.getAttribute('data-props'));
  ReactDOM.render(<IconGrid {...props} />, element);
});
