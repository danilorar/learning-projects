import CustomTabs from '@/components/CustomTabs';
import { Tabs } from 'expo-router';
import React from 'react';
import { StyleSheet } from 'react-native';

// DEFINE LAYOUT TABS ORDER [1ST INDEX 2ND STATISTICS 3RD WALLET 4TH PROFILE]
const _layout = () => {
  return (
    <Tabs tabBar={CustomTabs} screenOptions={{headerShown: false}}>
      {/* To hide the header */}

      <Tabs.Screen
        name="index"
        options={{ title: 'Home' }}
      />
      <Tabs.Screen
        name="statistics"
        options={{ title: 'Statistics' }}
        />
      <Tabs.Screen
        name="wallet"
        options={{ title: 'Wallet' }}
      />
      <Tabs.Screen
        name="profile"
        options={{ title: 'Profile' }}
      />
    </Tabs>
  );
};

export default _layout

const styles = StyleSheet.create({})