
# React native code in autofill extension

## run with 
`npx expo run:ios --device`


# Deprecated (WITHOUT BUILD PHASES)

## bundle with react-native cli  (NOT REQUIRED ANYMORE)
```
npx react-native bundle \
  --platform ios \
  --dev false \
  --entry-file index.autofill.js \
  --bundle-output ios/autofill/main.jsbundle \
  --assets-dest ios/autofill
```


## run with release configuration (NOT REQUIRED ANYMORE)
`npx expo run:ios --device --configuration Release`