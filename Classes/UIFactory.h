//
//  UIFactory.h
//  MSB
//

#import <Foundation/Foundation.h>
@interface UIFactory : NSObject {
}
// ========================= VIEW =========================== //
+(UIView*)viewTransparentWithFrame:(CGRect)framePar;
+(UIView*)viewBlackWithFrame:(CGRect)framePar;
+(UIView*)viewLowOpacityWithFrame:(CGRect)framePar;
+(UIView*)borderedOrangeViewWithFrame:(CGRect)framePar;
+(UIView*)whiteViewWithFrame:(CGRect)framePar;
+(UIView*)roundedViewWithFrame:(CGRect)framePar;
// ========================= SCROLL VIEW =========================== //
+(UIScrollView*)scrollViewWithFrame:(CGRect)framePar;

// ========================= TABLE VIEW =========================== //
+(UITableView *)tableViewWithFrame:(CGRect)framePar;
+(UITableView *)roundedTableViewWithFrame:(CGRect)framePar;
+(UITableView *)scrollableTableViewWithFrame:(CGRect)framePar;
+(UITableView *)scrollableRoundedTableViewWithFrame:(CGRect)framePar;

// ========================= TEXT FIELD =========================== //
+(UITextField *)bigSecuredTextFieldWithPlaceHolderAtFrame:(CGRect)framePar;

+(UITextField*)textFieldWithFrame:(CGRect)framePar;
+(UITextField*)disabledTextFieldWithFrame:(CGRect)framePar;
+(UITextField*)textFieldWithPlaceHolderAtFrame:(CGRect)framePar;
+(UITextField*)textFieldSecuredWithPlaceHolderAtFrame:(CGRect)framePar;

// ========================= SPINNER =========================== //
+(UIActivityIndicatorView *) spinner;

// ========================= TEXT VIEW =========================== //
+(UITextView*)whiteFontTextViewWithContent:(NSString*)contentPar frame:(CGRect)framePar;
+(UITextView*)textViewWithContent:(NSString*)contentPar frame:(CGRect)framePar;
+(UITextView*)bigFontTextViewWithContent:(NSString*)contentPar frame:(CGRect)framePar;
// ========================= LABEL =========================== //
+(UILabel *)boldLabelWithTitle:(NSString *)titlePar frame:(CGRect)framePar;
+(UILabel *)smallBoldLabelWithTitle:(NSString*)titlePar frame:(CGRect)framePar;
+(UILabel *)boldRightLabelWithTitle:(NSString*)titlePar frame:(CGRect)framePar;

+(UILabel *)labelWithTitle:(NSString *)titlePar frame:(CGRect)framePar;
+(UILabel *)labelRedBoldWithTitle:(NSString*)titlePar frame:(CGRect)framePar;
+(UILabel *)redLabelWithTitle:(NSString*)titlePar frame:(CGRect)framePar;
+(UILabel *)leftRedLabelWithTitle:(NSString*)titlePar frame:(CGRect)framePar;

+(UILabel *)blackLabelWithTitle:(NSString *)titlePar frame:(CGRect)framePar;
+(UILabel *)leftBlackLabelWithTitle:(NSString *)titlePar frame:(CGRect)framePar;

+(UILabel *)labelFieldTitle:(NSString*)titlePar frame:(CGRect)framePar;

+(UILabel *)labelFieldData:(NSString*)titlePar frame:(CGRect)framePar;



// ========================= BUTTON =========================== //
+(UIButton*)buttonWithImage:(UIImage*)imgPar frame:(CGRect)framePar;
+(UIButton*)buttonWithTitle:(NSString*)titlePar frame:(CGRect)framePar;
+(UIButton*)roundedRectButtonWithTitle:(NSString*)titlePar frame:(CGRect)framePar;
+(UIButton*)telephoneButtonWithTitle:(NSString*)titlePar frame:(CGRect)framePar;
+(UIButton*)smallTelephoneButtonWithTitle:(NSString*)titlePar frame:(CGRect)framePar;



@end
