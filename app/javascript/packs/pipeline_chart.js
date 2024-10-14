import React from 'react';
import ReactDOM from 'react-dom';
import PipelineChart from '../components/Dashboard/PipelineChart/PipelineChart';

document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById('PipelineChartComponent');
  const props = JSON.parse(element.getAttribute('data-props'));
  ReactDOM.render(<PipelineChart {...props} />, element);
});
