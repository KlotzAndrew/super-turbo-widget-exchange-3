import * as types from '../constants/actionTypes';

const initialState = {
  accounts: {},
  widgets: {}
}

const normalizer = (memo, obj) => ({
  ...memo,
  [obj.id]: obj
});

const normalizePayload = payload => payload.reduce(normalizer, {});

const addObjects = (accounts, payload) => ({
  ...accounts,
  ...normalizePayload(payload)
});

const updateWidgetCollection = (account, widgets) => ({
  ...account,
  widgets: widgets.map(w => w.id)
})

const accounts = (state = initialState, action) => {
  switch (action.type) {
    case types.SET_ACCOUNTS:
      return {
        ...state,
        accounts: addObjects(state.accounts, action.accounts)
      }
    case types.SET_ACCOUNT_WIDGETS:
      if (!action.widgets[0]) return state;
      const account_id = action.widgets[0].account_id

      return {
        ...state,
        accounts: {
          ...state.accounts,
          [account_id]: updateWidgetCollection(state.accounts[account_id], action.widgets)
        },
        widgets: addObjects(state.widgets, action.widgets)
      }
    default:
      return state
  }
}

export default accounts;
