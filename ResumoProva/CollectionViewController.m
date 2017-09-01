//
//  CollectionViewController.m
//  ResumoProva
//
//  Created by Felipe da Silva Barbosa on 8/31/17.
//  Copyright © 2017 Felipe da Silva Barbosa. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionItemViewCell.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arraySemana = @[ @"Segunda", @"Terca", @"Quarta", @"Quinta", @"Sexta", @"Sabado", @"Domingo"];
    
    self.customView = [[[NSBundle mainBundle] loadNibNamed:@"CustomControlXIB" owner:self options:nil] objectAtIndex:0];
    
  [UIView transitionWithView:self.view duration:4.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
      [self.view addSubview:self.customView];
  } completion:^(BOOL finished) {

  }];
}

-(void)Vi

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    CollectionItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    cell.backgroundColor = UIColor.purpleColor;
    cell.title.text = self.arraySemana[indexPath.row];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arraySemana.count;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
