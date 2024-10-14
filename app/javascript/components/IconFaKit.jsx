import React from 'react';
import {Icon} from 'playbook-ui';
import "../../assets/icons/all.min.js"

const IconFaKit = (props) => {
  console.log(props.icon)
  return (
    <Icon
      fixedWidth
      fak
      variant={props.variant}
      icon={props.icon}
    />
  );
};

export default IconFaKit;
