import React from "react"
import "./App.scss";
import IconGrid from "./Dashboard/IconGrid/IconGrid";
import WebpackerReact from 'webpacker-react'
import {CircleIconButton, Title} from "playbook-ui"
import IconFaKit from "./IconFaKit";

const App = () => {
  return (
    <div>
      Ahoy Mate
      <IconFaKit icon= "ticket" variant="solid" />
    </div>
  )
}

WebpackerReact.setup({App})

export default App
