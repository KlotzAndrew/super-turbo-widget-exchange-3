import * as types from '../constants/actionTypes';
import accountApi from '../api/account'

const setAccounts = (accounts) => ({
  type: types.SET_ACCOUNTS,
  accounts
})

export const getAccounts = () => dispatch => {
  accountApi.getAccounts()
    .then(response => {
      dispatch(setAccounts(response.data.data))
    })
}

const setAccountWidgets = (widgets) => ({
  type: types.SET_ACCOUNT_WIDGETS,
  widgets
})

export const getAccountWidgets = (account_id) => dispatch => {
  accountApi.getAccountWidgets(account_id)
    .then(response => {
      dispatch(setAccountWidgets(response.data.data))
    })
}

const sentWidget = (widget) => ({
  type: types.RECORD_SENT_WIDGET,
  widget
})

const receivedWidget = (widget) => ({
  type: types.RECORD_RECEIVED_WIDGET,
  widget
})

export const newMessage = (payload) => dispatch => {
  if (payload.status === "sent") {
    dispatch(sentWidget(payload.widget))
  } else {
    dispatch(receivedWidget(payload.widget))
  }
}
