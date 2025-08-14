// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries
import AsyncStorage from '@react-native-async-storage/async-storage';
import { getReactNativePersistence, initializeAuth } from 'firebase/auth';
import { getFirestore } from "firebase/firestore";

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDt1oJbdbvLsBw8X5OQQe-we7-OQzlZd_w",
  authDomain: "expense-tracker-23ed3.firebaseapp.com",
  projectId: "expense-tracker-23ed3",
  storageBucket: "expense-tracker-23ed3.firebasestorage.app",
  messagingSenderId: "824943575059",
  appId: "1:824943575059:web:5b536ca9d3406e9d2bbfe6",
  measurementId: "G-ZCC76EMD4R"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);



// Initialize Firebase Authentication
export const auth = initializeAuth(app, {
  persistence: getReactNativePersistence(AsyncStorage),
});

// database 
export const firestore = getFirestore(app);