import { auth, firestore } from "@/config/firebase";
import { AuthContextType, UserType } from "@/types";
import { useRouter } from "expo-router";
import { createUserWithEmailAndPassword, onAuthStateChanged, signInWithEmailAndPassword } from "firebase/auth";
import { doc, getDoc, setDoc } from "firebase/firestore";
import { createContext, useContext, useEffect, useState } from "react";


const AuthContext = createContext<AuthContextType | null>(null);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => { 
    const [user, setUser] = useState<UserType | null>(null);
    const router = useRouter();

    useEffect (() => {
        const unsub = onAuthStateChanged(auth, (firebaseUser) =>  {
            console.log('firebase user: ', firebaseUser) // THIS LOGS THE CURRENT USER OBJECT FROM FIREBASE, SO WE CAN SEE IF A USER IS LOGGED IN OR NOT
            
            // USER IS SIGNED IN
            if (firebaseUser) {
                setUser({
                    uid: firebaseUser.uid,
                    email: firebaseUser.email,
                    name: firebaseUser.displayName || firebaseUser.email?.split('@')[0] || null,  
                });
                updateUserData(firebaseUser.uid) // THIS UPDATES THE USER DATA IN FIRESTORE
                router.replace("/(tabs)"); // ====  AFTER SIGN IN IT GOES INTO 'TABS' WHERE YOU HAVE: index, profile, statistics, wallet =====
            } else {
                // USER IS SIGNED OUT
                setUser(null);
                router.replace("/(auth)/welcome"); // ====  AFTER SIGN OUT IT GOES INTO 'WELCOME' WHERE YOU HAVE: login, register =====
            }
        });
        
    return ()=> unsub();


    }, []);

    const login = async (email: string, password: string) => {
        try {
            await signInWithEmailAndPassword(auth, email, password);
            return { success: true };
        } catch (error: any) {
            // SE ERRO FOR /INVALID-CREDENTIAL -> PRINT: 
            if (error.code === 'auth/invalid-credential') {
                console.log('Invalid credentials'); // RETURN IN THE CONSOLE
                return { success: false, msg: 'Invalid credentials' }; // RETURN IN THE POP-UP
            }
            let msg = error.message;
            return { success: false, msg };
        }

    };
    const register = async (email: string, password: string) => {
        try {
            let response = await createUserWithEmailAndPassword(
                auth,
                email,
                password
            );
            await setDoc(doc(firestore, "users", response?.user?.uid), {
                name: email.split('@')[0], // Using part of email as default name
                email,
                uid: response?.user?.uid,
            });
            return { success: true };
        } catch (error: any) {
            let msg = error.message
            return { success: false, msg };
        }

    };

    // Function to update user data in Firestore
    const updateUserData = async (uid: string) => {
        try {
            if (!uid) return;

            const docRef = doc(firestore, "users", uid);
            const docSnap = await getDoc(docRef);

            if (docSnap.exists()) {
                const data = docSnap.data() || {} as any;

                // Always preserve UID from Firebase auth / function arg
                const safeUser: UserType = {
                    uid, // ensure uid is never lost
                    // Prefer Firestore values, then fall back to current auth user, then null
                    email: (data.email ?? auth.currentUser?.email) ?? null,
                    name:
                        (data.name
                            ?? auth.currentUser?.displayName
                            ?? auth.currentUser?.email?.split('@')[0]) ?? null,
                    image: data.image ?? null,
                };

                // Merge with existing state to avoid dropping other fields unexpectedly
                setUser((prev) => ({ ...(prev ?? {} as any), ...safeUser }));
            } else {
                // If there's no Firestore doc yet, at least ensure UID persists
                const fallbackUser: UserType = {
                    uid,
                    email: auth.currentUser?.email ?? null,
                    name: auth.currentUser?.displayName
                        ?? auth.currentUser?.email?.split('@')[0]
                        ?? null,
                    image: null,
                };
                setUser((prev) => ({ ...(prev ?? {} as any), ...fallbackUser }));
            }
        } catch (error: any) {
            console.log('error loading user data: ', error);
        }

    };

    const contextValue: AuthContextType = {
        user,
        setUser,
        login,
        register,
        updateUserData,
    }

    return (
        <AuthContext.Provider value={contextValue}>{children}</AuthContext.Provider>
    )
};

export const useAuth = (): AuthContextType => {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error("useAuth must be used within an AuthProvider");
    }
    return context;
};