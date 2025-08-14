// =================================================
// ====== MODAL WRAPPER  // MODALS WALLPAPER =======
// =================================================
import { colors, spacingY } from '@/constants/theme';
import React, { ReactNode } from 'react';
import { Dimensions, Platform, StyleProp, StyleSheet, View, ViewStyle } from 'react-native';

const {height} = Dimensions.get('window');
const isIOS = Platform.OS === 'ios';

export interface ModalWrapperProps {
    style?: StyleProp<ViewStyle>;
    children: ReactNode;
    bg?: string;
}

// ModalWrapper component will receive some components as children and style
const ModalWrapper = ({
    style,
    children,
    bg = colors.neutral800,
}: ModalWrapperProps) => {

    return (
        <View style={[styles.container, {backgroundColor: bg}, style && style]}>
            {children}
        </View>
        )   
}
 
export default ModalWrapper

const styles = StyleSheet.create({

    // container for the modal wrapper - LAYOUT DO MODEL WRAPPER 
    container: { 
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        paddingTop: isIOS ? spacingY._15 : 50, // for iOS, we set paddingTop to 6% of the screen height, for Android we set it to 50px
        paddingBottom: isIOS ? spacingY._20 : spacingY._10, // for iOS, we set paddingBottom to 6% of the screen height, for Android we set it to 50px
    }
})