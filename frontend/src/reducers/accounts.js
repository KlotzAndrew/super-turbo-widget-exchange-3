import * as types from '../constants/actionTypes';

const initialState = {
  accounts: {}
}

const normalizer = (memo, obj) => ({
  ...memo,
  [obj.id]: obj
});

const normalizePayload = payload => payload.reduce(normalizer, {});

const addAccounts = (accounts = initialState.accounts, payload) => ({
  ...accounts,
  ...normalizePayload(payload)
});

const accounts = (state = initialState, action) => {
  switch (action.type) {
    case types.SET_ACCOUNTS:
      return {
        ...state,
        ...addAccounts(state.accounts, action.accounts)
      }
    default:
      return state
  }
}

export default accounts;
