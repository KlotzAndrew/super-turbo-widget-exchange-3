import axiosInstance from '../config/axios';

export default {
  getAccounts() {
    return axiosInstance.get('accounts');
  },

  getAccountWidgets(account_id) {
    return axiosInstance.get(`widgets/account_widgets/${account_id}`);
  },

  transferWidgets(id, to_id) {
    return axiosInstance.post('accounts/transfer_widgets',
      { id: id, to_id: to_id }
    );
  }
}
