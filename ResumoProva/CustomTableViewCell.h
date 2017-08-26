//
//  CustomTableViewCell.h
//  ResumoProva
//
//  Created by Felipe da Silva Barbosa on 8/25/17.
//  Copyright © 2017 Felipe da Silva Barbosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblContent;

@end
