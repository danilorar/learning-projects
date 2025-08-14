// ==================================================
// ====== MAIN TABS WRAPPER  // MAIN WALLPAPER ======
// ==================================================

import { colors } from '@/constants/theme';
import { ScreenWrapperProps } from '@/types';
import React from 'react';
import { Dimensions, Platform, StatusBar, StyleSheet, View } from 'react-native';

const {height} = Dimensions.get('window');

// This component is used to wrap the screens in the app, providing a consistent style and background color
// ScreenWrapper component will receive some components as children and style
const ScreenWrapper = ({style, children}: ScreenWrapperProps) => {
    let paddingTop = Platform.OS == 'ios'? height * 0.06:50; // for iOS, we set paddingTop to 6% of the screen height, for Android we set it to 50px
  return (
    <View style={[
        {
        paddingTop,
        flex: 1,
        backgroundColor:colors.neutral900, // default background color is white 
        },
        style,

    ]}>

        <StatusBar barStyle={'light-content'} />
        {children}
    </View>
  )
}

export default ScreenWrapper
const styles = StyleSheet.create({})