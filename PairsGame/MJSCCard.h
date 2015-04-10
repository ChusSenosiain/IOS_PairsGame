//
//  MJSCCard.h
//  PairsGame
//
//  Created by María Jesús Senosiain Caamiña on 05/04/15.
//  Copyright (c) 2015 María Jesús Senosiain Caamiña. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MJSCCard : NSObject

@property (nonatomic, strong) NSNumber *idCard;
@property (nonatomic, copy) NSString *imagePath;


-(id) initWithId:(NSNumber *) idCard
       imagePath:(NSString *) imagePath;

@end
