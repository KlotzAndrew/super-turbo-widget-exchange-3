import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getAccounts } from './actions/index';
import Account from './containers/account';
import HTML5Backend from 'react-dnd-html5-backend';
import { DragDropContextProvider } from 'react-dnd';
import './App.css';

class App extends Component {
  componentWillMount() {
    this.props.getAccounts();
  }

  render() {
    return (
      <DragDropContextProvider backend={HTML5Backend}>
        <div className="App">
          {this.mapAccounts(this.props.accounts)}
        </div>
      </DragDropContextProvider>
    );
  }

  mapAccounts(accounts) {
    if (!accounts) return null;
    return Object.keys(accounts).map(function(key) {
      const account = accounts[key];

      return <Account
        key={key}
        id={account.id}
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
