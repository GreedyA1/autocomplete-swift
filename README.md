
# React native code in autofill extension

## bundle with react-native cli
```
npx react-native bundle \
  --platform ios \
  --dev false \
  --entry-file index.autofill.js \
  --bundle-output ios/autofill/main.jsbundle \
  --assets-dest ios/autofill
```
## run with release configuration
`npx expo run:ios --device --configuration Release`