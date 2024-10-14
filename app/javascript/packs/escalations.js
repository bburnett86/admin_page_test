import React from 'react';
import ReactDOM from 'react-dom';
import Escalations from '../components/Dashboard/Escalations/Escalations';

document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById('EscalationsComponent');
  const props = JSON.parse(element.getAttribute('data-props'));
  ReactDOM.render(<Escalations {...props} />, element);
});
