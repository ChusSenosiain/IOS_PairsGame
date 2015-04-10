//
//  MJSCCard.m
//  PairsGame
//
//  Created by María Jesús Senosiain Caamiña on 05/04/15.
//  Copyright (c) 2015 María Jesús Senosiain Caamiña. All rights reserved.
//

#import "MJSCCard.h"

@implementation MJSCCard



-(id) initWithId:(NSNumber *) idCard
       imagePath:(NSString *)imagePath {
    
    if (self = [super init]) {
        _idCard = idCard;
        _imagePath = imagePath;
    }

    return self;
}

@end
