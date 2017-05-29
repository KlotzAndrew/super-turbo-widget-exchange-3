import React, { Component } from 'react';

import styles from './style.css'

class AccountInfo extends Component {
  render () {
    return <div className={styles.body}>
      <div className={styles.items}>
        <div className={styles.item}>{this.props.name}</div>
        <div className={styles.item}>widgets: {this.props.totalWidgets}</div>
      </div>
    </div>
  }
}

export default AccountInfo;
