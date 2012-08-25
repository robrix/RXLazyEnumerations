//  RXBlockEnumerator.h
//  Created by Rob Rix on 2012-08-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@interface RXBlockEnumerator : NSEnumerator

-(instancetype)initWithBlock:(id(^)())block;

@property (nonatomic, readonly) id (^block)();

@end
