//
//  NewCommentViewController.m
//  ResumoProva
//
//  Created by Felipe da Silva Barbosa on 8/26/17.
//  Copyright © 2017 Felipe da Silva Barbosa. All rights reserved.
//

#import "NewCommentViewController.h"
#import <MapKit/MapKit.h>



@interface NewCommentViewController ()

@end

@implementation NewCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)btnCadastrar:(id)sender {
}

- (IBAction)loadImage:(id)sender {
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if ([mediaType isEqualToString:@"public.image"]) {
        editedImage = (UIImage *) [info objectForKey:  UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:  UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        }
        else {
            imageToSave = originalImage;
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil , nil);
        self.imgUpload.image = imageToSave;
        [self.btnImagePicker setHidden:YES];
        [self.imgUpload setHidden:NO];
    }
    
    // Handle a movie capture
    if ([mediaType isEqualToString:@"public.movie"]) {
        
        NSString *moviePath = [[info objectForKey: UIImagePickerControllerMediaURL] path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller  usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate {
    if (([UIImagePickerController isSourceTypeAvailable:  UIImagePickerControllerSourceTypePhotoLibrary] == NO)
        || (delegate == nil)
        || (controller == nil))  return NO;
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];  cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypePhotoLibrary];
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    [controller presentViewController: cameraUI animated: YES completion:nil];  return YES;
}


@end
