// Learn more https://docs.expo.io/guides/customizing-metro
const { getDefaultConfig } = require('expo/metro-config');

/** @type {import('expo/metro-config').MetroConfig} */
const config = getDefaultConfig(__dirname);


const withAutofillExtension = (config) => {
    if (!config.resolver) {
      throw new Error("config.resolver is not defined");
    }
  
    config.resolver.sourceExts = [
      ...(config.resolver?.sourceExts ?? []),
      "autofill.js",
    ];
  
    if (!config.server) {
      throw new Error("config.server is not defined");
    }
  
    const originalRewriteRequestUrl =
      config.server?.rewriteRequestUrl || ((url) => url);
  
    config.server.rewriteRequestUrl = (url) => {
      const isAutofillExtension = url.includes("autofillExtension=true");
      const rewrittenUrl = originalRewriteRequestUrl(url);
  
      if (isAutofillExtension) {
        return rewrittenUrl.replace("index.bundle", "index.autofill.bundle");
      }
  
      return rewrittenUrl;
    };
  
    return config;
};
  
module.exports = withAutofillExtension(config);