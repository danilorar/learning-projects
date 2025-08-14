import { colors, spacingY } from '@/constants/theme';
import { verticalScale } from '@/utils/styling';
import { BottomTabBarProps } from '@react-navigation/bottom-tabs';
import { ChartBarIcon, HouseIcon, UserIcon, WalletIcon } from 'phosphor-react-native';
import React from 'react';
import { Platform, StyleSheet, TouchableOpacity, View } from 'react-native';

export default function CustomTabs({ state, descriptors, navigation }: BottomTabBarProps) {
    // TAB BAR ICONS DEFINED
    const tabbarIcons: any = {
        // HOME PAGE ICON EDIT 
        index: (useIsFocused: boolean) => (
            <HouseIcon
                size={verticalScale(25)}
                color={useIsFocused ? colors.primary : colors.neutral400}
                weight={useIsFocused? "fill" : "regular"} // FILL ICON IF FOCUSED
            />
        ),
        // STATISTICS PAGE ICON EDIT
        statistics: (useIsFocused: boolean) => (
            <ChartBarIcon
                size={verticalScale(25)}
                color={useIsFocused ? colors.primary : colors.neutral400}
                weight={useIsFocused? "fill" : "regular"} // FILL ICON IF FOCUSED
            />
        ),
        // WALLET PAGE ICON EDIT
        wallet: (useIsFocused: boolean) => (
            <WalletIcon
                size={verticalScale(25)}
                color={useIsFocused ? colors.primary : colors.neutral400}
                weight={useIsFocused? "fill" : "regular"} // FILL ICON IF FOCUSED
            />
        ),
        // PROFILE PAGE ICON EDIT
        profile: (useIsFocused: boolean) => (
            <UserIcon
                size={verticalScale(25)}
                color={useIsFocused ? colors.primary : colors.neutral400}
                weight={useIsFocused? "fill" : "regular"} // FILL ICON IF FOCUSED
            />
        ),  
    }

  return (
    <View style={styles.tabbar}> {/* TABBAR CONTAINER DEFINED BELOW AS styles.tabbar */}
      {state.routes.map((route, index) => {
        const { options } = descriptors[route.key];
        const label: any =
          options.tabBarLabel !== undefined
            ? options.tabBarLabel
            : options.title !== undefined
              ? options.title
              : route.name;

        const isFocused = state.index === index;

        const onPress = () => {
          const event = navigation.emit({
            type: 'tabPress',
            target: route.key,
            canPreventDefault: true,
          });

          if (!isFocused && !event.defaultPrevented) {
            navigation.navigate(route.name, route.params);
          }
        };

        const onLongPress = () => {
          navigation.emit({
            type: 'tabLongPress',
            target: route.key,
          });
        };

        return (
          <TouchableOpacity
            key={route.name}
            // href={buildHref(route.name, route.params)}
            accessibilityState={isFocused ? { selected: true } : {}}
            accessibilityLabel={options.tabBarAccessibilityLabel}
            testID={options.tabBarButtonTestID}
            onPress={onPress}
            onLongPress={onLongPress}
            style={styles.tabbarItem} // STYLE FOR THE TAB BAR
          >
            {
                tabbarIcons[route.name] && tabbarIcons[route.name](isFocused) // DYNAMICALLY RENDER THE ICON BASED ON THE ROUTE NAME
            }
          </TouchableOpacity>
        );
      })}
    </View>
  );
}

// ===== TO EDIT BOTTOM TAB BAR STYLE / POSITION =====

const styles = StyleSheet.create({
    tabbar: {
        flexDirection: 'row',
        width: '100%',
        height: Platform.OS === 'ios' ? verticalScale(70) : verticalScale(60), // DYNAMIC TAB BASED ON OS VS ANDROID IT ADJUSTS
        backgroundColor: colors.neutral800, // BACKGROUND COLOR OF THE TAB BAR
        justifyContent: 'space-around', // SPACING BETWEEN TABS
        alignItems: 'center', // CENTER ITEMS VERTICALLY
        borderTopColor: colors.neutral800, // BORDER TOP COLOR OF THE TAB BAR
        borderTopWidth: 1, // BORDER TOP WIDTH OF THE TAB BAR
    },
    tabbarItem: {
        marginBottom: Platform.OS === 'ios' ? spacingY._10: spacingY._5, // MARGIN BOTTOM FOR THE TAB BAR ITEMS
        justifyContent: 'center',
        alignItems: 'center', // CENTER ITEMS HORIZONTALLY
    },      
});  