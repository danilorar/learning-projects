// =======================
// =====PROFILE MODAL=====
// =======================

import BackButton from '@/components/BackButton'
import Header from '@/components/Header'
import ModalWrapper from '@/components/ModalWrapper'
import { colors, radius, spacingX, spacingY } from '@/constants/theme'
import { getProfileImage } from '@/services/imageService'
import { scale, verticalScale } from '@/utils/styling'
import React from 'react'
import { Image, ScrollView, StyleSheet, View } from 'react-native'

const profileModal = () => {
  return (
    <ModalWrapper>
        <View style={styles.container}>
        {/* É ENTRE O MODEL WRAPPER E DEPOIS VIEW QUE SE CRIA A PÁGINA */}
            <Header 
            title='Update Profile' 
            leftIcon={<BackButton />} 
            style={{marginBottom: spacingY._10}} />

        {/* form */}
       <ScrollView>
            <View style={styles.avatarContainer}>
                <Image
                    source={getProfileImage(null)} // Function to get the profile image
                    style={styles.avatar}
                    resizeMode="cover"
                />
                {/* Formulário de Edição */}
            </View>
        </ScrollView>
      </View>
    </ModalWrapper>
  )
}

export default profileModal


const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'space-between',
        // alignItems: 'center',
        paddingHorizontal: spacingX._20,
    },

    footer: {
        alignItems:'center',
        flexDirection: 'row',
        justifyContent: 'center',
        paddingHorizontal: spacingX._20,
        gap:scale(12),
        paddingTop: spacingY._15,
        borderTopColor: colors.neutral700,
        borderTopWidth: 1,
        marginTop: spacingY._5,
        
    },
    form: {
        gap: spacingY._30,
        marginTop: spacingY._15,


    },
    avatarContainer: {
        position: 'relative',
        alignSelf: 'center',
    }, 

    avatar:{
        alignSelf: 'center',
        backgroundColor: colors.neutral300,
        height: verticalScale(135),
        width: verticalScale(135),
        borderRadius: 200,
        borderWidth:1, 
        borderColor: colors.neutral500
        // overflow: 'hidden',
        // position : 'relative' ,
    },

    // ===== The edit icon for the user's avatar =====
    editIcon:{
        position: 'absolute',
        bottom:spacingY._5,
        right: spacingY._7,
        borderRadius: 100, 
        backgroundColor: colors.neutral100,
        shadowColor: colors.black,
        shadowOffset: {
            width: 0,
            height: 0,
        },
        shadowOpacity: 0.25,
        shadowRadius: 10,
        elevation: 4,
        padding: spacingX._7,
    },

    nameContainer: {
        alignItems: 'center',
        gap: verticalScale(4),
    },

    listIcon:{
        height: verticalScale(45), // entre 40 e 50 fica bem 
        width: verticalScale(45),
        backgroundColor: colors.neutral600,
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: radius._15, 
        borderCurve: "continuous",
    },

    listItem: {
        marginBottom: verticalScale(17),
    },

    accountOptions: {
        marginTop: spacingY._35,
    },

    flexRow :{
        flexDirection: 'row',
        alignItems: 'center',
        gap: spacingX._10,
    },

    inputContainer: {
        gap: spacingY._10,
    }
})

