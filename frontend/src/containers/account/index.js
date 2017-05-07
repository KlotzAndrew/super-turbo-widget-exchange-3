import React, { Component } from 'react';
import { connect } from 'react-redux';

export class Portfolio extends Component {
  render() {
    const { account, accounts } = this.props;
    return <div>{account.id} | {account.name}</div>
  }
}

const mapStateToProps = (state) => {
  return {}
}

export default connect(
  mapStateToProps
)(Portfolio);
