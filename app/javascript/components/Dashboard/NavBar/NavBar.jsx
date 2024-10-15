import React from 'react';
import { Flex, FlexItem, Title, Caption, Icon, Button, Badge, Body, Avatar } from 'playbook-ui';
import WebpackerReact from 'webpacker-react'

const NavBar = () => {

	const handleLogout = () => {
		const form = document.createElement('form');
		form.method = 'POST';
		form.action = '/users/sign_out';
	
		// Add CSRF token if needed
		const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
		const csrfInput = document.createElement('input');
		csrfInput.type = 'hidden';
		csrfInput.name = 'authenticity_token';
		csrfInput.value = csrfToken;
		form.appendChild(csrfInput);
	
		// Add the _method input to simulate DELETE
		const methodInput = document.createElement('input');
		methodInput.type = 'hidden';
		methodInput.name = '_method';
		methodInput.value = 'delete';
		form.appendChild(methodInput);
	
		document.body.appendChild(form);
		form.submit();
	};

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
								<Button
									size="none"
									variant="link"
									
									onClick={() => handleLogout()}
								>
									<Avatar
										name="First Name"
										size="sm"
									/>
								</Button>
							</FlexItem>
						</Flex>
					</Flex>
				</Flex>
			</Flex>
    );
}

WebpackerReact.setup({NavBar})


export default NavBar