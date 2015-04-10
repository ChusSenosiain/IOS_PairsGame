//
//  MJSCCards.m
//  PairsGame
//
//  Created by María Jesús Senosiain Caamiña on 05/04/15.
//  Copyright (c) 2015 María Jesús Senosiain Caamiña. All rights reserved.
//

#import "MJSCCards.h"
#import "MJSCCard.h"

@interface MJSCCards()
@property(nonatomic, readonly) NSArray* cards;
@end

@implementation MJSCCards

-(id) init {
    
    if (self = [super init]) {
        _cards = [self createCards];
        _cardCount = [self.cards count];
    }
   
    return self;
}


-(NSUInteger)cardCount {
    return [self.cards count];
}

-(MJSCCard *) cardAtIndex:(NSUInteger)index {
    return [self.cards objectAtIndex:index];
}


-(NSArray *) createCards {
    
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    
    NSString *bundleDir = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *error = nil;
    
    NSArray *bundleContents = [fm contentsOfDirectoryAtPath:bundleDir error:&error];
    
    if (!error) {
        NSPredicate *bundleFilters = [NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg' OR self ENDSWITH '.png' OR self ENDSWITH '.jpeg'"];
        
        NSArray *images = [bundleContents filteredArrayUsingPredicate:bundleFilters];
        
        // crear carta por duplicado
        for (int i = 0; i < [images count]; i++) {
            
             if (![[images objectAtIndex:i] isEqualToString:@"naipe.png"]) {
                
                for (int j = 0; j < 2; j++) {
                
                    NSString *filePath = [[bundleDir stringByAppendingString:@"/"] stringByAppendingString:[images objectAtIndex:i]];
                
                    MJSCCard *card = [[MJSCCard alloc] initWithId:[NSNumber numberWithInt:i] imagePath:filePath];
                    [cards addObject:card];
                }
            }
         }
        
        // Ordenar la array de forma aleatoria
        NSUInteger count = [cards count];
        for (NSUInteger i = 0; i < count; i++) {
            NSInteger remainingCount = count - i;
            NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
            [cards exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
        }
    }
    
    return cards.copy;
}


@end
