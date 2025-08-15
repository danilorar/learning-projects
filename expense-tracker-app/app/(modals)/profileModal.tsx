// =======================
// =====PROFILE MODAL=====
// =======================

import BackButton from '@/components/BackButton'
import Button from '@/components/Button'
import Header from '@/components/Header'
import Input from '@/components/Input'
import ModalWrapper from '@/components/ModalWrapper'
import Typo from '@/components/Typo'
import { colors, spacingX, spacingY } from '@/constants/theme'
import { useAuth } from '@/contexts/authContext'
import { getProfileImage } from '@/services/imageService'
import { updateUser } from '@/services/userService'
import { UserDataType } from '@/types'
import { scale, verticalScale } from '@/utils/styling'
import { Feather } from '@expo/vector-icons'
import { useRouter } from 'expo-router'
import React, { useEffect, useState } from 'react'
import { Alert, Image, ScrollView, StyleSheet, TouchableOpacity, View } from 'react-native'

type UserWithPhone = {
    uid?: string;
    email?: string | null;
    name: string | null;
    image?: any;
    phone?: string | null;
};

const profileModal = () => {
    const { user, updateUserData } = useAuth() as { user: UserWithPhone; updateUserData: (uid: string) => void };
    
    // Debug user on component mount
    console.log("ProfileModal - user object:", user);
    
    const [userData, setUserData] = useState<UserDataType>({
        phone: user?.phone ?? "",
        email: "",
        name: "",
        image: null,
    });

    const [loading, setLoading] = useState(false);
    const router = useRouter();

    // to pre-fill with current info + update on firebase
    useEffect(() => {
        console.log("useEffect - user object:", user);
        setUserData({
            phone: user?.phone || "",
            email: user?.email || "",
            name: user?.name || "",
            image: user?.image || null,
        });
    }, [user]);

    const onSubmit = async () => {
        let {name, image, email} = userData;
        if (!name.trim()){
          Alert.alert("Error", "Name is required");
          return;
        }
        if (!(email ?? '').trim()) {
          Alert.alert("Error", "Email is required");
          return;
        }
        // Ensure we have a UID before proceeding
        if (!user || !user.uid) {
            Alert.alert("Error", "User not authenticated. Please sign in again.");
            return;
        }
        
        setLoading(true);
        try {
            const res = await updateUser(user.uid, userData);
            if (res.success){
                //update user context
                updateUserData(user.uid)
                setLoading(false); // Reset loading before navigation
                router.back(); // close modal
            }else{
                setLoading(false); // Reset loading on error
                Alert.alert("User", res.msg || "Failed to update user");
            }
        } catch (error) {
            setLoading(false); // Reset loading on exception
            Alert.alert("Error", "An unexpected error occurred");
        }
    }

    console.log(userData); 

  return (
    <ModalWrapper>
        <View style={styles.container}>
            <Header title="Update Profile" leftIcon={<BackButton />} style={{ marginBottom: spacingY._10 }} />

        {/* form view */}
        <ScrollView contentContainerStyle={styles.form}>
            <View style={styles.avatar}>
                <Image
                    source={getProfileImage(userData.image)}
                    style={styles.avatar}
                    resizeMode="cover" // instead of contentFit
                />

            <TouchableOpacity style={styles.editIcon}>
                <Feather
                    name="edit-2"
                    size={scale(15)}
                    color={colors.neutral700}
                />
            </TouchableOpacity>
            </View>

            {/* Update Input container */}
            <View style={styles.inputContainer}>
                <Typo style={{ color: colors.neutral200, fontSize: scale(14) }}>First Name</Typo>
                <Input
                    placeholder="Enter your first name"
                    value={userData.name}
                    onChangeText={(value) => setUserData({ ...userData, name: value })} 
                    autoComplete="name"
                    textContentType="givenName"
                    autoCorrect={false}
                    autoCapitalize="words"
                />
            </View>

            <View style={styles.inputContainer}>
                <Typo style={{ color: colors.neutral200, fontSize: scale(14) }}>Email</Typo>
                <Input
                    placeholder="Enter your email"
                    value={userData.email}
                    onChangeText={(value) => setUserData({ ...userData, email: value })}
                />
            </View>
        </ScrollView>

        <View style ={styles.footer}>  
            <Button onPress ={onSubmit} loading={loading} style={{flex:1}}>

                <Typo style={{ color: colors.black, fontWeight: '600', fontSize: scale(15) }}>Update</Typo>

            </Button>

        </View>

        </View>
 
        
    </ModalWrapper>
  )
}

export default profileModal

const styles = StyleSheet.create({
    editIconImage: {
        width: scale(20),
        height: scale(20),
    },
    inputContainer: {
        gap:spacingY._10,
    },
    editIcon:{
        position:"absolute",
        bottom: spacingY._5,
        right: spacingY._7,
        borderRadius: 100,
        backgroundColor: colors.neutral100,
        shadowColor:colors.black,
        shadowOffset: {
            width: 0,
            height: 0,
        },
        shadowOpacity: 0.25,
        shadowRadius: 10,
        elevation:4,
        padding: spacingY._7,
    },

    avatar:{
        alignSelf: "center",
        backgroundColor: colors.neutral300,
        height: verticalScale(135),
        width: verticalScale(135),
        borderRadius: 200,
        borderWidth:1,
        borderColor:colors.neutral500
    },
    avatarContainer:{
        position:'relative',
        alignSelf: "center"
    },
    form:{
        gap:spacingY._30,
        marginTop:spacingY._15,
    },
    
    footer:{
        alignItems:"center",
        flexDirection:"row",
        justifyContent:"center",
        paddingHorizontal: spacingX._20,
        gap: scale(12),
        paddingTop: spacingY._15,
        borderBlockColor: colors.neutral800, // same color as the modelwrapper bg color
        marginBottom: spacingY._35,
        borderTopWidth:1,
    },
    container:{
        flex:1, 
        justifyContent:"space-between",
        paddingHorizontal: spacingY._20,    
    },

})
