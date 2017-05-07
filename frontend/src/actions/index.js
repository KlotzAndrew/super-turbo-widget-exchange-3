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
