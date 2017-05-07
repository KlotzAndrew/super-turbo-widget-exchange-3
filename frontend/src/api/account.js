import axiosInstance from '../config/axios';

export default {
  getAccounts() {
    return axiosInstance.get('accounts');
  },
}
