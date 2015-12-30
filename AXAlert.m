//
//  AXAlert.m
//  AXKit
//
//  Created by Ashenyx on 12/28/15.
//  Copyright © 2015 Ashenyx. All rights reserved.
//

#import "AXAlert.h"

@implementation AXAlert

-(instancetype)initWithTitle:(NSString *)title informativeText:(NSString *)infoText{
    
    self = [super init];
    
    if (self) {
    
        self.title = title;
    
        self.informativeText = infoText;
        
        self.tint = [NSColor colorWithDeviceRed:0 green:0.46 blue:1.0 alpha:1];
        
        self.buttons = [[NSMutableArray alloc] init];
        
        self.alertWindow = [[AXAlertWindow alloc] initWithAlert:self];
        
        for (AXAlertButton *button in self.buttons) {
            
            [button setParentAlert:self];
            
        }
    
    }
    
    return self;
}

-(instancetype)initWithTitle:(NSString *)title informativeText:(NSString *)infoText tint:(NSColor *)tint{

    
    self = [super init];
    
    if (self) {
        
        self.title = title;
        
        self.informativeText = infoText;
        
        self.tint = tint;
        
        self.buttons = [[NSMutableArray alloc] init];        
        
        self.alertWindow = [[AXAlertWindow alloc] initWithAlert:self];
        
        for (AXAlertButton *button in self.buttons) {
            
            [button setParentAlert:self];
            
        }
        
    }
    
    return self;

}

-(NSInteger)runModal{
    
    if (self.shouldBlackout) {
    
    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, [[NSScreen mainScreen] frame].size.width, [[NSScreen mainScreen] frame].size.height) styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSFullSizeContentViewWindowMask) backing:NSBackingStoreBuffered defer:YES];
    
    [window setOpaque:NO];
    
    [[[window standardWindowButton:NSWindowCloseButton] superview] setHidden:YES];
    
    [window setBackgroundColor:[NSColor colorWithWhite:0 alpha:0.5]];
    
    [window setLevel:8];
    
    [window makeKeyAndOrderFront:nil];
    
    [window setIgnoresMouseEvents:YES];
    
    [window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
    
    }
        
    [self.alertWindow layout];
    
    [self.alertWindow center];
    
    return [NSApp runModalForWindow:self.alertWindow];
    
}

-(void)dismissAlertWithCode:(NSInteger)code{
    
    [self.alertWindow close];
    
    [NSApp stopModalWithCode:code];
    
}

-(void)dismissAlert{
    
    
    [self.alertWindow close];
    
    [NSApp stopModal];
    
}


-(void)addButton:(AXAlertButton *)button{
    [button setParentAlert:self];
    [self.buttons addObject:button];
}

@end
