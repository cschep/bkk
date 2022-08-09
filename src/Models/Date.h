//
//  Date.h
//  Baby Ketten
//
//  Created by Christopher Schepman on 6/7/10.
//  Copyright 2010 schepsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Date : NSObject {
	NSString *title;
	NSString *where;
	NSString *when;
	NSString *description;
}

@property (strong) NSString *title;
@property (strong) NSString *where;
@property (strong) NSString *when;
@property (strong) NSString *description;

@end
