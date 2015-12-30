//
//  AXAlert.h
//  AXKit
//
//  Created by Ashenyx on 12/28/15.
//  Copyright © 2015 Ashenyx. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AXAlertButton.h"

#import "AXAlertWindow.h"

@class AXAlertWindow;

@interface AXAlert : NSObject{
    
    NSTextField *titleField;
    
    NSTextField *informativeTextField;
    
    NSVisualEffectView *windowBackground;
    
}

NS_ASSUME_NONNULL_BEGIN

@property NSString *title;

@property NSString *informativeText;

@property NSMutableArray<AXAlertButton *> *buttons;

@property AXAlertWindow *alertWindow;

@property NSColor *tint;

@property BOOL usesCustomAccessoryView;

@property BOOL shouldBlackout;

-(instancetype)initWithTitle:(NSString *)title informativeText:(NSString *)infoText;

-(instancetype)initWithTitle:(NSString *)title informativeText:(NSString *)infoText tint:(NSColor *)tint;

-(void)dismissAlertWithCode:(NSInteger)code;

-(void)dismissAlert;

-(NSInteger)runModal;

-(void)addButton:(AXAlertButton *)button;

NS_ASSUME_NONNULL_END

@end
