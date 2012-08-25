//  RXBlockEnumerator.m
//  Created by Rob Rix on 2012-08-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "RXBlockEnumerator.h"

@implementation RXBlockEnumerator

-(instancetype)initWithBlock:(id(^)())block {
	if ((self = [self init])) {
		_block = block;
	}
	return self;
}


-(id)nextObject {
	return _block();
}

@end
