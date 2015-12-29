//
//  AXAlertWindow.h
//  AXKit
//
//  Created by Ashenyx on 12/28/15.
//  Copyright © 2015 Ashenyx. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AXAlert.h"


#define AXAlertDefaultSize NSMakeSize(350, 200)

#define AXAlertMarginSize 15

@class AXAlert, AXAlertButton;

@interface AXAlertWindow : NSWindow{
    
    NSTextField *titleField;
    
    NSTextField *informativeTextField;
    
    NSVisualEffectView *windowBackground;
}

@property AXAlert *representingAlert;

@property NSView *accessoryView;

+(AXAlertWindow *)defaultWindow;

-(NSColor *)tint;

-(NSMutableArray<AXAlertButton *> *)buttons;

-(BOOL)requiresVerticalButton;

-(instancetype)initWithAlert:(AXAlert *)alert;

-(void)layout;

@end
