import { firestore } from "@/config/firebase";
import { ResponseType, UserDataType } from "@/types";
import { doc, setDoc } from "@firebase/firestore";

export const updateUser = async(
    uid: string, 
    updateData : UserDataType
):  Promise<ResponseType>  => {
    try {
        console.log("updateUser called with:", { uid, updateData });
        
        // Validate input
        if (!uid) {
            console.log("No UID provided");
            return { success: false, msg: "No user ID provided" };
        }

        // Create a simple data object with only basic fields
        const dataToSave = {
            name: updateData.name || "",
            email: updateData.email || "",
            phone: updateData.phone || ""
        };

        console.log("Data to save:", dataToSave);

        const userRef = doc(firestore, "users", uid);
        console.log("Document reference created for:", `users/${uid}`);
        
        // Use setDoc with merge to create or update the document
        await setDoc(userRef, dataToSave, { merge: true });
        console.log("Document updated successfully");

        return { success: true, msg: "User updated successfully" };
    } catch (error: any) {
        console.log("error updating user:", error);
        console.log("error message:", error.message);
        console.log("error code:", error.code);
        return { success: false, msg: `Failed to update user: ${error.message}` };
    }
};
