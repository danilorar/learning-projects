import Header from '@/components/Header'
import ScreenWrapper from '@/components/ScreenWrapper'
import Typo from '@/components/Typo'
import { auth } from '@/config/firebase'
import { colors, radius, spacingX, spacingY } from '@/constants/theme'
import { useAuth } from '@/contexts/authContext'
import { getProfileImage } from '@/services/imageService'
import { accountOptionType } from '@/types'
import { verticalScale } from '@/utils/styling'
import { MaterialIcons } from '@expo/vector-icons'
import { Image } from "expo-image"
import { useRouter } from 'expo-router'
import { signOut } from 'firebase/auth'
import React from 'react'
import { Alert, StyleSheet, TouchableOpacity, View } from 'react-native'
import Animated, { FadeInDown } from 'react-native-reanimated'

const profile = () => {
    const {user} = useAuth();
    const router = useRouter();

    // ===== TO EDIT PROFILE ICONS =====
    const accountOptions: accountOptionType[] = [
        {
            title: "Edit Profile",
            icon: (<MaterialIcons name="edit" size={verticalScale(20)} color={colors.neutral100} />),
            routeName: "/(modals)/profileModal",
            bgColor: '6366f1'
        },

        {
            title: "Settings",
            icon: (<MaterialIcons name="tune" size={verticalScale(20)} color={colors.neutral100}/>), 
            // routeName: "/(modals)/settingsModal",
            bgColor: '#059669'
        },

        {
            title: "Privacy Policy",
            icon: (<MaterialIcons name="security" size={verticalScale(20)} color={colors.neutral100}/>),
            // routeName: "/(modals)/profileModal",
            bgColor: colors.primaryDark
        },

        {
            title: "Logout",
            icon: (<MaterialIcons name="logout" size={verticalScale(20)} color={colors.neutral100}/>),
            // routeName: "/(modals)/profileModal",
            bgColor: colors.rose
        },
    ]

    // PARTE PARA LOG OUT PELO PERFIL E CONDIÇÔES 

    //  LOG OUT
    const handleLogout = async (p0: string) => {
        await signOut(auth);
    };

    // SHOW LOGOUT ALERT
    const showLogoutAlert = () => {
        Alert.alert('Confirm', "Are you sure you want to Logout?", [
            {
                text: 'Cancel',
                onPress: () => console.log('Cancel Logout Pressed'), // Cancel logout
                style: 'cancel'
            },
            {
                text: "Logout",
                onPress: () => handleLogout('Logout Pressed'), // Log out the user
                style: 'destructive' // This will make the button red
            }
        ]);
    };
     
    // HANDLE PRESS FOR ACCOUNT OPTIONS
    const handlePress = async (item: accountOptionType) => {
        if (item.title == 'Logout'){
            showLogoutAlert(); // Function to show a confirmation dialog before logging out
        }
        if (item.routeName) router.push(item.routeName);
    };

  return (
    <ScreenWrapper> {/* BACKGROUND CHOICE FOR EVERY PAGE: SCREEN WRAPPER */}
        <View style={styles.container}> 
            {/* == HEADER == */} 
            <Header title={'Profile'} style={{marginVertical: spacingY._10 }} /> {/* POSICIONAMENTO DO PROFILE HEADER EM Y; MAIOR VALOR; MAIS PARA BAIXO FICAR */}

        {/* ==== USER INFORMATION ====*/}
        <View style={styles.userInfo}> {/*defined user information container */}

            {/*user avatar */}
            <View style={styles.avatarContainer}>  

            </View>

            {/*user image */}
            <Image
                source={getProfileImage(user?.image)} // This sets the source of the image to the user's image if it exists.
                style={styles.avatar} // This style gives the avatar a circular shape and sets its size.
                contentFit='cover' // This ensures the image covers the entire area of the avatar without distorting its aspect ratio.
                transition={100} // This sets a transition duration of 100ms for the image when it changes.
            />

            {/* name & email */}
            <View style={styles.nameContainer}>
                <Typo size={24} fontWeight={'400'} color={colors.neutral100}>
                    {user?.name} {/* IF USER IS LOGGED IN, SHOWS THE NAME */}
                </Typo>

                <Typo size={14}  color={colors.neutral400}>
                    {user?.email} {/* IF USER IS LOGGED IN, SHOWS THE EMAIL */}
                </Typo>

            </View>
        </View>

        {/* account options */}
        <View style= {styles.accountOptions}>
            {accountOptions.map((item , index) => {
                function handlePressItem(item: accountOptionType): ((event: import("react-native").GestureResponderEvent) => void) | undefined {
                    throw new Error('Function not implemented.')
                }

                return  (
                    <Animated.View
                    key = {index.toString()}
                    entering={FadeInDown.delay(index * 50).springify().damping(14)} style={styles.listItem}>  {/*ANIMATION SERVE PARA FAZER O EFEITO DE ENTRADA BACANO*/}
                        <TouchableOpacity style={styles.flexRow} onPress={() => handlePress(item)}>

                            {/*======ICON LIST PROFILE======*/}
                            <View style= {[styles.listIcon, { backgroundColor: item?.bgColor }]}>
                                {item.icon && item.icon}
                            </View>

                            <Typo size={15} color={colors.neutral100} fontWeight={'400'} style={{ flex: 1 }}>
                                {item.title}
                            </Typo>
                            <MaterialIcons
                                name="chevron-right"
                                size={30} // TAMANHO DAS SETAS A FRENTE DOS ICONS 
                                color={colors.white}
                            />

                        </TouchableOpacity>
                    </Animated.View>
                )

            })}
        </View>
        </View>
    </ScreenWrapper>
  )
}

