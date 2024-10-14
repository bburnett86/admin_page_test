import React from 'react';
import ReactDOM from 'react-dom';
import KeyPerformanceIndicators from '../components/Dashboard/KeyPerformanceIndicators/KeyPerformanceIndicators';

document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById('KeyPerformanceIndicatorsComponent');
  const props = JSON.parse(element.getAttribute('data-props'));
  ReactDOM.render(<KeyPerformanceIndicators {...props} />, element);
});
