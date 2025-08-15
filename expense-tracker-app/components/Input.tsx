import { colors, radius, spacingX } from '@/constants/theme';
import { InputProps } from '@/types';
import { verticalScale } from '@/utils/styling';
import React from 'react';
import { StyleSheet, TextInput, View } from 'react-native';

const Input = (props: InputProps) => {
  return (
    <View style={[styles.container, props.containerStyle && props.containerStyle]}>
      {props.icon && props.icon}

      <TextInput
        style={[styles.input, props.inputStyle]}
        placeholderTextColor={colors.neutral100} // TEXT INPUT PLACEHOLDER COLOR
        ref={props.inputRef && props.inputRef}
        {...props}

      />
    </View>
  );
};

export default Input;


// EDIÇÃO DA CAIXA DE LOGIN 
const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    height: verticalScale(50), // LARGURA DA CAIXA 
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: colors.neutral600, // BORDAS DA CAIXA
    borderRadius: radius._15, // RAIO DA CAIXA 
    // @ts-ignore
    borderCurve: 'continuous',
    backgroundColor: colors.neutral800, // COR DO BACKGROUND DA CAIXA DO MAIL 
    paddingHorizontal: spacingX._20,
    gap: spacingX._20,
  },
  input: {
    flex: 1,
    color: colors.neutral200, // TEXT COLOR
    height: '100%',
    paddingVertical: 0,
    fontSize: verticalScale(14),
  },
});