export default profile

const styles = StyleSheet.create({
    // This will show the main container for the profile screen
    container: {
        flex: 1,
        // justifyContent: 'center',
        // alignItems: 'center',
        paddingHorizontal: spacingX._20,
        // Do not set backgroundColor here, let ScreenWrapper handle it
    },
    // ===== This will show the user's information ======
    userInfo: {
        marginTop: verticalScale(30),
        alignItems: 'center',
        gap: spacingY._15,
    },

    // ===== This will show the user's avatar ==========
    avatarContainer: {
        position: 'relative',
        alignSelf: 'center',
    },

    // ===== This will show the user's avatar ==========
    avatar:{
        alignSelf: 'center',
        backgroundColor: colors.neutral300,
        height: verticalScale(135),
        width: verticalScale(135),
        borderRadius: 200,
        // overflow: 'hidden',
        // position : 'relative' ,
    },

    // ===== The edit icon for the user's avatar =====
    editIcon:{
        position: 'absolute',
        bottom: 5,
        right: 8,
        borderRadius: 50, 
        backgroundColor: colors.neutral100,
        shadowColor: colors.black,
        shadowOffset: {
            width: 0,
            height: 0,
        },
        shadowOpacity: 0.25,
        shadowRadius: 10,
        elevation: 5,
        padding: spacingX._5,
    },

    // ==== This will show the name of the user ==== 
    nameContainer: {
        alignItems: 'center',
        gap: verticalScale(4),
    },
    // ==== This will show the icon for each item in the list (setting, privacy, logout on the profile tab)=====
    listIcon:{
        height: verticalScale(45), // entre 40 e 50 fica bem 
        width: verticalScale(45),
        backgroundColor: colors.neutral600,
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: radius._15, 
        borderCurve: "continuous",
    },

    // ===== Styles for a single item in the list of user information ===== 
    listItem: {
        marginBottom: verticalScale(17),
    },

    // ===== Styles for the account options container =====
    accountOptions: {
        marginTop: spacingY._35,
    },

    // ===== A row layout with centered items and a gap between them =====
    flexRow :{
        flexDirection: 'row',
        alignItems: 'center',
        gap: spacingX._10,
    }
})

