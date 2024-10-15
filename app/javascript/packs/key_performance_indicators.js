import React from 'react';
import ReactDOM from 'react-dom';
import KeyPerformanceIndicators from '../components/Dashboard/KeyPerformanceIndicators/KeyPerformanceIndicators';

const getCSRFToken = () => {
  return document.querySelector('meta[name="csrf-token"]').getAttribute('content');
};

const fetchData = async (url) => {
  try {
    const response = await fetch(url, {
      headers: {
        'X-CSRF-Token': getCSRFToken(),
        'Content-Type': 'application/json'
      },
      credentials: 'same-origin' // Ensure cookies are sent with the request
    });
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    console.log('Fetched data:', data); // Log the fetched data
    return data;
  } catch (error) {
    console.log(url);
    console.error('Error fetching data:', error);
    return null;
  }
};

const transformData = (data) => {
  return data.map(item => ({
    name: item.name,
    data: item.data
  }));
};

document.addEventListener('DOMContentLoaded', async () => {
  const element = document.getElementById('KeyPerformanceIndicatorsComponent');
  if (element) {
    const lineGraphDataUrl = `/admin/products_analytics/line_graph_data?type=revenue`;
    const multipleMetricsUrl = `/admin/products_analytics/calculate_multiple_finance_line_graph_metrics`;

    const [lineGraphData, multipleMetrics] = await Promise.all([
      fetchData(lineGraphDataUrl),
      fetchData(multipleMetricsUrl),
    ]);

    if (lineGraphData && multipleMetrics) {
      const transformedMultipleMetrics = transformData(multipleMetrics.line_graph_data);
      const props = {
        line_graph_data: lineGraphData.display_data,
        display_data: transformedMultipleMetrics,
      };
      ReactDOM.render(<KeyPerformanceIndicators {...props} />, element);
    }
  } else {
    console.log('Element not found');
  }
});