//  RXBufferEnumerator.m
//  Created by Rob Rix on 2012-08-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "RXBufferEnumerator.h"

@implementation RXBufferEnumerator {
	dispatch_queue_t _readQueue;
	dispatch_io_t _channel;
	dispatch_semaphore_t _dataAvailableSemaphore;
	NSMutableString *_contents;
	NSUInteger _currentIndex;
	BOOL _isComplete;
}

-(instancetype)initWithPath:(NSString *)path {
	if ((self = [super init])) {
		_contents = [NSMutableString new];
		
		_readQueue = dispatch_queue_create("com.monochromeindustries.RXBufferEnumerator.read", 0);
		_channel = dispatch_io_create_with_path(DISPATCH_IO_STREAM, path.fileSystemRepresentation, O_RDONLY, 0, _readQueue, NULL);
		
		_dataAvailableSemaphore = dispatch_semaphore_create(0);
		
		dispatch_io_read(_channel, 0, SIZE_MAX, _readQueue, ^(bool done, dispatch_data_t data, int error) {
			dispatch_data_apply(data, ^bool(dispatch_data_t region, size_t offset, const void *buffer, size_t size) {
				NSString *chunk = [[NSString alloc] initWithBytes:buffer length:size encoding:NSUTF8StringEncoding];
				
				[_contents appendString:chunk];
				
				return true;
			});
			
			dispatch_semaphore_signal(_dataAvailableSemaphore);
			
			if (done) {
				dispatch_io_close(_channel, 0);
				_isComplete = YES;
			}
		});
	}
	return self;
}


-(id)nextObject {
	__block id character = nil;
	
	__block bool shouldWait = NO;
	
	dispatch_sync(_readQueue, ^{
		shouldWait = (_currentIndex == _contents.length) && !_isComplete;
	});
	
	if (shouldWait)
		dispatch_semaphore_wait(_dataAvailableSemaphore, DISPATCH_TIME_FOREVER);
	
	dispatch_sync(_readQueue, ^{
		if (_currentIndex < _contents.length) {
			character = [_contents substringWithRange:NSMakeRange(_currentIndex++, 1)];
		} else if (!_isComplete) {
			// should never get here, because if we’ve consumed all the data and we’re not waiting, we’re done
			// breakpoint for safety
			[self self];
		}
	});
	return character;
}

@end
