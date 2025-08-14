import Button from '@/components/Button';
import ScreenWrapper from '@/components/ScreenWrapper';
import Typo from '@/components/Typo';
import { colors, spacingX, spacingY } from '@/constants/theme';
import { verticalScale } from '@/utils/styling';
import { useRouter } from 'expo-router';
import React from 'react';
import { StyleSheet, TouchableOpacity, View } from 'react-native';
import Animated, { FadeIn, FadeInDown } from 'react-native-reanimated';


// This is the welcome screen component
const Welcome = () => {
  const router = useRouter();
  return (
<ScreenWrapper>
  <View style = {styles.container}>

      {/*==== BUTTON SIGN IN ====*/}
      <View>
          <TouchableOpacity onPress= {()=> router.push('/(auth)/login')}  // SIGN IN BUTTON
              style={styles.loginButton}>
              <Typo fontWeight={'400'}>Sign In</Typo>
          </TouchableOpacity> 

          {/*==== WELCOME IMAGE ====*/}
          <Animated.Image
              entering = {FadeIn.duration(1000)} // ANIMATION EFFECT OF THE IMAGE// CHANGE THE TIME {5s}
              style={styles.welcomeImage}
              resizeMode="contain"
              source={require('../../assets/images/welcome.png')} // ✅ Ensure the image path is correct
          />
      </View>

      {/* ==== FOOTER ==== */}
      <View style={styles.footer}>
        <Animated.View
            entering={FadeInDown.duration(1000).springify().damping(12)} // para animação não ficar com bouncing no final - experimenta mudar
            style={{ alignItems: "center" }}>
            <Typo size={30} fontWeight="800">
              Always take control
            </Typo>
            <Typo size={30} fontWeight="800">
              of your finances
            </Typo>
        </Animated.View> 

 
      {/*==== SUBTITLE ====*/}  
      <Animated.View
          entering={FadeInDown.duration(1000)
            .delay(100)
            .springify()
            .damping(12)} // para animação não ficar com bouncing no final - experimenta mudar
          style={{ alignItems: "center" , gap: 2}}
          >

          <Typo size={17} color={colors.textLight}>
            Finances must be arranged to set a better
          </Typo>
          <Typo size={17} color={colors.textLight}>
            lifestyle in future
          </Typo>
      </Animated.View>


      { /*==== GET STARTED BUTTON ====*/}
      <Animated.View
        entering={FadeInDown.duration(1000).
          delay(200).
          springify().
          damping(12)}
        style={styles.buttonContainer}
        >
          <Button onPress= {()=> router.push('/(auth)/register')} // GET STARTED BUTTON
          style={styles.getStartedButton}>
            <Typo size={18} color={colors.neutral900} fontWeight="600">
              Get Started
            </Typo>
        </Button>
      </Animated.View>
    </View>

  </View>
</ScreenWrapper>
  );
};

export default Welcome;

// ====== ESTILOS GLOBAIS ====== //

const styles = StyleSheet.create({  
    container: {
        flex: 1,
        justifyContent: 'space-between',
        paddingTop: spacingY._7, // Adjust padding as needed
    },
    
    welcomeImage: {
        width: '100%',
        height: verticalScale(300), // Adjust 
        alignSelf: 'center',

        marginTop: verticalScale(100), // Adjust
    },

    loginButton: {
        alignSelf: 'flex-end',
        marginRight: spacingY._20,
    },

    // ==== FOOTER STYLES === //
    footer:{
        backgroundColor: colors.neutral900,
        alignItems: 'center',
        paddingTop: verticalScale(30),
        paddingBottom: verticalScale(45),
        gap: spacingY._20,
        shadowColor: 'white',
        shadowOffset: {
            width: 0,
            height: -10},
        elevation: 10,
        shadowRadius: 25,
        shadowOpacity: 0.25,
    },
        buttonContainer: {
        width: '100%',
        paddingHorizontal: spacingX._25,
        },

        // === GET STARTED BUTTON === //
    getStartedButton: {
        backgroundColor: colors.primary, // or any color you want
        paddingVertical: spacingY._15,
        borderRadius: 8,
        alignItems: 'center',
        justifyContent: 'center',
        marginTop: spacingY._10,
    },
    });












