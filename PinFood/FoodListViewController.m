//
//  FoodListViewController.m
//  PinFood
//
//  Created by Tanaka Koichi on 2014/04/08.
//  Copyright (c) 2014年 Tanaka Koichi. All rights reserved.
//

#import "FoodListViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface FoodListViewController ()

@end

@implementation FoodListViewController

@synthesize tableView, cameraInputViewController, imgPicker, photoinfo, metadata;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)loadView {
    [super loadView];
    
    // Background
    UIImage *BaseImage = [UIImage imageNamed:@"backgroung.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:BaseImage];

    // navigation
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(24, 61, 49, 21)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont fontWithName:@"Lato-Bold" size:22];
    title.text = @"PinFood";
    title.textColor = [self hexToUIColor:@"ffffff" alpha:1];
    UIColor *color = [UIColor grayColor];
    title.layer.shadowColor = [color CGColor];
    title.layer.shadowRadius = 3.0f;
    title.layer.shadowOpacity = 1;
    title.layer.shadowOffset = CGSizeZero;
    title.layer.masksToBounds = NO;
    self.navigationItem.titleView = title;
    UIImage *navBGImage = [UIImage imageNamed:@"header_bg.png"];
    CGFloat width = 320;
    CGFloat height = 44;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [navBGImage drawInRect:CGRectMake(0, 0, width, height)];
    navBGImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:navBGImage forBarMetrics:UIBarMetricsDefault];
    
    // table view
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    // Buttons
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"tabbar_camera.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushedCameraButton) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"camera" forState:UIControlStateNormal];
    button.frame = CGRectMake(250, self.view.bounds.size.height-110, 50, 50);//width and height should be same value
    CGSize imageSize = button.imageView.frame.size;
    button.imageEdgeInsets = UIEdgeInsetsMake(0.0, imageSize.width/2, 0.0, 0.0);
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 25;
    button.layer.borderColor=[UIColor blackColor].CGColor;
    button.layer.borderWidth=2.0f;
    [self.view addSubview:button];
    UIButton *abutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [abutton setImage:[UIImage imageNamed:@"photo_album.png"] forState:UIControlStateNormal];
    [abutton addTarget:self action:@selector(showLibrary:) forControlEvents:UIControlEventTouchUpInside];
    [abutton setTitle:@"album" forState:UIControlStateNormal];
    abutton.frame = CGRectMake(250, self.view.bounds.size.height-180, 50, 50);//width and height should be same value
    abutton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 8, 0.0, 0.0);
    abutton.clipsToBounds = YES;
    abutton.layer.cornerRadius = 25;
    abutton.layer.borderColor=[UIColor blackColor].CGColor;
    abutton.layer.borderWidth=2.0f;
    [self.view addSubview:abutton];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imgPicker = [[UIImagePickerController alloc] init];
	imgPicker.delegate = self;
    photoinfo = [[NSMutableDictionary alloc]init];
    
}

