import React, { Component } from 'react';
import AccountInfo from '../../components/accountInfo';
import DragSource from './dragSource';
import DropTarget from './dropTarget';

class WrappedAccountInfo extends Component {
  render() {
    const { id, name, totalWidgets } = this.props;
    return (
      <DropTarget id={id}>
        <DragSource id={id}>
          <AccountInfo id={id} name={name} totalWidgets={totalWidgets} />
        </DragSource>
      </DropTarget>
    )
  }
}

export default WrappedAccountInfo;
