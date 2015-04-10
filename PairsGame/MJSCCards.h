//
//  MJSCCards.h
//  PairsGame
//
//  Created by María Jesús Senosiain Caamiña on 05/04/15.
//  Copyright (c) 2015 María Jesús Senosiain Caamiña. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MJSCCard;

@interface MJSCCards : NSObject

@property (nonatomic) NSUInteger cardCount;

-(MJSCCard *) cardAtIndex:(NSUInteger) index;

@end
