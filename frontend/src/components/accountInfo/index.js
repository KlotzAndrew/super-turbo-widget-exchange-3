import React, { Component } from 'react';

class AccountInfo extends Component {
  render () {
    return <div>
      {this.props.id} | {this.props.name} | widgets: {this.props.totalWidgets}
    </div>
  }
}

export default AccountInfo;
