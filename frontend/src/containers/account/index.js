import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getAccountWidgets } from '../../actions/index';
import accountApi from '../../api/account';
import AccountInfo from '../accountInfo';

export class Account extends Component {
  componentWillMount() {
    this.props.getAccountWidgets(this.props.account.id);
  }

  render() {
    const { account } = this.props;
    return <div>
      <AccountInfo id={account.id} name={account.name} totalWidgets={this.totalWidgets()} />
    </div>
  }

  totalWidgets() {
    if (!this.props.account.widgets) return 0
    return this.props.account.widgets.length
  }

  selectOptions(accounts) {
    return Object.keys(accounts).map(function(key) {
      const account = accounts[key];

      return { value: account.id, label: account.name }
    })
  }

  logChange(val) {
    return (val) => { accountApi.transferWidgets(this.props.account.id, val.value) };
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
