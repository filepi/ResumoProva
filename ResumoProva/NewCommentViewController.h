//
//  NewCommentViewController.h
//  ResumoProva
//
//  Created by Felipe da Silva Barbosa on 8/26/17.
//  Copyright © 2017 Felipe da Silva Barbosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCommentViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imgUpload;
@property (strong, nonatomic) IBOutlet UIButton *btnImagePicker;

@end
