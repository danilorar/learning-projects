// =================================================
// ====== MODAL WRAPPER  // MODALS WALLPAPER =======
// =================================================
import { colors, spacingY } from '@/constants/theme';
import React, { ReactNode } from 'react';
import { Platform, StyleProp, StyleSheet, View, ViewStyle } from 'react-native';


interface ModalWrapperProps {
    children: ReactNode;
    style?: StyleProp<ViewStyle>;
    bg?: string;
}

const isIos = Platform.OS === 'ios';

const ModalWrapper = ({
    children,
    style, 
    bg = colors.neutral800
}: ModalWrapperProps) => {
  return (
    <View style={[styles.container, {backgroundColor: bg}, style && style]}>
      {children}
    </View>
  )
}

export default ModalWrapper

const styles = StyleSheet.create({
    container: {
        flex: 1,
        paddingTop : isIos ? spacingY._15 : 50,
        paddingBottom: isIos ? spacingY._12 : spacingY._10,
    }
})