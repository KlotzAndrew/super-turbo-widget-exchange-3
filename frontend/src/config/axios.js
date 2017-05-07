import axios from 'axios';

let axiosInstance = axios.create({
  baseURL: `http://192.168.99.100:4000`
});

module.exports = axiosInstance;
