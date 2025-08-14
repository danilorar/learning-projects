// This function takes a file input (which can be a string or an object) and returns the appropriate image source.
// If the input is a string, it is returned as is.
// If the input is an object, its 'uri' property is returned.
// If the input is neither, a default avatar image is returned.
// Used in the profile screen to display the user's avatar.

export const getProfileImage = (file: any) => {
    if (file && typeof file === 'string') return file;
    if (file && typeof file === 'object') return file.uri;
    return require('../assets/images/defaultAvatar.png');
}

