import { AuthProvider } from '@/contexts/authContext';
import { Stack } from 'expo-router';
import React from 'react';
import { StyleSheet } from 'react-native';

const StackLayout = () => {
  return <Stack screenOptions={{ headerShown: false }} >
     <Stack.Screen 
      name="(modals)/profileModal" 
      options={{
        presentation: 'modal'
     }} />
  </Stack>;  /* stack new open page after click opens a stack page - try click on edit profile */
  
};

export default function RootLayout() {
  return (
    <AuthProvider>
      <StackLayout />
    </AuthProvider>
  );
}

const styles = StyleSheet.create({})