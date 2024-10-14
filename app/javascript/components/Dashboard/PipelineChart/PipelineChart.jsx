import React from 'react'
import { Card, Flex, FlexItem, Title, Caption, ProgressSimple, Body, CircleIconButton, SectionSeparator } from 'playbook-ui'

const PipelineChart = (props) => {
	const chartData = props.pipelineChartData
	return (
		<Card
				borderNone
				margin="none"
				padding="none"
				className="pipeline-chart-container"
		>
			<Flex
					spacing="between"
					vertical="center"
			>
				<Title
						padding="sm"
						size="4"
						text="Pipeline Chart"
				/>
				<CircleIconButton
						icon="ellipsis-h"
						variant="link"
				/>
			</Flex>
			<SectionSeparator />
	
			{chartData.map((row, i) => (
				<Flex
						key={i}
						padding="sm"
						spacing="between"
						vertical="center"
				>
					<FlexItem
						className="pipeline-chart-label"
					>
	
						<Caption
								size="xs"
								text={row.label}
						/>
					</FlexItem>
					<FlexItem grow>
						<Flex
								spacing="around"
								vertical="center"
						>
							<ProgressSimple
									percent={Math.ceil(row.percent)}
									width="20vw"
							/>
							<FlexItem fixedSize="2.5vw">
								<Caption
										marginX="xs"
										size="xs"
										text={`${Math.ceil(row.percent)}%`}
								/>
							</FlexItem>
						</Flex>
					</FlexItem>
					<FlexItem>
						<Flex vertical="right">
							<Body
									text={`${row.data}`}
							/>
						</Flex>
					</FlexItem>
				</Flex>
				))}
	
		</Card>
	)
}

WebpackerReact.setup({PipelineChart})


export default PipelineChart