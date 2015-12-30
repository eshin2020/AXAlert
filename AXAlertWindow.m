//
//  AXAlertWindow.m
//  AXKit
//
//  Created by Ashenyx on 12/28/15.
//  Copyright © 2015 Ashenyx. All rights reserved.
//

#import "AXAlertWindow.h"

@implementation AXAlertWindow

-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag{
    
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    
    return self;
}

-(instancetype)initWithAlert:(AXAlert *)alert{
    
    self = [AXAlertWindow defaultWindow];
    
    if (self) {
        
        self.representingAlert = alert;
        
    }
    
    return self;
}

+(AXAlertWindow *)defaultWindow{
    
    AXAlertWindow *window = [[AXAlertWindow alloc] initWithContentRect:centerScreenRectFromSize(AXAlertDefaultSize) styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSFullSizeContentViewWindowMask) backing:NSBackingStoreBuffered defer:YES];
    
    [window setOpaque:NO];
    
    [window setMovableByWindowBackground:true];
    
    [[[window standardWindowButton:NSWindowCloseButton] superview] setHidden:YES];
    
    return window;
    
}

-(NSColor *)tint{
    return self.representingAlert.tint;
}

-(NSMutableArray<AXAlertButton *> *)buttons{
    return self.representingAlert.buttons;
}

-(BOOL)requiresVerticalButton{
    
    for (AXAlertButton *button in [self buttons]) {
        if ([button wantsVerticalAlignment]) {
            break;
            return YES;
        }
    }
    
    if (self.buttons.count >= 3) {
        return YES;
    }
    
    return NO;
}

-(void)layout{
    
    //  We start building the alert interface from bottom to top.
    
    //  Buttons...

    
    windowBackground = [[NSVisualEffectView alloc] initWithFrame:NSZeroRect];
    
    [windowBackground setMaterial:NSVisualEffectMaterialMediumLight];
    [windowBackground setState:NSVisualEffectStateActive];
    
    [self.contentView addSubview:windowBackground];
    
    int currentStackHeight = 0;
    
    if ([self requiresVerticalButton]) {
        
        for (AXAlertButton *button in self.buttons) {
            
            [button setFrame:NSMakeRect(0, currentStackHeight, self.frame.size.width, [button requiredHeight])];
            
            currentStackHeight += [button requiredHeight];
        }
        
    }else{

        @try {
            
            if (self.buttons.count == 1) {
                
                AXAlertButton *firstButton = [self.buttons firstObject];
                
                [firstButton setFrame:NSMakeRect(0, 0, self.frame.size.width/2, [firstButton requiredHeight])];
                
                currentStackHeight = [firstButton requiredHeight];
                
            }else{
                
                AXAlertButton *firstButton = [self.buttons firstObject];
                
                AXAlertButton *secondButton = [self.buttons objectAtIndex:1];
                
                int requiredHeight = 0;
                
                if ([firstButton requiredHeight] > [secondButton requiredHeight]) {
                    
                    requiredHeight = [firstButton requiredHeight];
                    
                }else if([firstButton requiredHeight] < [secondButton requiredHeight]){
                    
                    requiredHeight = [secondButton requiredHeight];
                    
                }else{
                    
                    requiredHeight = [firstButton requiredHeight];
                    
                }
                
                [firstButton setFrame:NSMakeRect(0, 0, self.frame.size.width/2, requiredHeight)];
                [secondButton setFrame:NSMakeRect(self.frame.size.width/2, 0, self.frame.size.width/2, requiredHeight)];
                
                currentStackHeight = requiredHeight;
            }

        }
        @catch (NSException *exception) {
            NSLog(@"AXAlertError: %@ \nThis alert contains no button", self.representingAlert);
        }
        @finally {
            
        }
    
    }
    
    
    for (AXAlertButton *button in self.buttons) {
        [button layout];
        [self.contentView addSubview:button];
    }
    
    //  add the accessory view layout to the stack here.
    
    currentStackHeight += AXAlertMarginSize;
    
    if (self.representingAlert.usesCustomAccessoryView == true) {
        
        [self.accessoryView setFrame:NSMakeRect(0, currentStackHeight, self.frame.size.width, self.accessoryView.frame.size.height)];
        
        currentStackHeight += self.accessoryView.frame.size.height;
        
    }else{
        
        self.accessoryView = [[NSView alloc] initWithFrame:NSMakeRect(0, currentStackHeight, self.frame.size.width, 0)];
        
        CGFloat titleHeight = [self.representingAlert.title boundingRectWithSize:NSMakeSize(self.frame.size.width, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:17.0f]}].size.height;
    
        CGFloat textHeight = [self.representingAlert.informativeText boundingRectWithSize:NSMakeSize(self.frame.size.width, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:15.0f]}].size.height;
        
        
        informativeTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, AXAlertMarginSize, self.frame.size.width, textHeight)];
        
        [informativeTextField setDrawsBackground:NO];
        [informativeTextField setBordered:NO];
        [informativeTextField setEditable:NO];
        [informativeTextField setSelectable:NO];
        [informativeTextField setAlignment:NSTextAlignmentCenter];
        
        [informativeTextField setFont:[NSFont systemFontOfSize:15.0f]];
        
        currentStackHeight += textHeight+AXAlertMarginSize;
        
        titleField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, textHeight + AXAlertMarginSize*2, self.frame.size.width, titleHeight)];
        
        [titleField setDrawsBackground:NO];
        [titleField setBordered:NO];
        [titleField setEditable:NO];
        [titleField setSelectable:NO];
        [titleField setAlignment:NSTextAlignmentCenter];
        
        [titleField setFont:[NSFont systemFontOfSize:17.0f]];
        
        currentStackHeight += titleHeight+ AXAlertMarginSize*2;
        
        [self.accessoryView setSubviews:@[titleField, informativeTextField]];
        
        [self.accessoryView setFrame:NSMakeRect(0, self.accessoryView.frame.origin.y, self.frame.size.width, textHeight+AXAlertMarginSize+titleHeight+AXAlertMarginSize*2 + AXAlertMarginSize)];
        
        [informativeTextField setTextColor:[NSColor colorWithWhite:0 alpha:0.75]];
        
        [informativeTextField setStringValue:self.representingAlert.informativeText];
        
        [titleField setStringValue:self.representingAlert.title];
        
    }
    
    currentStackHeight += AXAlertMarginSize;
    
    [self.contentView addSubview:self.accessoryView];

    [self setFrame:centerScreenRectFromSize(NSMakeSize(self.frame.size.width, currentStackHeight)) display:YES];
    [windowBackground setFrame:zeroRectWithSize(self.frame.size)];

        
}

-(void)close{
    
    [super close];
    
}

-(void)center{
    
    [self setFrame:centerScreenRectFromSize(self.frame.size) display:YES];
    
}

static NSRect centerScreenRectFromSize(NSSize size){
    
    NSSize screenSize = [[NSScreen mainScreen] visibleFrame].size;
    
    return centerRectOfSize(screenSize, size);
    
}

static NSRect zeroRectWithSize(NSSize size){
    
    return NSMakeRect(0, 0, size.width, size.height);
    
}

static NSRect centerRectOfSize(NSSize parent, NSSize child){
    return NSMakeRect((parent.width-child.width)/2, (parent.height-child.height)/2, child.width, child.height);
}


@end
