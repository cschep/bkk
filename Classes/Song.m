//
//  Song.m
//  bkk
//
//  Created by Chris Schepman on 4/5/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Song.h"

@implementation Song

@synthesize artist;
@synthesize title;
@synthesize lyrics;
@synthesize songID;
@synthesize geniusID;

- (NSString *)reversedArtist {
    
    id parts = [self.artist componentsSeparatedByString:@", "];
    
    NSString *result = @"";
    for (int i = (int)[parts count] - 1; i >= 0; i--) {
        id part = [parts objectAtIndex:i];
        result = [result stringByAppendingString:[NSString stringWithFormat:@" %@", part]];
    }
    
    return result;
}

@end
