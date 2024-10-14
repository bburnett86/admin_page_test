import React from 'react';
import { Flex, FlexItem, Title, Caption, Icon, CircleIconButton, Badge, Body, Avatar } from 'playbook-ui';
import WebpackerReact from 'webpacker-react'

const NavBar = () => {
    return (

				<Flex
						className="nav-bar"
				>
					<Flex
						justify="between"
						className="nav-bar__content"
					>
						<Flex
							justify="between"
						>
							<FlexItem
								className="nav_bar__logo_icon"
							>
								<Icon
									icon="bookmark"
									size="xl"
								/>
							</FlexItem>
							<Flex
								className="nav-bar__logo"
							>
								<FlexItem
								>
									<Title
									bold={false}
										size={1}
									>
										PB&J
									</Title>
								</FlexItem>
								<FlexItem>
									<Caption
										bold={false}
										size={"lg"}
									>
										Industries
									</Caption>
								</FlexItem>
							</Flex>
						</Flex>
						<Flex
							align="end"
							justify="center"
							orientation="column"
							className="nav-bar__status-container"
						>
							<Flex
								className="nav-bar__status-content"
								align="center"
								justify="center"
								orientation="row"
							>
								<FlexItem
									padding="xs"
								>
									<Icon
										icon="bell"
										varient="solid"
										size="xl"
									/>
									<Badge
										text="4"
										variant="primary"
									/>
								</FlexItem>
								<FlexItem
									padding="xs"
								>
									<Icon
										icon="envelope"
										size="xl"
									/>
									<Badge
										text="4"
										variant="primary"
									/>
								</FlexItem>
								<FlexItem
									padding="xs"
								>
									<Body>
										First Name
									</Body>
								</FlexItem>
								<FlexItem
									padding="xs"
								>
									<Avatar
										name="First Name"
										size="sm"
									/>
								</FlexItem>
							</Flex>
						</Flex>
					</Flex>
				</Flex>
    );
}

WebpackerReact.setup({NavBar})


export default NavBar