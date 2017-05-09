import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux'
import { createStore, applyMiddleware } from 'redux'
import thunk from 'redux-thunk';
import { Socket } from 'phoenix-socket';
import { newMessage } from './actions/index'
import App from './App';
import reducer from './reducers/index'
import './index.css';

const store = createStore(
  reducer,
  applyMiddleware(thunk)
)

let socket = new Socket(`ws:192.168.99.100:5000/socket`);
socket.connect();

let channel = socket.channel('room:lobby', {});

channel.join()
  .receive('ok', resp => { console.log('Joined successfully', resp) })
  .receive('error', resp => { console.log('Unable to join', resp) })

channel.on('new:message', payload => {
    store.dispatch(newMessage(payload))
  }
);

ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
);
