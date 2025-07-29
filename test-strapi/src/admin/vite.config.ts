import { mergeConfig, type UserConfig } from 'vite';
 
export default {
  server: {
    allowedHosts: [
      "app-lb-strapi-hrk-1709268746.us-east-2.elb.amazonaws.com"
    ]
  }
};
