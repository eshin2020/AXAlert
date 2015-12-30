//
//  AXAlertButton.m
//  CustomAlertWindowTest
//
//  Created by Ashenyx on 12/29/15.
//  Copyright © 2015 Ashenyx. All rights reserved.
//

#import "AXAlertButton.h"

@implementation AXAlertButton

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        background = [[NSVisualEffectView alloc] init];
        
        [background setMaterial:NSVisualEffectMaterialLight];
        [background setState:NSVisualEffectStateActive];
        
        titleField = [[NSTextField alloc] init];
        
        [titleField setDrawsBackground:NO];
        [titleField setBordered:NO];
        [titleField setEditable:NO];
        [titleField setSelectable:NO];
        [titleField setAlignment:NSTextAlignmentCenter];
        
        [self setShouldCloseAfterAction:YES];
        
    }
    
    return self;
}

-(instancetype)initWithAlert:(AXAlert *)alert title:(NSString *)title action:(SEL)action{
    
    self = [self init];
    
    if (self) {
        
        [self setParentAlert:alert];
        [self setTitle:title];
        [self setAction:action];
                
        [titleField setTextColor:[self tint]];
        
        [titleField setStringValue:self.title];
        
        [self setFrame:zeroRectWithSize(NSMakeSize(alert.alertWindow.frame.size.width, [self requiredHeight]))];
        
    }
    
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent{
    
    [background setMaterial:NSVisualEffectMaterialMediumLight];
    
}

-(void)mouseUp:(NSEvent *)theEvent{
    
    [background setMaterial:NSVisualEffectMaterialLight];

    NSPoint mouseLoc = [NSEvent mouseLocation]; //get current mouse position
    
    if ([self mouse:mouseLoc inRect:[self.window convertRectToScreen:self.frame]]) {
        
        [self.target performSelector:self.action withObject:self];
        
        if (self.shouldCloseAfterAction) {
        
            [self.parentAlert dismissAlertWithCode:self.buttonTag];
            
        }
        
    }else{
    
        return;
    }
    
}

-(BOOL)mouseDownCanMoveWindow{
    return NO;
}

-(void)layout{
    
    if (![self.parentAlert.alertWindow requiresVerticalButton]) {
        if (self.parentAlert.alertWindow.buttons.count == 2) {
            self.frame = NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.parentAlert.alertWindow.frame.size.width/2, [self requiredHeight]);
        }else{
            self.frame = NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.parentAlert.alertWindow.frame.size.width, [self requiredHeight]);
        }
    }
    
    [titleField setTextColor:[self tint]];
    
    [titleField setStringValue:self.title];
    
    [titleField setFont:[NSFont systemFontOfSize:13.0f]];
    
    if (self.boldText) {
        [titleField setFont:[NSFont boldSystemFontOfSize:13.0f]];
    }
    
    [background setFrame:zeroRectWithSize(NSMakeSize(self.frame.size.width, [self requiredHeight]))];
    
    [titleField setFrame:centerRectOfSize(background.frame.size, NSMakeSize(self.frame.size.width-10, [self requiredHeight]-10))];
    
    [background setSubviews:@[titleField]];
    
    [self setSubviews:@[background]];
    
}


-(BOOL)wantsVerticalAlignment{
    
    NSSize buttonSize = self.frame.size;
    
    NSSize marginedFrame = NSMakeSize(buttonSize.width - 20, self.frame.size.height);
    
    NSSize wantedSize = [self.title boundingRectWithSize:marginedFrame options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:13.0f]}].size;
    
    if(marginedFrame.width < wantedSize.width){
        return YES;
    }else{
        return NO;
    }
    
}

-(NSColor *)tint{
    if (self.textColor) {
        return self.textColor;
    }else{
        return self.parentAlert.tint;
    }
}

-(CGFloat)requiredHeight{
    
    NSSize wantedSize = [self.title boundingRectWithSize:NSMakeSize(self.frame.size.width, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:13.0f]}].size;
    
    if (wantedSize.height+10 < AXAlertButtonDefaultHeight) {
        return AXAlertButtonDefaultHeight;
    }else{
        return wantedSize.height + 10;
    }
    
}

static NSRect zeroRectWithSize(NSSize size){
    
    return NSMakeRect(0, 0, size.width, size.height);
    
}

static NSRect centerRectOfSize(NSSize parent, NSSize child){
    return NSMakeRect(parent.width/2 - child.width/2, parent.height/2 - parent.height/2 , child.width, child.height);
}


@end
