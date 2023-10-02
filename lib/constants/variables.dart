const appName = 'careTracker';

// font variables
const fontFamilyBody = 'Ubuntu';
const fontFamilyHeadline = 'Righteous';

const appNameOnLoginPageTextSize = 36.0;

const loginScreenBottomTagLineText = 'track, care your loved ones';

const loginInputBorderRadius = 20.0;

const loginInputFieldWidth = 320.0;

const loginFieldsContentPaddingAll = 20.0;

const loginFieldPasswordHintText = 'password';
const loginFieldUsernameHintText = 'username';

const distanceBetweenUsernamePasswordLoginButton = 24.0;

const double upperSizedBoxHeight = 150.0;
const double lowerSizedBoxHeight = 80.0;

const buttonPaddingAll = 18.0;
const loginLogoutRegisterButtonTextSize = 18.0;

const loginScreenBottomTagLinePaddingBottom = 12.0;

const loginButtonText = 'login';

RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');
RegExp ageRegExp = RegExp(r'^[1-9][0-9]*$');
RegExp rollNoRegExp = RegExp(r'^[0-9]+$');
RegExp nameRegExp = RegExp(r'[a-zA-Z ]+$');
RegExp phoneNoRegExp = RegExp(r'^[0-9]{10}$');
RegExp residenceRegExp = RegExp(r'^[0-9a-zA-Z ,.-]+$');
// I tried to name this variable to busRegRegExp it didn't work out that way
// then I changed it to busRegNoRegExp it worked (idk y)
RegExp busRegistrationNoRegExp = RegExp(r'^[a-zA-Z]{2}[0-9]{2}[a-zA-Z]{0,3}[0-9]{4}$');
// RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z]{1,2,3}[0-9]{4}$');
RegExp busNoRegExp = RegExp(r'^[0-9]+$');

const minUsernameLength = 8;
const minPasswordLength = 8;

// const serverUrl = 'localhost:8080';
const serverUrl = 'caretracker-production.up.railway.app';

const allScreensPaddingAll = 12.0;
const schoolNameTextSize = 28.0;
const titleFontSize = 18.0;

const minNameLength = 4;
const maxNameLength = 25;
const maxResidenceLength = 25;
const minResidenceLength = 4;
const driverMinAge = 18;
const driverMaxAge = 100;
const studentMaxAge = 50;
const studentMinAge = 1;
const maxAge = 100;
const typicalTextFieldBorderRadius = 10.0;
