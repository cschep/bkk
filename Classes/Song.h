//
//  Song.h
//  bkk
//
//  Created by Chris Schepman on 4/5/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject {
	NSString *artist;
	NSString *title;
	NSString *lyrics;
	NSString *songID;
}

@property (retain) NSString *artist;
@property (retain) NSString *title;
@property (retain) NSString *lyrics;
@property (retain) NSString *songID;

@end
