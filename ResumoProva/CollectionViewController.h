//
//  CollectionViewController.h
//  ResumoProva
//
//  Created by Felipe da Silva Barbosa on 8/31/17.
//  Copyright © 2017 Felipe da Silva Barbosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController
<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray* arraySemana;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *customView;

@end
