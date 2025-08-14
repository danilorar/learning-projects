// =======================
// ====== HOME TAB =======
// =======================

// COMMENT IT OUT FOR TERMINAL OUTPUT DATA 

import ScreenWrapper from '@/components/ScreenWrapper'
import Typo from '@/components/Typo'
import { useAuth } from '@/contexts/authContext'
import React from 'react'
import { StyleSheet } from 'react-native'

const index = () => {
    const {user} = useAuth();
    // console.log("User:", user); // TO PRINT IN THE CONSOLE, THE NAME, EMAIL AND UID 
    
    // const handleLogout = async () => {
    //     await signOut(auth);
    // };
  return (
    <ScreenWrapper>
      <Typo>Home</Typo>
      {/* <Button onPress={handleLogout}>
        <Typo color={colors.black}> Log Out</Typo>  // LOG OUT GIANT BUTTON ON HOME PAGE NOT NEEDED ANYMORE SINCE WE HAVE ON THE PROFILE MENU 
      </Button> */}
    </ScreenWrapper>
  )
}

export default index

const styles = StyleSheet.create({})