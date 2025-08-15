// HEADER COMPONENT FOR TABS / PROFILE TAB 

import { HeaderProps } from '@/types'
import React from 'react'
import { StyleSheet, View } from 'react-native'
import Typo from './Typo'

const Header = ({title= '', leftIcon, style}: HeaderProps) => {
  return (
    <View style ={[styles.container, style]}>
     {leftIcon && <View style={styles.leftIcon}>{leftIcon}</View>}
     {
        title &&
        <Typo
            size={16} // header text size, default 16 looks good
            fontWeight={'500'}
            style={{
                textAlign: 'center',
                width: leftIcon ? "auto" : '100%',
            }}
        >{title}</Typo>
     }
    </View>
  )
}

export default Header

const styles = StyleSheet.create({
    container: {
        width: '100%',
        alignItems: 'center',
        flexDirection: 'row',
        paddingHorizontal: 16,
    },
    leftIcon: {
        alignSelf: 'flex-start',
        marginRight: 16,
        
    },
})
