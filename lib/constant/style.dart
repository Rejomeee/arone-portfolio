/*This is the style or theme of the app*/
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

/*Colors Pallete*/
const kColorBlack = Color(0xFF000000);
const kColorRed = Color(0xFFFF0000);
const kColorBlue = Color(0xFF2040EB);
const kColorLightBlue = Color(0xFFCDD7FE);

const kButtonColor = Color(0xFFFF7777);

const kColorProgressBar = [
  Color(0xFFFB5C7E),
  Color(0xFF6B82FA),
];

const kGradientBorder = [
  Color(0xFFFB5D7F),
  Color(0xFF6B82FA),
];

const kColorLavender = Color(0xFF6B82FA);
const kColorPink = Color(0xFFFB5D7F);
const kColorLightPink = Color(0xFFFBDFDF);

const kColorBlueGreen = [
  Color(0xFF009999),
  Color(0xFF007777),
];

const kColorGreen = Color(0xFF00B200);
const kBadgeColorGreen = Color(0xFF10BC21);
const kSocialBgIcon = Color(0xFF183153);

const kColorOrange = [
  Color(0xFFFF7400),
  Color(0xFFD66100),
];

const kColorGold = [
  Color(0xFFFF7400),
  Color(0xFFB88A00),
];

/* Text Colors */
const kTextColorBlack = Color(0xFF11111);
const kTextColorLightBlack = Color(0xFFC1C2C3);
const kTextColorDarkGrey = Color(0xFF474747);
const kTextColorGrey = Color(0xFF858585);
const kTextColorLightGreyLines = Color(0xFFCACACA);
const kColorWhite = Colors.white;
const kTextColor = Color(0xFF6B82FA);

const kBackgroundColor = Color(0xFFF0F2F5);

const kColorGrey = Color(0xFFEAEDF0);

const kBackgroundColorStatusPostponed = Color(0xFFFBF4D0);
const kColorStatusPostponed = Color(0xFFE5AD00);

const kBackgroundColorStatusCanceled = Color(0xFFFBDBDB);
const kColorStatusCanceled = Color(0xFFFF0000);

const kBackgroundColorStatusCompleted = Color(0xFFFBDBDB);
const kColorStatusCompleted = Color(0xFF1AA742);

const kBackgroundColorStatusGrey = Color(0xFFDDE1E5);
const kColorStatusGrey = Color(0xFF111111);

const kColorInputGrey = Color(0xFFE6ECF2);
const kColorbubbleSecondary = Color(0xFFE6EBFE);
const kColorButtonSecondary = Color(0xFF9CB0FB);

/* DUMP */
// const kColorBlue = Color(0xFFF0C73FE);

// const kColorRed = Color(0xFFFFF0D0C);

// const kColorLightGrey = Color(0xFFF505664);
// const kColorLightGrey1 = Color(0xFFFE0E3E7);
// const kColorLightGrey2 = Color(0xFFF505664);

// const kColorPrimary = Color(0xFF3A3335); // blackish
// const kColorSecondary = Color(0xFFFDF0D5); // yellowish

// const kLogoColorPrimary = Color(0xFF599A8A); // tealish
// const kLogoColorSecondary = Color(0xFF59849A); // blueish`

// //palette
// const kPallete0 = Color(0xFF848484);
// const kPallete1 = Color(0xFFDEE2F9);
// const kPallete2 = Color(0xFFBBC3FA);
// const kPallete3 = Color(0xFFADB4F2);
// const kPallete4 = Color(0xFFBEA8B3);
// const kPallete5 = Color(0xFFE01A1A);
// const kPallete6 = Color(0xFF4B54BF);
// const kPallete7 = Color(0xFF171949);

/*Appbar Title text constant*/
const kAppbarTitle = TextStyle(
  color: kColorWhite,
  fontWeight: FontWeight.w800,
);

const kHeadline1 = TextStyle(
  fontSize: 48,
  // fontSize: 44.0.sp,
  color: kColorBlack,
  fontWeight: FontWeight.w800,
);

const kHeadline2 = TextStyle(
  fontSize: 34,
  // fontSize: 30.0.sp,
  color: kColorBlack,
  fontWeight: FontWeight.w800,
);

const kHeadline3 = TextStyle(
  fontSize: 24,
  // fontSize: 22.0.sp,
  color: kColorBlack,
  fontWeight: FontWeight.w800,
);

const kTitle = TextStyle(
  fontSize: 20,
  color: kColorBlack,
  fontWeight: FontWeight.w800,
);

const kTextBody = TextStyle(
  // fontSize: 17,
  // fontSize: 15.8.sp,
  fontSize: 18,
  color: kColorBlack,
);

const kTextBody2 = TextStyle(
  // fontSize: 17,
  // fontSize: 15.8.sp,
  fontSize: 18,
  color: kColorBlack,
  fontWeight: FontWeight.w800,
);

const kTextBody3 = TextStyle(
  // fontSize: 17,
  // fontSize: 15.8.sp,
  fontSize: 18,
  color: kColorBlack,
  fontWeight: FontWeight.w400,
);

const kTextSub = TextStyle(
  // fontSize: 15,
  // fontSize: 13.0.sp,
  fontSize: 16,
  color: kColorBlack,
);

