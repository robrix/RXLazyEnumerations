//  RXBufferEnumeratorTest.m
//  Created by Rob Rix on 2012-08-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "RXBufferEnumerator.h"

@interface RXBufferEnumeratorTest : SenTestCase
@end

@implementation RXBufferEnumeratorTest

-(void)testEnumeratesFilesOneCharacterAtATime {
	RXBufferEnumerator *enumerator = [[RXBufferEnumerator alloc] initWithPath:@(__FILE__)];
	
	STAssertEqualObjects(enumerator.nextObject, @"/", @"Expected equals.");
	STAssertEqualObjects(enumerator.nextObject, @"/", @"Expected equals.");
	STAssertEqualObjects(enumerator.nextObject, @" ", @"Expected equals.");
}

// test UTF8 composition and stuff; the dispatch_data_t -> NSString conversion is tricksy

// you should test to make sure that your code handles things like (U+006EU+0303) the same as (U+00F1)

@end
