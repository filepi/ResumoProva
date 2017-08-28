//
//  NewCommentViewController.m
//  ResumoProva
//
//  Created by Felipe da Silva Barbosa on 8/26/17.
//  Copyright © 2017 Felipe da Silva Barbosa. All rights reserved.
//

#import "NewCommentViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface NewCommentViewController ()

@end

@implementation NewCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLocationService];
}

-(void)initLocationService{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager startUpdatingHeading];
    [self addGestureToMap];
}



- (IBAction)btnCadastrar:(id)sender {
        [SVProgressHUD show];
        AFHTTPRequestOperationManager	*manager	=	[AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSDictionary	*parameters	=	@{@"comment[user]":	self.txtUsername.text,
                                          @"comment[content]": self.txtComment.text,
                                          @"comment[lat]"  : [NSNumber numberWithDouble: self.userLocation.coordinate.latitude],
                                          @"comment[lng]" :  [NSNumber numberWithDouble: self.userLocation.coordinate.longitude]  };
        NSData *imageData = UIImageJPEGRepresentation(self.imgUpload.image,0.5);
    
        NSString * fileName = [self getCurrentDate];
        [manager
         POST:@"https://teste-aula-ios.herokuapp.com/comments.json"
         parameters:parameters
         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
             [formData appendPartWithFileData:imageData name:@"comment[picture]" fileName:[NSString stringWithFormat:@"img_%@.jpg",fileName ] mimeType:@"image/jpeg" ];
         }
         
         success:^(AFHTTPRequestOperation	*operation,	id responseObject)	{
             NSLog(@"JSON:	%@",	responseObject);
             [SVProgressHUD dismiss];
             [ self.navigationController popViewControllerAnimated:YES];
         }
         failure:^(AFHTTPRequestOperation	*operation,	NSError	*error)	{
             [SVProgressHUD dismiss];
             NSInteger * returnStatus = [operation.response statusCode];
             if(  returnStatus == 401 ) {
                 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                 NSLog(@"Rolou hein esse upload maroto!");
             }
             NSLog(@"Error:	%@",	error);
             NSLog(@"Error:	%@",	operation.responseString);
             
         }];
}

-(NSString * ) getCurrentDate{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
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

-(void)addGestureToMap{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMap:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.delaysTouchesBegan = YES;
    
    [tapGesture setCancelsTouchesInView:YES];
    [self.mapView addGestureRecognizer:tapGesture];
}

-(void)tapMap:(UITapGestureRecognizer *)recognizer{
    CGPoint touchPoint = [recognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    CLLocation *location  = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [self markPoint:location];
}

-(void)markPoint: (CLLocation*) lugar{
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lugar.coordinate.latitude, lugar.coordinate.longitude);
    NSString* placeFound = [self getCity:lugar];
    NSLog(@"Place atribuido é: %@", placeFound);
    point.title = placeFound;
    self.txtLocation.text = placeFound;
    point.coordinate = coordinate;
    [self.mapView addAnnotation:point];
}

-(NSString*)getCity: (CLLocation *) location {
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    __block CLPlacemark *placemark = nil;;
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        placemark = placemarks[0];
    }];
    NSLog(@"Retorno é %@", placemark.locality);
    return placemark.locality;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self startSearch:self.txtLocation.text];
    return NO;
}

-(void)startSearch:(NSString *)searchString {
    
    [SVProgressHUD show];
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchString;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error) {
        
        if (error != nil) {
            [self.localSearch cancel];
            self.localSearch = nil;
            NSLog(@"Erro");
        } else {
            if([response mapItems].count > 0){
                NSArray* arrayLocations = [response mapItems];
                MKMapItem* item = arrayLocations[0];
                self.userLocation = item.placemark.location;
                [self centerMap:item.placemark.location];
                [self markPoint:item.placemark.location];
                NSLog(@"%lu locations found ", (unsigned long)arrayLocations.count);
            }else{
                NSLog(@"No location found");
            }
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    if (self.localSearch != nil) {
        self.localSearch = nil;
    }
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD dismiss];
}

-(void)centerMap:(CLLocation *)location{
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = location.coordinate.latitude;
    newRegion.center.longitude = location.coordinate.longitude;
    newRegion.span.latitudeDelta = 0.0005;
    newRegion.span.longitudeDelta = 0.0005;
    [self.mapView setRegion:newRegion];
    
}
@end
