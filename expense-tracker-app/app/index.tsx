import { colors } from '@/constants/theme'
import React from 'react'
import { Image, StyleSheet, View } from 'react-native'

const index = () => {
  
  // const router = useRouter();
  // useEffect(() => {
  //    setTimeout(() => {
  //      router.push('/(auth)/welcome'); /* Posição da tela é que está má, mas isto é a diretória, vai lá apos 2s*/ 
  //    }, 2000);
  //  }, []); 

  return (
    <View style={styles.container}>
      <Image
        style={styles.logo}
        resizeMode="contain"
        source={require('../assets/images/splashImage.png')} /* YOU CAN CHANGE THIS IMAGE */
      />
    </View>
  )
}

export default index;

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: colors.neutral900
    },
    logo: { /* YOU CAN CHANGE THE SIZE OF THE LOGO */
        width: 150,
        height: '20%',
        marginBottom: 24,
        aspectRatio: 1
    }
})