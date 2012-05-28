//
//  SettingFontVC.h
//  RSSReader
//
//  Created by thatko on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingFontVC : UIViewController {
	//GUI
	UIPickerView *pickerView;
	
	//Data
	NSUserDefaults *prefs;
	NSMutableArray *arrSetting; 
	//NSMutableDictionary *dictSetting; //ex: (Mandant name, MandantName) ; (WorkBasket name, WbName)...
}

@end
