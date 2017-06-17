import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getAccountWidgets } from '../../actions/index';
import AccountInfo from '../accountInfo';
import ProgressBar from '../../components/progressBar'

export class Account extends Component {
  constructor(props) {
    super(props);
    this.state = {oldCount: 0, newCount: 0};
  }
  componentWillMount() {
    this.props.getAccountWidgets(this.props.account.id);
  }

  componentWillReceiveProps(nextProps) {
    this.setState((prevState, props) => ({
      oldCount: prevState.newCount,
      newCount: nextProps.account.widgets ? nextProps.account.widgets.length : 0
    }));
  }

  render() {
    const { account, widgets } = this.props;
    const max = Object.keys(widgets).length;
    return <div>
      <AccountInfo id={account.id} name={account.name} totalWidgets={this.totalWidgets()} />
      <ProgressBar startValue={this.state.oldCount} endValue={this.state.newCount} max={max} />
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
}

const mapStateToProps = (state, ownProps) => {
  return {
    account: state.accounts.accounts[ownProps.id],
    widgets: state.accounts.widgets
  }
}

export default connect(
  mapStateToProps,
  { getAccountWidgets }
)(Account);
