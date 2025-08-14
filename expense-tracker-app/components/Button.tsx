import { colors, radius } from '@/constants/theme'
import { CustomButtonProps } from '@/types'
import { verticalScale } from '@/utils/styling'
import React from 'react'
import { StyleSheet, TouchableOpacity, View } from 'react-native'
import Loading from './Loading'

const Button = ({
    style,
    onPress,
    loading = false,
    children
}: CustomButtonProps ) => {
    if (loading) {
        return (
            <View style={[styles.button, style, { backgroundColor: 'transparent' }]}>
                <Loading />
            </View>
        )
    }
  return (
    <TouchableOpacity onPress={onPress} style={[styles.button, style]} >
      {children}
    </TouchableOpacity>
  );
};

export default Button

const styles = StyleSheet.create({
  button: {
    height: verticalScale(55),
    borderRadius: radius._30,
    backgroundColor: colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
    borderCurve: 'continuous',
   },
})