// Camera
- (void)pushedCameraButton {
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	imgPicker.showsCameraControls = YES;
    [self presentViewController:imgPicker animated:YES completion:nil];
}
// Album
- (void) showLibrary:(id)sender{
	imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imgPicker animated:YES completion: nil];
}
// after taking a pic or selecting a pic.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //meta
    metadata = info[UIImagePickerControllerMediaMetadata];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
        if (url) {
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
                CLLocation *location = [myasset valueForProperty:ALAssetPropertyLocation];
                if(location){
                    metadata[(NSString *)kCGImagePropertyGPSDictionary] = [self GPSDictionaryForLocation:location];
                    [photoinfo setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"latitude"];
                    [photoinfo setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
                    [photoinfo setObject:location.timestamp forKey:@"date"];
                }
            };
            ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror) {
                NSLog(@"cant get image - %@", [myerror localizedDescription]);
            };
            ALAssetsLibrary *assetsLib = [[ALAssetsLibrary alloc] init];
            [assetsLib assetForURL:url resultBlock:resultblock failureBlock:failureblock];
        }
    }
    //original image
    UIImage *photoImage = [info valueForKey:UIImagePickerControllerOriginalImage];

    [self dismissViewControllerAnimated:YES completion:nil];
	[self performSelector:@selector(showCameraInputView:) withObject:photoImage afterDelay:1.0];
}
// after taking a pic
- (void)showCameraInputView:(UIImage *)photo {
	self.cameraInputViewController = [[CameraInputViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *cameraInputNav = [[UINavigationController alloc]init];
    cameraInputNav = [[UINavigationController alloc] initWithRootViewController:self.cameraInputViewController];
	self.cameraInputViewController.photo = photo;
    self.cameraInputViewController.photoinfo = photoinfo;
    self.cameraInputViewController.meta = metadata;
    [self presentViewController:cameraInputNav animated:YES completion:nil];
}
// close imagePicker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:nil];
}

// define tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	return [appDelegate.foodArray count];
}
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FirstViewCell";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSDictionary *dictionary = [appDelegate.foodArray objectAtIndex:indexPath.row];
	cell.textLabel.text = [dictionary objectForKey:@"title"];
	cell.detailTextLabel.text = [(NSDate *)[dictionary objectForKey:@"date"] description];
    
	NSString *thumbnail = [NSString stringWithFormat:@"%@/thumbnail/%@@2x.png", [appDelegate documentPath], [dictionary objectForKey:@"id"]];
	cell.imageView.image = [UIImage imageWithContentsOfFile:thumbnail];
    return cell;
}

- (NSDictionary *)GPSDictionaryForLocation:(CLLocation *)location
{
    NSMutableDictionary *gps = [NSMutableDictionary new];
    
    // date
    gps[(NSString *)kCGImagePropertyGPSDateStamp] = [[FormatterUtil GPSDateFormatter] stringFromDate:location.timestamp];
    // timestamp
    gps[(NSString *)kCGImagePropertyGPSTimeStamp] = [[FormatterUtil GPSTimeFormatter] stringFromDate:location.timestamp];
    
    // latitude
    CGFloat latitude = location.coordinate.latitude;
    NSString *gpsLatitudeRef;
    if (latitude < 0) {
        latitude = -latitude;
        gpsLatitudeRef = @"S";
    } else {
        gpsLatitudeRef = @"N";
    }
    gps[(NSString *)kCGImagePropertyGPSLatitudeRef] = gpsLatitudeRef;
    gps[(NSString *)kCGImagePropertyGPSLatitude] = @(latitude);
    
    // longitude
    CGFloat longitude = location.coordinate.longitude;
    NSString *gpsLongitudeRef;
    if (longitude < 0) {
        longitude = -longitude;
        gpsLongitudeRef = @"W";
    } else {
        gpsLongitudeRef = @"E";
    }
    gps[(NSString *)kCGImagePropertyGPSLongitudeRef] = gpsLongitudeRef;
    gps[(NSString *)kCGImagePropertyGPSLongitude] = @(longitude);
    
    // altitude
    CGFloat altitude = location.altitude;
    if (!isnan(altitude)){
        NSString *gpsAltitudeRef;
        if (altitude < 0) {
            altitude = -altitude;
            gpsAltitudeRef = @"1";
        } else {
            gpsAltitudeRef = @"0";
        }
        gps[(NSString *)kCGImagePropertyGPSAltitudeRef] = gpsAltitudeRef;
        gps[(NSString *)kCGImagePropertyGPSAltitude] = @(altitude);
    }
    
    return gps;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIColor*) hexToUIColor:(NSString *)hex alpha:(CGFloat)a{
	NSScanner *colorScanner = [NSScanner scannerWithString:hex];
	unsigned int color;
	[colorScanner scanHexInt:&color];
	CGFloat r = ((color & 0xFF0000) >> 16)/255.0f;
	CGFloat g = ((color & 0x00FF00) >> 8) /255.0f;
	CGFloat b =  (color & 0x0000FF) /255.0f;
	//NSLog(@"HEX to RGB >> r:%f g:%f b:%f a:%f\n",r,g,b,a);
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
