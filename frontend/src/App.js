import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getAccounts } from './actions/index';
import logo from './logo.svg';
import Account from './containers/account';
import './App.css';

class App extends Component {
  componentWillMount() {
    this.props.getAccounts();
  }

  render() {
    return (
      <div className="App">
        {this.mapAccounts(this.props.accounts)}
      </div>
    );
  }

  mapAccounts(accounts) {
    if (!accounts) return null;
    return Object.keys(accounts).map(function(key) {
      const account = accounts[key];

      return <Account
        key={key}
        account={account}
        accounts={accounts} />
    })
  }
}

const mapStateToProps = (state) => {
  return {
    accounts: state.accounts.accounts
  }
}

export default connect(
  mapStateToProps,
  { getAccounts }
)(App);
