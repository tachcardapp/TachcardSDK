//
//  MfsResponse.h
//  MfsIOSLibrary
//
//  Created by ercu on 25/02/15.
//  Copyright (c) 2015 Phaymobile. All rights reserved.
//

#ifndef MfsIOSLibrary_MfsResponse_h
#define MfsIOSLibrary_MfsResponse_h

#import "MfsCard.h"

@interface MfsResponse : NSObject

@property (nonatomic)  NSString* errorCode;
@property (nonatomic)  bool result;
@property (strong, nonatomic)  NSString *token;
@property (strong, nonatomic)  NSString *errorDescription;
@property (nonatomic)  NSString* cardStatus;

@property (nonatomic)  NSString* theNewMsisdn;

@property (nonatomic)  NSString* url3DSuccess;
@property (nonatomic)  NSString* url3D;
@property (nonatomic)  NSString* url3DError;
@property (nonatomic)  NSString* lastCardUniqueId;

@property (strong, nonatomic)  NSMutableArray<MfsCard>* cardList;


@end

#endif
