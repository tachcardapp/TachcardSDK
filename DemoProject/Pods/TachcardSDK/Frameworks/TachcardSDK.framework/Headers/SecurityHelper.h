//
//  SecurityHelper.h
//  Tachcard
//
//  Created by admin on 04.03.16.
//  Copyright © 2016 Tachcard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityHelper : NSObject
+ (SecurityHelper*)sharedInstance;
@property (retain, nonatomic) NSString *publicKey;
@property (retain, nonatomic) NSString *privateKey;
@property (nonatomic, assign) BOOL testServerStatus;

@property (nonatomic, assign) int mpPayTryCount;
@property (nonatomic, retain) NSString *mpToken;
@end
