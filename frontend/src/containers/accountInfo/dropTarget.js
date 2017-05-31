import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { DropTarget } from 'react-dnd';
import ItemTypes from '../../constants/itemTypes';
import classNames from 'classnames/bind';
import styles from './drop.css'

let cx = classNames.bind(styles);

const boxTarget = {
  drop(props) {
    return { id: props.id };
  },
  canDrop(props, monitor) {
    const item = monitor.getItem();
    return item.id !== props.id;
  },
};

class DropContainer extends Component {
  static propTypes = {
    connectDropTarget: PropTypes.func.isRequired,
    isOver: PropTypes.bool.isRequired,
    canDrop: PropTypes.bool.isRequired,
  };

  render() {
    const { canDrop, isOver, connectDropTarget } = this.props;
    const isActive = canDrop && isOver;

    return connectDropTarget(
      <span className={cx({base: true, active: isActive})}>
        {this.props.children}
      </span>,
    );
  }
}

export default DropTarget(ItemTypes.ACCOUNT, boxTarget, (connect, monitor) => ({
  connectDropTarget: connect.dropTarget(),
  isOver: monitor.isOver(),
  canDrop: monitor.canDrop(),
}))(DropContainer)
