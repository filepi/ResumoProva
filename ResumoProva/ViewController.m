//
//  ViewController.m
//  ResumoProva
//
//  Created by Felipe da Silva Barbosa on 8/25/17.
//  Copyright © 2017 Felipe da Silva Barbosa. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"
#import "ServerAPI.h"
#import <SVProgressHUD.h>
#import <UIImageView+AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self loadTableView];
}

- (void)loadTableView{
    [SVProgressHUD show];
    [[ServerAPI sharedClient] getComments:^(NSArray *comments)
     {
         self.comments = comments;
         [self.tableMain reloadData];
         
     } andErrorBlock:^(NSError *error, AFHTTPRequestOperation *operation) {
         NSLog(@"Error:	%@",	error);
     }];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"forIndexPath:indexPath];
    NSDictionary *myObj = self.comments[ indexPath.row];
    cell.lblTitle.text = myObj[@"user"];
    cell.lblContent.text = myObj[@"content"];
    NSURL	*filePath	=	[NSURL URLWithString: myObj[@"image"] ];
    [cell.imgUser setImageWithURL:filePath placeholderImage:[UIImage imageNamed:@"place_user"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController * alert = [ UIAlertController
                                 alertControllerWithTitle: @"+ Info"
                                 message:@"Escolha uma das opções"
                                 preferredStyle: UIAlertControllerStyleActionSheet
                                 ];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Apagar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //processo apagar
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *urlApagar =  [NSString stringWithFormat:@"https://teste-aula-ios.herokuapp.com/comments/%@.json", self.comments[indexPath.row][@"id"]];
        
        [manager DELETE:urlApagar
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject)
                {
                    [self loadTableView];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
                {
                    NSLog(@"Error: %@", error);
                }];
    }];
    /*
     
    UIAlertAction *detalharAction = [UIAlertAction actionWithTitle:@"Detalhar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:viewDetail animated:YES];
    }];
     */
    
    UIAlertAction *cancelarAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDefault handler:nil];
    
    
    [alert addAction:deleteAction];
    [alert addAction:cancelarAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end
