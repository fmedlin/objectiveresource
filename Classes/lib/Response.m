//
// Response.m
//
//
// Created by Ryan Daigle on 7/30/08.
// Copyright 2008 yFactorial, LLC. All rights reserved.
//

#import "Response.h"

@implementation Response

@synthesize body, headers, statusCode;

+ (id)responseFrom:(NSHTTPURLResponse *)response withBody:(NSData *)data andError:(NSError *)aError {
	return [[[self alloc] initFrom:response withBody:data andError:aError] autorelease];
}

- (id)initFrom:(NSHTTPURLResponse *)response withBody:(NSData *)data andError:(NSError *)aError {
	[self init];
	self.body = data;
	if(response) {
		self.statusCode = [response statusCode];
		if (statusCode == 0) {
			NSString *statusCodeString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
			if ([statusCodeString isEqualToString:@"HTTP Basic: Access denied."]) {
				statusCode = 401;
			}
			[statusCodeString release];
		}
		
		self.headers = [response allHeaderFields];
	}

	return self;
}

- (BOOL)isSuccess {
	return statusCode >= 200 && statusCode < 400;
}

- (BOOL)isError {
	return ![self isSuccess];
}

- (void)log {
	if ([self isSuccess]) {
		debugLog(@"<= %@", [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease]);
	}
	else {
		NSLog(@"<= %@", [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease]);
	}
}

#pragma mark cleanup

- (void) dealloc
{
	[body release];
	[headers release];
	[super dealloc];
}


@end
