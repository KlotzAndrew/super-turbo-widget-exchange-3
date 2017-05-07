import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getAccountWidgets } from '../../actions/index';

export class Account extends Component {
  componentWillMount() {
    this.props.getAccountWidgets(this.props.account.id);
  }

  render() {
    const { account, accounts } = this.props;
    return <div>{account.id} | {account.name} | widgets: {this.totalWidgets()}</div>
  }

  totalWidgets() {
    if (!this.props.account.widgets) return 0
    return this.props.account.widgets.length
  }
}

const mapStateToProps = (state, ownProps) => {
  return {
    account: state.accounts.accounts[ownProps.id]
  }
}

export default connect(
  mapStateToProps,
  { getAccountWidgets }
)(Account);
