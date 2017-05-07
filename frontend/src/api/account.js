import axiosInstance from '../config/axios';

export default {
  getAccounts() {
    return axiosInstance.get('accounts');
  },

  getAccountWidgets(account_id) {
    return axiosInstance.get(`widgets/account_widgets/${account_id}`);
  }
}
