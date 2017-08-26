//
//  ViewController.h
//  ResumoProva
//
//  Created by Felipe da Silva Barbosa on 8/25/17.
//  Copyright © 2017 Felipe da Silva Barbosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableMain;
@property (strong, nonatomic) NSArray * comments;


@end

