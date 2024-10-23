import React from "react";
import { Card, Flex, IconStatValue, FlexItem } from "playbook-ui";
import '../../App.scss';
import WebpackerReact from 'webpacker-react'


const GridRowFill = ({ data }) => (
  <Card.Body padding="none" className="iron-grid-container">
    <Flex
        horizontal="center"
        spacing="evenly"
    >
      {
        data.map((line, i) => (
          <FlexItem
              key={`grid-row-item-${line.icon}-${i}`}
              margin="sm"
							className="iron-grid-item"
          >
            <IconStatValue 
							{...line} 
						/>
          </FlexItem>
        )
        )
      }
    </Flex>
  </Card.Body>
)

const IconGrid = (props) => {
	console.log(props);
	const gridData = [
		{ icon: 'fa-solid fa-ticket', variant: 'green', size: 'md', text: 'Tickets (YTD)', value: props.total },
		{ icon: 'times-square', variant: 'red', size: 'md', text: 'Overdue', value: props.overdue },
		{ icon: 'tasks', variant: 'teal', size: 'md', text: 'Closed Without Action (YTD)', value: props.closed_without_feedback },
		{ icon: 'exclamation-triangle', variant: 'yellow', size: 'md', text: 'Escalated (YTD)', value: props.escalated },
	]

	return (
		<Card
				borderNone
				margin="none"
				padding="none"
		>
			<GridRowFill data={gridData.slice(0, 2)} />
			<GridRowFill data={gridData.slice(2)} />
		</Card>
	)		
}

WebpackerReact.setup({IconGrid})


export default IconGrid