import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <h1>Hello!</h1>
          {/* <img src={logo} className="App-logo" alt="logo" /> */}
          <p>Thanks for visiting my website! As you may realized, this website is under construction</p>
          <p>I'm struggling with Code and AWS to make this site awesome.</p>
          <h2>Do you want to get in contact with me?</h2>
          <p>Contact info:</p>
          <address>
            Mail: <a href="mailto:mariogomezmtz@gmail.com?subject=contact">mariogomezmtz@gmail.com</a><br />
            Skype: <em>mariogomezmtz</em>
          </address>
          <p>Say hello!</p>
        </header>
      </div>
    );
  }
}

export default App;
