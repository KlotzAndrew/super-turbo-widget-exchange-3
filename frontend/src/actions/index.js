import * as types from '../constants/actionTypes';
import account from '../api/account'

const setAccounts = (accounts) => ({
  type: types.SET_ACCOUNTS,
  accounts
})

export const getAccounts = () => dispatch => {
  account.getAccounts()
    .then(response => {
      dispatch(setAccounts(response.data.data))
    })
}
