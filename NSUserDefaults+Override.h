//
//  NSUserDefaults+Override.h
//  Postico Tests
//
//  Created by Jakob Egger on 2018-03-28.
//  Copyright © 2018 Egger Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Override)

-(void)overrideValue:(id)override forKey:(NSString*)key;

@end
