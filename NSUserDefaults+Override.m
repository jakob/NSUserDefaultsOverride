//
//  NSUserDefaults+Override.m
//  Postico Tests
//
//  Created by Jakob Egger on 2018-03-28.
//  Copyright © 2018 Egger Apps. All rights reserved.
//

#import "NSUserDefaults+Override.h"
#import <objc/runtime.h>

static NSMutableDictionary *gUserDefaultOverrides;

@implementation NSUserDefaults (Override)

-(void)overrideValue:(id)override forKey:(NSString*)key;
{
    if (!gUserDefaultOverrides) gUserDefaultOverrides = [[NSMutableDictionary alloc] init];
    gUserDefaultOverrides[key] = override;
    
    static dispatch_once_t swizzleToken;
    dispatch_once(&swizzleToken, ^{
        Class class = [self class];
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(objectForKey:)), class_getInstanceMethod(class, @selector(swizzledObjectForKey:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(boolForKey:)), class_getInstanceMethod(class, @selector(swizzledBoolForKey:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(integerForKey:)), class_getInstanceMethod(class, @selector(swizzledIntegerForKey:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(stringForKey:)), class_getInstanceMethod(class, @selector(swizzledStringForKey:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(stringArrayForKey:)), class_getInstanceMethod(class, @selector(swizzledStringArrayForKey:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(floatForKey:)), class_getInstanceMethod(class, @selector(swizzledFloatForKey:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(doubleForKey:)), class_getInstanceMethod(class, @selector(swizzledDoubleForKey:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(dataForKey:)), class_getInstanceMethod(class, @selector(swizzledDataForKey:)));
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NSUserDefaultsDidChangeNotification object:[NSUserDefaults standardUserDefaults]];
}

-(BOOL)swizzledBoolForKey:(NSString *)key {
    id override = gUserDefaultOverrides[key];
    if (override) return [override boolValue];
    return [self swizzledBoolForKey:key];
}

-(id)swizzledObjectForKey:(NSString *)key {
    return gUserDefaultOverrides[key] ?: [self swizzledObjectForKey:key];
}

-(NSInteger)swizzledIntegerForKey:(NSString *)key {
    id override = gUserDefaultOverrides[key];
    if (override) return [override respondsToSelector:@selector(integerValue)] ? [override integerValue] : 0;
    return [self swizzledIntegerForKey:key];
}

-(NSString *)swizzledStringForKey:(NSString *)key {
    id override = gUserDefaultOverrides[key];
    if (override) {
        if ([override isKindOfClass:[NSString class]]) return override;
        if ([override respondsToSelector:@selector(stringValue)]) return [override stringValue];
        return nil;
    }
    return [self swizzledStringForKey:key];
}

-(NSArray<NSString *> *)swizzledStringArrayForKey:(NSString *)key {
    id override = gUserDefaultOverrides[key];
    if (override) {
        if (![override isKindOfClass:[NSArray class]]) return nil;
        for (id element in override) {
            if (![element isKindOfClass:[NSString class]]) return nil;
        }
        return override;
    }
    return [self swizzledStringArrayForKey:key];
}

-(float)swizzledFloatForKey:(NSString *)key {
    id override = gUserDefaultOverrides[key];
    if (override) return [override respondsToSelector:@selector(floatValue)] ? [override floatValue] : 0;
    return [self swizzledFloatForKey:key];
}

-(double)swizzledDoubleForKey:(NSString *)key {
    id override = gUserDefaultOverrides[key];
    if (override) return [override respondsToSelector:@selector(doubleValue)] ? [override doubleValue] : 0;
    return [self swizzledDoubleForKey:key];
}

-(NSData *)swizzledDataForKey:(NSString *)key {
    id override = gUserDefaultOverrides[key];
    if (override) return [override isKindOfClass:[NSData class]] ? override : nil;
    return [self swizzledDataForKey:key];
}
@end
