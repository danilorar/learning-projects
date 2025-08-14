import BackButton from '@/components/BackButton'
import Button from '@/components/Button'
import Input from '@/components/Input'
import ScreenWrapper from '@/components/ScreenWrapper'
import Typo from '@/components/Typo'
import { colors, spacingY } from '@/constants/theme'
import { useAuth } from '@/contexts/authContext'
import { verticalScale } from '@/utils/styling'
import { Ionicons } from '@expo/vector-icons'
import { useRouter } from 'expo-router'
import React, { useState } from 'react'
import { Alert, Pressable, StyleSheet, View } from 'react-native'

const login = () => {

  const emailRef = React.useRef("");
  const passwordRef = React.useRef("");
  const [isLoading, setIsLoading] = useState(false);
  const router = useRouter();
  const { login: LoginUser } = useAuth();

  // === ERRO CASO NÃO SEJA PREENCHIDO ===  
  const handleSubmit = async ()=>{
    if (!emailRef.current || !passwordRef.current) {
      Alert.alert(
        'Error',
        'Please fill in all fields.',
      );
      return;
    }
    //  PARA VERIFICAR NA CONSOLE QUE ESTÀ A SER PREENCHIDO E SE SIM IMPRIME GOOD TO GO
    // console.log('Email:', emailRef.current);  
    // console.log('Password:', passwordRef.current); 
    // console.log("good to go")  

    setIsLoading(true); //  THIS INDICATES THAT THE LOGIN PROCESS IS ONGOING
    const res = await LoginUser(emailRef.current, passwordRef.current); //this calls  the login function from the auth context with the email and password
    setIsLoading(false); //  THIS INDICATES THAT THE LOGIN PROCESS HAS ENDED

    // if success if false -> alert 
    if (!res.success) {
      Alert.alert("Login failed", res.msg);
    }
  }
  return (
    <ScreenWrapper>
      <View style={styles.container}>
        <BackButton iconSize = {20} />
        
        {/* ==== WELCOME TEXT, SIGN IN  ==== */}
        
        <View style={{gap:5, marginTop: spacingY._17}}>   
          <Typo size={30} fontWeight={'800'}>
            Hey there,
          </Typo>
          <Typo size={30} fontWeight={'800'}>
            Welcome back!
          </Typo>
        </View>

        {/* ==== FORM CONTAINER ==== */}

        <View style ={styles.form}>
          <Typo size={16} color={colors.textLight}>
            Login Now to track all your expenses
          </Typo>
        

        {/*====== EMAIL & PASSWORD CONTAINERS =======*/}
        <Input
            placeholder="Enter your Email"
            onChangeText={(value) => (emailRef.current = value)}
            icon={<Ionicons
              name="mail-outline"
              size={verticalScale(16)} // EMAIL TEXT SIZE
              color={colors.primary} // EMAIL ICON COLOR 
              weight="fill" />}  />

        <Input
            placeholder="Enter your password"
            secureTextEntry // TO SEE DOTS INSTEAD OF LETTERS 
            onChangeText={(value) => (passwordRef.current = value)}
            icon={<Ionicons
              name="lock-closed"
              size={verticalScale(16)} // PASSWORD TEXT SIZE
              color={colors.primary} // PASSWORD ICON COLOR 
              weight="fill" />}  />

          { /* ===== FORGOT PASSWORD =====*/ }
            <Typo size={13} color={colors.white} style={{alignSelf: 'flex-end'}}>  {/* FORGOT PASSWORD TEXT COLOR */ }
              Forgot Password? 
            </Typo>

            <Button loading={isLoading} onPress={handleSubmit}>
                <Typo fontWeight={'500'} color ={colors.black} size= {18}>  
                  Login
                </Typo>
            </Button>

        {/* ===== FOOTER ==== */ }
          <View style={styles.footer}> 
            <Typo size={15} color={colors.text}>Don't have an account?</Typo>   
            <Pressable onPress={() => router.navigate('/(auth)/register')}>  
              <Typo size={15} fontWeight={'700'} color={colors.primary}>
                Sign Up
              </Typo>
            </Pressable>       
          </View>
          </View>
        </View>
    </ScreenWrapper>
  )
}  

export default login

const styles = StyleSheet.create({
  container: {
    flex: 1,
    gap: spacingY._30,
    paddingHorizontal: spacingY._20,
  },
  welcomeText: {
    fontSize: verticalScale(20),
    fontWeight: 'bold',
    color: colors.text,
  },
  form: {
    gap: spacingY._20,
  },
  forgotPassword: {
    textAlign: 'right',
    color: colors.text,
    fontWeight: '500',
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    gap: 5,
  },
  footerText: {
    color: colors.text,
    textAlign: 'center',
    fontSize: verticalScale(14),
  },
})