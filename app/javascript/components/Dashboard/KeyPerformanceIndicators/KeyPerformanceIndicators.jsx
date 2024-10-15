import React from 'react'
import "../../App.scss"
import WebpackerReact from 'webpacker-react'
import { LineGraph, Nav, NavItem, Layout, Body, Flex, FlexItem, SectionSeparator, Background, CircleIconButton, Title, StatChange } from 'playbook-ui'
import { useState, useEffect } from 'react'

const fetchData = async (type) => {
  try {
    const response = await fetch(`/admin/products_analytics/line_graph_data?type=${type}`);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    console.log(data["display_data"])
    return data["display_data"];
  } catch (error) {
    console.error('Error fetching data:', error);
    return [];
  }
};

const KeyPerformanceIndicators = ({ line_graph_data, display_data }) => {
  const [active, setActive] = useState("revenue")
  const [displayData, setDisplayData] = useState(line_graph_data)
  const xAxisCategories = display_data.x_axis_categories
  const [revenue, setRevenue] = useState({ percentage: 0, direction: "" });
  const [orders, setOrders] = useState({ percentage: 0, direction: "" });
  const [profit, setProfit] = useState({ percentage: 0, direction: "" });
  const [cancelled, setCancelled] = useState({ percentage: 0, direction: "" });
  const [repeatSales, setRepeatSales] = useState({ percentage: 0, direction: "" });
  

  const performance = () => {
    Object.values(display_data).forEach((value) => {
    const filteredData = value.data;
    const performanceValue = filteredData[filteredData.length - 1] - filteredData[filteredData.length - 2];
    var percentage = Math.round((performanceValue / filteredData[0]) * 100);
    percentage = percentage < 0 ? -percentage : percentage;
    const direction = performanceValue > 0 ? "increase" : "decrease";

    switch (value.name) {
      case 'revenue':
        setRevenue({ percentage, direction });
        break;
      case 'orders':
        setOrders({ percentage, direction });
        break;
      case 'profit':
        setProfit({ percentage, direction });
        break;
      case 'cancelled':
        setCancelled({ percentage, direction });
        break;
      case 'repeat_sales':
        setRepeatSales({ percentage, direction });
        break;
      default:
        break;
      }
    });
  };

  const handleSetActive = (value) => {
    if (["revenue", "orders", "profit", "average_check", "cancelled", "repeat_sales"].includes(value)) {
      setActive(value);
    }
  };

  const setData = (value) => {
    fetchData(value).then((data) => 
      setDisplayData({name: data["name"], data: data["data"]})
    );
  }
  
  useEffect(() => {
    setData(active);
  }, [active]);

  useEffect(() => {
    performance();
  }, [displayData]);

  
  return(
  <div>
    <Background
      backgroundColor="white"
      borderRadius="md"
    >
      <Layout
            layout="content"
            collapse="xs"
            position="left"
            size= "lg"
            display={{
              xs: "block",
              sm: "block",
              md: "block",
            }}
      >
        <Layout.Header
            flexDirection="column"
            justifyContent="space-between"
        >
          <Flex
            paddingX="sm"
            justify="between"
            paddingY="md"
          >
            <FlexItem>
              <Body
                size={1}
              >
                Key Performance Indicators
              </Body>
            </FlexItem>
            <FlexItem>
              <Body
              >
               <CircleIconButton
                  icon="ellipsis-h"
                  variant="link"
              />
              </Body>
            </FlexItem>
          </Flex>
          <SectionSeparator
            marginBottom="md"
          />
        </Layout.Header>
        <Layout.Side>
          <Nav>
            <NavItem active={active === "revenue"} onClick={() => handleSetActive("revenue")} variant="bold" >
              <Flex>
                <FlexItem>
                  <Title
                    size={4}
                  >
                    Revenue
                  </Title>
                </FlexItem>
                <FlexItem>
                <StatChange
                  value={revenue.percentage}
                  change={revenue.direction}
                />
                </FlexItem>
              </Flex>
            </NavItem>
            <NavItem active={active === "orders"} onClick={() => handleSetActive("orders")} variant="bold" >
              <Flex>
                <FlexItem>
                  <Title
                    size={4}
                  >
                    Orders
                  </Title>
                </FlexItem>
                <FlexItem>
                <StatChange
                  value={orders.percentage}
                  change={orders.direction}
                />
                </FlexItem>
              </Flex>
            </NavItem>
            <NavItem active={active === "profit"} onClick={() => handleSetActive("profit")} variant="bold" >
              <Flex>
                <FlexItem>
                  <Title
                    size={4}
                  >
                    Profit
                  </Title>
                </FlexItem>
                <FlexItem>
                <StatChange
                  value={profit.percentage}
                  change={profit.direction}
                />
                </FlexItem>
              </Flex>
            </NavItem>
            <NavItem active={active === "average_check"} onClick={() => handleSetActive("average_check")} variant="bold" >
              <Flex>
                <FlexItem>
                  <Title
                    size={4}
                  >
                  Average Check
                  </Title>
                </FlexItem>

              </Flex>
            </NavItem>
            <NavItem active={active === "cancelled"} onClick={() => handleSetActive("cancelled")} variant="bold" >
              <Flex>
                <FlexItem>
                  <Title
                    size={4}
                  >
                    Cancelled
                  </Title>
                </FlexItem>
                <FlexItem>
                <StatChange
                  value={cancelled.percentage}
                  change={cancelled.direction}
                />
                </FlexItem>
              </Flex>
            </NavItem>
            <NavItem active={active === "repeat_sales"} onClick={() => handleSetActive("repeat_sales")} variant="bold" >
              <Flex>
                <FlexItem>
                  <Title
                    size={4}
                  >
                  Repeat Sales
                  </Title>
                </FlexItem>
                <FlexItem>
                <StatChange
                  value={repeatSales.percentage}
                  change={repeatSales.direction}
                />
                </FlexItem>
              </Flex>
            </NavItem>
          </Nav>
        </Layout.Side>
        <Layout.Body>
          <LineGraph
              chartData={displayData}
              id="line-test"
              xAxisCategories={xAxisCategories}
              height= {"330rem"}
          />
        </Layout.Body>
      </Layout>
    </Background>
  </div>
)}

WebpackerReact.setup({KeyPerformanceIndicators})


export default KeyPerformanceIndicators
