import { StyleSheet, Text, View } from "react-native";

import { StatusBar } from 'expo-status-bar';
import React from 'react';

export default function AutofillExtension() {
  return (
    <View style={styles.container}>
      <Text>AutofillExtensionAutofillExtensionAutofillExtensionAutofillExtension</Text>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
