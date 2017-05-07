import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getAccounts } from './actions/index';
import logo from './logo.svg';
import './App.css';

class App extends Component {
  componentWillMount() {
    this.props.getAccounts();
  }

  render() {
    return (
      <div className="App">
        <div className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h2>Welcome to React</h2>
        </div>
        <p className="App-intro">
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  return {
    accounts: state.accounts
  }
}

export default connect(
  mapStateToProps,
  { getAccounts }
)(App);
