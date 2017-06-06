import React, { Component } from 'react';
import {Motion, spring} from 'react-motion';

import styles from './style.scss'

const maxSize = () => 400

const containerStyle = () => {
  return {width: `${maxSize()}px`}
}

const barStyle = (value, max) => {
  return {width: `${(value/max) * maxSize()}px`}
}

const percent = (value, max) => {
  return Math.round(value/max * 100)
}

const progressBar = (interpolatedStyles, max) => {
  return (
    <div className={styles.wrapper}>
      <div style={containerStyle()} className={styles.container}>
        <div style={barStyle(interpolatedStyles.x, max)} className={styles.bar}></div>
      </div>
      <div>{percent(interpolatedStyles.x, max)}%</div>
    </div>
  )
}

export class ProgressBar extends Component {
  render() {
    const { startValue, endValue, max } = this.props;
    const springCOnfig = {stiffness: 300, damping: 40}
    return(
      <Motion defaultStyle={{x: startValue}} style={{x: spring(endValue, springCOnfig)}}>
        {interpolatedStyles => progressBar(interpolatedStyles, max)}
      </Motion>
    )
  }
}

export default ProgressBar;
