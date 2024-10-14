import React from "react";
import '../../App.scss';
import WebpackerReact from 'webpacker-react';
import { Avatar, Card, Flex, FlexItem, Icon, Layout, Body, Detail, Caption } from 'playbook-ui';

const Escalations = (props) => {
  const formatType = (str) => {
    return str.replace(/_/g, ' ').replace(/^\w/, (c) => c.toUpperCase());
  };

  const sections = [
    { title: 'New', color: 'category_2', key: 'newTickets' },
    { title: 'Manager Feedback', color: 'category_1', key: 'managerFeedback' },
    { title: 'Processing', color: 'category_3', key: 'processing' },
    { title: 'Awaiting Feedback', color: 'category_11', key: 'awaitingFeedback' },
    { title: 'Approved', color: 'category_12', key: 'approved' },
  ];

  const renderSection = ({ title, color, key }) => (
    <Layout.Body layout="content" collapse="xs" position="left">
      <Card highlight={{ position: 'side', color, paddingY: "none" }} className="card-header first-column">
        <Caption text={title} />
      </Card>
      {props[key].slice(0, 5).map((ticket) => (
        <Card key={ticket.id} marginTop="none" className="first-column">
          <Flex align="center" justify="start" orientation="row" className="full-width">
            <Flex className="full-width" justify="between">
              <Flex>
                <FlexItem marginRight="sm">
                  <Avatar size="sm" name={ticket.assigned_to.first_name + ' ' + ticket.assigned_to.last_name} />
                </FlexItem>
                <FlexItem>
                  <Body text={formatType(ticket.ticket_type)} truncate="1" />
                </FlexItem>
              </Flex>
              <FlexItem>
                <Icon icon="expand" />
              </FlexItem>
            </Flex>
          </Flex>
        </Card>
      ))}
      {props[key].length > 5 && (
        <Card key={`${key}ShowMore`} marginTop="none" justifyContent="center" paddingY="sm" className="first-column">
          <Flex marginTop="none" justify="center" paddingY="none">
            <Detail text="Show More" truncate="1" bold="true" size="lg" color="link" />
          </Flex>
        </Card>
      )}
    </Layout.Body>
  );

  return (
    <div>
      <Layout layout="kanban" className="escalations-container" display={{ xs: "block", sm: "block", md: "block" }}>
        {sections.map(renderSection)}
      </Layout>
    </div>
  );
};

WebpackerReact.setup({ Escalations });

export default Escalations;