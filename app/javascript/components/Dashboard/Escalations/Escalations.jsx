import React from "react";
import '../../App.scss';
import WebpackerReact from 'webpacker-react'

import {Avatar, Caption, Card, Flex, FlexItem, Icon, Layout, MultipleUsers, Timestamp, Title, SectionSeparator, Body, Detail} from 'playbook-ui'


const Escalations = (props) => {

  const formatType = (str) => {
    return str
      .replace(/_/g, ' ') 
      .replace(/^\w/, (match) => match.toUpperCase()); 
  }

	return (
    <div>
      <Layout layout="kanban"
        className="escalations-container"
        display={{
          xs: "block",
          sm: "block",
          md: "block",
        }}
      >
        <Layout.Body
            layout="content"
            collapse="xs"
            position="left"
        >
          <Card
            highlight={{ position: 'side', color: 'category_2', paddingY: "none" }}
            className="card-header first-column"
          >
            <Caption text="New"/>
          </Card>
          {props.newTickets.slice(0, 6).map((ticket) => (
            <Card
              key={ticket.id}
              marginTop="none"
              className="first-column"
            >
              <Body 
              text={formatType(ticket.ticket_type)}
              truncate="1"
              />
            </Card>
          ))}
          {props.newTickets.length > 6 && (
            <Card
            key={"newTicketsShowMore"}
            marginTop="none"
            justifyContent="center"
            paddingY="sm"
            className="first-column"
            >
              <Flex
                marginTop="none"
                justify="center"
                paddingY="none"
              >

                <Detail 
                  text="Show More"
                  truncate="1"
                  bold="true"
                  size="lg"
                  color="link"
                />
              </Flex>
            </Card>
          )}
        </Layout.Body>
        <Layout.Body>
        <Card
          highlight={{ position: 'side', color: 'category_1' }}
          className="card-header"
        >
          <Caption
            text="Manager Feedback"
          />
        </Card>
        {props.managerFeedback.slice(0, 6).map((ticket) => (
          <Card
            key={ticket.id}
            marginTop="none"
          >
            <Body text={formatType(ticket.ticket_type)}
              truncate="1"
            />
          </Card>
        ))}
        {props.managerFeedback.length > 6 && (
            <Card
            key={"managerFeedbackShowMore"}
            marginTop="none"
            justifyContent="center"
            paddingY="sm"
            >
              <Flex
                marginTop="none"
                justify="center"
                paddingY="none"
              >

                <Detail 
                  text="Show More"
                  truncate="1"
                  bold="true"
                  size="lg"
                  color="link"
                />
              </Flex>
            </Card>
          )}
        </Layout.Body>
        <Layout.Body>
        <Card
          highlight={{ position: 'side', color: 'category_3' }}
          className="card-header"
        >
          < Caption
          text ='Processing'
          />
        </Card>
        {props.processing.slice(0, 6).map((ticket) => (
          <Card
            key={ticket.id}
            marginTop="none"
          >
            <Body text={formatType(ticket.ticket_type)}
              truncate="1"
            />
          </Card>
        ))}
        {props.processing.length > 6 && (
            <Card
            key={"processingShowMore"}
            marginTop="none"
            justifyContent="center"
            paddingY="sm"
            >
              <Flex
                marginTop="none"
                justify="center"
                paddingY="none"
              >

                <Detail 
                  text="Show More"
                  truncate="1"
                  bold="true"
                  size="lg"
                  color="link"
                />
              </Flex>
            </Card>
          )}
        </Layout.Body>
        <Layout.Body>
          <Card
            highlight={{ position: 'side', color: 'category_11' }}
            className="card-header"
          >
            <Caption
             text='Awaiting Feedback'
            />
          </Card>
          {props.awaitingFeedback.slice(0, 6).map((ticket) => (
            <Card
              key={ticket.id}
              marginTop="none"
            >
              <Body text={formatType(ticket.ticket_type)}
                truncate="1"
              />
            </Card>
          ))}
          {props.awaitingFeedback.length > 6 && (
            <Card
            key={"awaitingFeedbackShowMore"}
            marginTop="none"
            justifyContent="center"
            paddingY="sm"
            >
              <Flex
                marginTop="none"
                justify="center"
                paddingY="none"
              >

                <Detail 
                  text="Show More"
                  truncate="1"
                  bold="true"
                  size="lg"
                  color="link"
                />
              </Flex>
            </Card>
          )}
        </Layout.Body>
        <Layout.Body>
          <Card
            highlight={{ position: 'side', color: 'category_12' }}
            className="card-header"
          >
            <Caption
              text='Approved'
            />
          </Card>
          {props.approved.slice(0, 6).map((ticket) => (
            <Card
              key={ticket.id}
              marginTop="none"
            >
              <Body text={formatType(ticket.ticket_type)}
                truncate="1"
              />
            </Card>
          ))}
          {props.approved.length > 6 && (
            <Card
            key={"approvedShowMore"}
            marginTop="none"
            justifyContent="center"
            paddingY="sm"
            >
              <Flex
                marginTop="none"
                justify="center"
                paddingY="none"
              >

                <Detail 
                  text="Show More"
                  truncate="1"
                  bold="true"
                  size="lg"
                  color="link"
                />
              </Flex>
            </Card>
          )}
        </Layout.Body>
      </Layout>
    </div>
  )
}
  
WebpackerReact.setup({Escalations})


export default Escalations