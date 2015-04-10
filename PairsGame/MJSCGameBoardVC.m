//
//  MJSCGameBoardVC.m
//  PairsGame
//
//  Created by María Jesús Senosiain Caamiña on 05/04/15.
//  Copyright (c) 2015 María Jesús Senosiain Caamiña. All rights reserved.
//

#import "MJSCGameBoardVC.h"
#import "MJSCCards.h"
#import "MJSCGameCell.h"
#import "MJSCCard.h"
#import "UIColor+HexString.h"


#define kCellIdentifier @"kCellIdentifier"
#define kCellMargin 10
#define kColumns 4
#define kBorderWidth 2
#define kTitle @"Classic Pairs!"


@interface MJSCGameBoardVC () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) MJSCCards *cards;
@property (weak, nonatomic) IBOutlet UICollectionView *gameBoard;
@property (nonatomic, strong) MJSCCard *card1;
@property (nonatomic, strong) MJSCCard *card2;
@property (nonatomic, strong) NSIndexPath *position1;
@property (nonatomic, strong) NSIndexPath *position2;
@property (nonatomic, strong) NSMutableDictionary *discovered;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *startDateTime;


@end

@implementation MJSCGameBoardVC


-(id)initWithCards:(MJSCCards *) cards {
    
    if (self = [super init]) {
        _cards = cards;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBoard];
    
    self.title = kTitle;
}


-(void)start {
    // Comienzo la partida porque es la primera que descubro
    self.discovered = [[NSMutableDictionary alloc] init];
    // Inicia el temporizador
    self.startDateTime = [NSDate date];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(showTotalTime)
                                                userInfo:nil
                                                 repeats:YES];
}

-(void)finish {
    
    // Detengo el contador
    [self.timer invalidate];
    self.title = kTitle;
    
    // Muestro el tiempo
    NSString *totalTime = [self calculateTimeFromStart];
    NSString *message = [NSString stringWithFormat:@"Enhora buena chaval! Has tardado: %@ ¿Quieres volver a jugar?", totalTime];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Toma!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"Povale" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self resetCards];
    }];
    
    [alert addAction:actionOK];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)resetCards {
    
    for (id indexPath in self.discovered) {
        [self animateCell:indexPath show:NO];
    }
    
    self.discovered = nil;
    self.cards = [[MJSCCards alloc] init];
    [self.gameBoard reloadData];
}

-(void)hideSelectedCards {
    
    if (self.position1) {
        [self animateCell:self.position1 show:NO];
        [self.discovered removeObjectForKey:self.position1];
    }
    
    if (self.position2) {
        [self animateCell:self.position2 show:NO];
        [self.discovered removeObjectForKey:self.position2];
    }
    
    self.card1 = nil;
    self.card2 = nil;
    self.position1 = nil;
    self.position2 = nil;
    
}


-(void)animateCell:(NSIndexPath *) indexPath
              show:(BOOL) show {
    
    MJSCGameCell *cell = [self.gameBoard cellForItemAtIndexPath:indexPath];
    MJSCCard *card = [self.cards cardAtIndex:indexPath.row];
    
    UIImage *image;
    if (show) {
        image = [[UIImage alloc] initWithContentsOfFile:card.imagePath];
    } else {
        image = [UIImage imageNamed:@"naipe.png"];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        cell.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0f, 10.0f, 0.0f);
    } completion:^(BOOL finished) {
        cell.cardImageView.image = image;
        //cell.cardImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 10.0f, 0.0f);
        [UIView animateWithDuration:0.3f animations:^{
            cell.layer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 10.0f, 0.0f);
        }];
        
    }];
}


-(void)configureBoard {
    
    [self.gameBoard registerNib:[UINib nibWithNibName:@"MJSCGameCell" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    self.gameBoard.delegate = self;
    self.gameBoard.dataSource = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(kCellMargin, kCellMargin, kCellMargin, kCellMargin);
    self.gameBoard.collectionViewLayout = layout;
    self.gameBoard.scrollEnabled = false;
    self.gameBoard.backgroundColor = [UIColor colorWithHexString:@"#009688"];
    
}


-(void)showTotalTime {
    self.title = [self calculateTimeFromStart];
}



-(NSString *)calculateTimeFromStart {
    
    NSTimeInterval totalTime = [[NSDate date] timeIntervalSinceDate:self.startDateTime];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:totalTime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    return [formatter stringFromDate:date];
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section {
    
    return self.cards.cardCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MJSCGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    MJSCCard *card = [self.cards cardAtIndex:indexPath.row];

    // Round corners
    cell.cardImageView.layer.cornerRadius = 4.0f;
    cell.cardImageView.clipsToBounds = YES;
    cell.cardImageView.layer.borderWidth = kBorderWidth;
    cell.cardImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.cardImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // Comprobar si están descubiertos o no
    if ([self.discovered objectForKey:indexPath]) {
        cell.cardImageView.image = [[UIImage alloc] initWithContentsOfFile:card.imagePath];
    } else {
        cell.cardImageView.image = [UIImage imageNamed:@"naipe.png"];
    }
    
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Obtener el valor de la carta
    MJSCCard *card = [self.cards cardAtIndex:indexPath.row];

    if (!self.discovered) {
        [self start];
    }

    // No esta descubierto: es una nueva
    if (![self.discovered objectForKey:indexPath]) {
        
        // Si ya hay dos cartas descubiertas no coincidentes las cubro
        if (self.card2) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideSelectedCards) object: nil];
            [self hideSelectedCards];
        }
        
        // Descubro la carta
        //[self showCell:indexPath collectionView:collectionView];
        [self animateCell:indexPath show:YES];
        [self.discovered setObject:card forKey:indexPath];
        
        
        if (!self.card1) {
            self.card1 = card;
            self.position1 = indexPath;
        } else {
            self.card2 = card;
            self.position2 = indexPath;
        }
        
        // Comparo los valores
        if (self.card1 && self.card2) {
            // Son distintas se vuelven a cubrir
            if (self.card1.idCard != self.card2.idCard) {
                [self performSelector:@selector(hideSelectedCards) withObject:nil afterDelay:1.5f];
            } else {
                self.card1 = nil;
                self.card2 = nil;
                self.position1 = nil;
                self.position2 = nil;
            }
            
            // Si ya están todas descubiertas
            if (self.discovered.count == self.cards.cardCount) {
                [self finish];
            }
        }
        
    }
    
}

// Hacer dinámico el tamaño de las celdas
-(CGSize) collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Tengo 24 items, distribuir 4 columnas por 6 filas
    NSUInteger elementos = self.cards.cardCount;
    
    NSUInteger rows = elementos / kColumns;
    float boardWidth = self.gameBoard.frame.size.width - (kCellMargin * (kColumns + 1));
    float boardHeigh = self.gameBoard.frame.size.height - (kCellMargin * (rows + 1));
    
    float cellWith = boardWidth / kColumns;
    float cellHeght = boardHeigh / rows;
    
    return CGSizeMake(cellWith - kCellMargin, cellHeght - kCellMargin);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionView *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCellMargin;
}




@end
