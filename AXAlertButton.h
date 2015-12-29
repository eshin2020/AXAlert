//
//  AXAlertButton.h
//  CustomAlertWindowTest
//
//  Created by Ashenyx on 12/29/15.
//  Copyright © 2015 Ashenyx. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

#import "AXAlert.h"

#define AXAlertButtonDefaultHeight 35

@class AXAlert;

@interface AXAlertButton : NSView{
    
    NSVisualEffectView *background;
    
    NSTextField *titleField;
    
}

@property AXAlert *parentAlert;

@property BOOL shouldCloseAfterAction;

@property NSInteger buttonTag;

@property NSString *title;

@property NSColor *textColor;   //  if not set, will use tint color...

@property BOOL boldText;

@property SEL action;

@property id target;

-(NSColor *)tint;

-(void)layout;

-(BOOL)wantsVerticalAlignment;

-(CGFloat)requiredHeight;

-(instancetype)initWithAlert:(AXAlert *)alert title:(NSString *)title action:(SEL)action;

@end
