//
//  NewCommentViewController.h
//  ResumoProva
//
//  Created by Felipe da Silva Barbosa on 8/26/17.
//  Copyright © 2017 Felipe da Silva Barbosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NewCommentViewController : UIViewController
        <UIImagePickerControllerDelegate,
         UINavigationControllerDelegate,
         CLLocationManagerDelegate,
         MKMapViewDelegate,
         UITextFieldDelegate>

@property (strong, nonatomic) MKLocalSearch *localSearch;
@property (strong, nonatomic) IBOutlet UIImageView *imgUpload;
@property (strong, nonatomic) IBOutlet UIButton *btnImagePicker;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UITextField *txtLocation;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextView *txtComment;
@property (strong, nonatomic) CLLocation *userLocation;
@end