const kTextSub2 = TextStyle(
  // fontSize: 15,
  // fontSize: 13.0.sp,
  fontSize: 16,
  color: kColorBlack,
  fontWeight: FontWeight.w800,
);

const kTextCaption = TextStyle(
  fontSize: 14,
  // fontSize: 11.0.sp,
  color: kColorBlack,
);

const kTextCaptionSecondary = TextStyle(
  fontSize: 14,
  // fontSize: 11.0.sp,
  color: kTextColorDarkGrey,
);

const kTextCaptionBold = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  // fontSize: 11.0.sp,
  color: kColorBlack,
);

/*Button text constant*/
const kTextButton = TextStyle(
  // fontWeight: FontWeight.w800,
  fontSize: 20,
  color: kColorBlack,
  fontWeight: FontWeight.w600,
);

const kTextBox = TextStyle(
  // fontSize: 11.0.sp,
  fontSize: 18,
  color: kColorBlack,
);

const kLabelBox = TextStyle(
  // fontSize: 11.0.sp,
  fontSize: 16,
  color: kTextColorDarkGrey,
  fontWeight: FontWeight.w400,
);

final kInnerDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(color: Colors.white),
  borderRadius: BorderRadius.circular(4),
);
// border for all 3 colors
final kGradientBoxDecoration = BoxDecoration(
  gradient: LinearGradient(colors: kColorProgressBar),
  border: Border.all(
    color: Colors.amber, //kHintColor, so this should be changed?
  ),
  borderRadius: BorderRadius.circular(4),
);

/* DUMP */

// final kTextLargeTitle = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     // fontSize: 34,
//     fontSize: 31.0.sp,
//     color: kColorBlack,
//   ),
// );

// final kTextTitle1 = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     // fontSize: 28,
//     fontSize: 26.0.sp,
//     color: kColorBlack,
//   ),
// );

// final kTextTitle2 = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     fontSize: 22,
//     // fontSize: 20.0.sp,
//     color: kColorBlack,
//   ),
// );

// final kTextTitle3 = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     // fontSize: 20,
//     fontSize: 18.5.sp,
//     color: kColorBlack,
//   ),
// );

// final kTextHeadline = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     // fontSize: 17,
//     fontSize: 15.8.sp,
//     fontWeight: FontWeight.w900,
//     color: kColorBlack,
//   ),
// );

// final kTextCallout = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     // fontSize: 16,
//     fontSize: 14.5.sp,
//     color: kColorBlack,
//   ),
// );

// final kTextFootnote = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     // fontSize: 13,
//     fontSize: 12.0.sp,
//     color: kColorBlack,
//   ),
// );

// final kTextCaption1 = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     // fontSize: 12,
//     fontSize: 11.0.sp,
//     color: kColorBlack,
//   ),
// );

// final kTextCaption2 = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     // fontSize: 11,
//     fontSize: 10.0.sp,
//     color: kColorBlack,
//   ),
// );

// final kMobileTitle = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     // fontSize: 20,
//     fontSize: 18.5.sp,
//     color: kColorBlack,
//   ),
// );

// final kMobileParagraph = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     // fontSize: 15,
//     fontSize: 13.0.sp,
//     color: kColorBlack,
//   ),
// );

// final kMobileListTitle = GoogleFonts.nunitoSans(
//   fontWeight: FontWeight.w900,
//   textStyle: TextStyle(
//     // fontSize: 15,
//     fontSize: 13.0.sp,
//     // fontWeight: FontWeight.w900,
//     color: kColorBlack,
//   ),
// );

// final kMobileListTitleImportant = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     // fontSize: 16,
//     fontSize: 14.5.sp,
//     color: kColorBlack,
//   ),
// );

// final kMobileCaptions = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     // fontSize: 15,
//     fontSize: 13.0.sp,
//     color: kColorBlack.withOpacity(0.6),
//   ),
// );

// final kMobileButtons = GoogleFonts.nunitoSans(
//   fontWeight: FontWeight.w900,
//   textStyle: TextStyle(
//     // fontSize: 15,
//     fontSize: 13.0.sp,
//     // color: kColorBlack.withOpacity(0.6),
//   ),
// );

// final kMobileInputText = GoogleFonts.archivoNarrow(
//   textStyle: TextStyle(
//     // fontSize: 16,
//     fontSize: 14.5.sp,
//     color: kColorBlack,
//   ),
// );

// final kTextTitle = GoogleFonts.nunitoSans(
//   textStyle: TextStyle(
//     fontSize: 20,
//     // fontSize: 22.0.sp,
//     color: kColorBlack,
//   ),
// );

// /*Body text constant*/
// final kTextBodyxx = GoogleFonts.archivoNarrow(
//   textStyle: TextStyle(
//     color: kColorBlack,
//     fontWeight: FontWeight.normal,
//   ),
// );

// /*Text field constant */
// final kTextFieldTitle = TextStyle(
//   fontFamily: 'Manrope',
//   color: kColorLightGrey,
//   fontSize: 16.sp,
//   fontWeight: FontWeight.w400,
// );

// /*Breadcrumb title constant */
// final kBreadcrumbTitle = TextStyle(
//   fontFamily: 'Manrope',
//   color: kColorBlue,
//   fontSize: 15.sp,
//   fontWeight: FontWeight.w600,
//   letterSpacing: 2.0,
// );

