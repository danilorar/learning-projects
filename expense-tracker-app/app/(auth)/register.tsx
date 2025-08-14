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
import React, { useRef, useState } from 'react'
import { Alert, Pressable, StyleSheet, View } from 'react-native'

const register = () => {

  const emailRef = React.useRef("");
  const passwordRef = React.useRef("");
  const nameRef = useRef("");
  const [isLoading, setIsLoading] = useState(false);
  const router = useRouter();
  const { register: registerUser} = useAuth();

  // === ERRO CASO NÃO SEJA PREENCHIDO ===  
  const handleSubmit = async ()=>{
    if (!emailRef.current || !passwordRef.current || !nameRef.current) {
      Alert.alert(
        'Sign up',
        'Please fill in all fields.',
      );
      return;
    }
    //  PARA VERIFICAR NA CONSOLE QUE ESTÀ A SER PREENCHIDO E SE SIM IMPRIME GOOD TO GO
    setIsLoading(true);
    const res = await registerUser(
      emailRef.current,
      passwordRef.current,
      nameRef.current
    );
    setIsLoading(false); 
    console.log('register result: ',res);
    if (!res.success) {
      if (res.msg && res.msg.toLowerCase().includes('already')) {
        console.log('This email is already in use');
        Alert.alert('Sign up', 'This email is already in use');
      } else {
        Alert.alert('Sign up', res.msg);
      }
    }
  }
  return (
    <ScreenWrapper>
      <View style={styles.container}>
        <BackButton iconSize = {20} />
        
        {/* ==== WELCOME TEXT, SIGN IN  ==== */}
        
        <View style={{gap:5, marginTop: spacingY._17}}>   
          <Typo size={30} fontWeight={'800'}>
            Let's,
          </Typo>
          <Typo size={30} fontWeight={'800'}>
            Get Started
          </Typo>
        </View>

        {/* ==== FORM CONTAINER ==== */}

        <View style ={styles.form}>
          <Typo size={14} color={colors.textLight}>
            Create an account to track all your expenses
          </Typo>
        

        {/*====== EMAIL & PASSWORD & NAME CONTAINERS =======*/}
        <Input
            placeholder="Enter your Email"
            onChangeText={(value) => (emailRef.current = value)}
            icon={<Ionicons
              name="mail-outline"
              size={verticalScale(16)} // EMAIL TEXT SIZE
              color={colors.primary} // EMAIL ICON COLOR 
              weight="fill" />}  />

        <Input
            placeholder="Enter your Name"
            onChangeText={(value) => (nameRef.current = value)}
            icon={<Ionicons
              name="person-outline"
              size={verticalScale(16)} // NAME TEXT SIZE
              color={colors.primary} // NAME ICON COLOR
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


            <Button loading={isLoading} onPress={handleSubmit}>
                <Typo fontWeight={'500'} color ={colors.black} size= {18}>  
                    Sign Up
                </Typo>
            </Button>

        {/* ===== FOOTER FOR LOGIN  ==== */ }
          <View style={styles.footer}> 
            <Typo size={15} color={colors.text}>Already have an account?</Typo>   
            <Pressable onPress={() => router.navigate('/(auth)/login')}> 
              <Typo size={15} fontWeight={'700'} color={colors.primary}>
                Login
              </Typo>
            </Pressable>       
          </View>
          </View>
        </View>
    </ScreenWrapper>
  )
}  

export default register

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