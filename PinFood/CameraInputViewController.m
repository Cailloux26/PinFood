//
//  CameraInputViewController.m
//  PinFood
//
//  Created by Tanaka Koichi on 2014/04/09.
//  Copyright (c) 2014年 Tanaka Koichi. All rights reserved.
//

#import "CameraInputViewController.h"
#import "AppDelegate.h"

@interface CameraInputViewController ()

@end

@implementation CameraInputViewController
@synthesize photo, thumbnail, photoImageView, tableView, titleTextField, noteTextView, InputtableView, singleTap, tableHeaderPhotoView, navigationBar, saveButton, locationManager, photoinfo, meta;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView {
    [super loadView];

    // title
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(24, 61, 49, 21)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont fontWithName:@"Lato-Bold" size:22];
    title.text = @"MEMO";
    title.textColor = [self hexToUIColor:@"ffffff" alpha:1];
    UIColor *color = [UIColor grayColor];
    title.layer.shadowColor = [color CGColor];
    title.layer.shadowRadius = 3.0f;
    title.layer.shadowOpacity = 1;
    title.layer.shadowOffset = CGSizeZero;
    title.layer.masksToBounds = NO;
    self.navigationItem.titleView = title;

    //NavigationBar
    UIImage *navBGImage = [UIImage imageNamed:@"header_bg.png"];
    CGFloat width = 320;
    CGFloat height = 44;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [navBGImage drawInRect:CGRectMake(0, 0, width, height)];
    navBGImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    // cancel button
    UIBarButtonItem* CancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    CancelButton.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:navBGImage forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = CancelButton;
    // save button
    UIBarButtonItem* SaveButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    SaveButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = SaveButton;
    
    // table view
    InputtableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    InputtableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    InputtableView.dataSource = self;
    InputtableView.delegate = self;
    
    // table header
    tableHeaderPhotoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,220)];
    tableHeaderPhotoView.backgroundColor = [UIColor whiteColor];
    photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    [tableHeaderPhotoView addSubview:photoImageView];
    InputtableView.tableHeaderView = nil;
    InputtableView.tableHeaderView = tableHeaderPhotoView;
    [self.view addSubview:InputtableView];
    
    // input title
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    titleTextField.borderStyle = UITextBorderStyleRoundedRect;
    titleTextField.textColor = [UIColor blueColor];
    titleTextField.placeholder = @"please input title";
    titleTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    // input note
    CGRect rect = CGRectMake(0, 0, 200, 200);
    noteTextView = [[UITextView alloc]initWithFrame:rect];
    noteTextView.editable = YES;
    noteTextView.text = @"";
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect frame =  photoImageView.frame;
	frame.origin.x = (tableHeaderPhotoView.bounds.size.width/2) - 100;
	frame.origin.y = 10;
	photoImageView.frame = frame;
	thumbnail = [self imageByCroppedSqare:200];
	photoImageView.image = thumbnail;
	[tableHeaderPhotoView addSubview:photoImageView];
	noteTextView.font = [UIFont systemFontOfSize:18.0];
	[[self locationManager] startUpdatingLocation];
    
    
    // define single tap gesture to close keyboard
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    singleTap.delegate = self;
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    photoinfo = [[NSMutableDictionary alloc]init];
    meta = [[NSMutableDictionary alloc]init];
    
}
// single tap recognizer
-(void)onSingleTap:(UITapGestureRecognizer *)recognizer{
    [titleTextField resignFirstResponder];
    [noteTextView resignFirstResponder];
}
// singletap works only when keyboard opens.
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == singleTap) {
        if (titleTextField.isFirstResponder || noteTextView.isFirstResponder) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	[self.titleTextField becomeFirstResponder];
}

// define table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if (section == 0) {
		return @"title";
	}
	else if (section == 1) {
		return @"note";
	}
	return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {
		return 44.0;
	} else if (indexPath.section == 1) {
		return 88.0;
	}
	return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EntryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (indexPath.section == 0) {
		CGRect frame =  self.titleTextField.frame;
		frame.origin.x = 10.0;
		self.titleTextField.frame = frame;
		[cell.contentView addSubview:titleTextField];
	}
	else if (indexPath.section == 1) {
		[cell.contentView addSubview:noteTextView];
	}
    return cell;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if ([string length] > 0) {
		self.saveButton.enabled = YES;
	}
	else {
		self.saveButton.enabled = NO;
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)updateTitle {
	navigationBar.topItem.title = titleTextField.text;
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)save {
	
	NSDate *date = [NSDate date];
    
	// ID
	srand(time(nil));
	int num = rand() % 100;
	int sec = (double)[date timeIntervalSince1970];
	NSString *anId = [NSString stringWithFormat:@"%d%d", sec, num];
	[photoinfo setObject:anId forKey:@"id"] ;
    NSLog(@"%@",anId);
	
    //Exif
    NSMutableDictionary *exif = meta[(NSString *)kCGImagePropertyExifDictionary];
    
	// location
    if(![photoinfo objectForKey:@"latitude"]){
        CLLocation *location = [locationManager location];
        if (!location) return;
        CLLocationCoordinate2D coordinate = [location coordinate];
        [photoinfo setObject:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"latitude"];
        [photoinfo setObject:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"longitude"];
        meta[(NSString *)kCGImagePropertyGPSDictionary] = [self GPSDictionaryForLocation:location];
        [photoinfo setObject:date forKey:@"date"];
    }
    
    // save a photo with title and note to documentPath.
	[photoinfo setObject:titleTextField.text forKey:@"title"];
	[photoinfo setObject:noteTextView.text forKey:@"note"];
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSData *pngPhoto = UIImagePNGRepresentation(photo);
	[pngPhoto writeToFile:[NSString stringWithFormat:@"%@/photo/%@@2x.png", [appDelegate documentPath], anId] atomically:NO];
	NSData *pngTumbnail = UIImagePNGRepresentation(thumbnail);
	[pngTumbnail writeToFile:[NSString stringWithFormat:@"%@/thumbnail/%@@2x.png", [appDelegate documentPath], anId] atomically:NO];
	[appDelegate.foodArray addObject:photoinfo];
	[appDelegate saveArray];
	
    // save a photo to camera roll
    
    NSData *imageData = [self createImageDataFromImage:photo metaData:meta];
    NSString *fileName = [self fileNameByExif:exif];
    [self storeFileAtDocumentDirectoryForData:imageData fileName:fileName];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary writeImageToSavedPhotosAlbum:photo.CGImage metadata:meta completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"Save image failed. %@", error);
        }
    }];
    NSString *exportPath = [NSString stringWithFormat:@"%@/export.jpg", [[NSBundle mainBundle] resourcePath]];
	NSLog(@"exportPath : %@", exportPath);
	[imageData writeToFile:exportPath atomically:YES];
    
    // close
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (CLLocationManager *)locationManager {
	
    if (locationManager != nil) {
		return locationManager;
	}
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[locationManager setDelegate:self];
	
	return locationManager;
}

- (NSData *)createImageDataFromImage:(UIImage *)image metaData:(NSDictionary *)metadata
{
    NSMutableData *imageData = [NSMutableData new];
    CGImageDestinationRef dest = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imageData, kUTTypeJPEG, 1, NULL);
    CGImageDestinationAddImage(dest, image.CGImage, (__bridge CFDictionaryRef)metadata);
    CGImageDestinationFinalize(dest);
    CFRelease(dest);
    
    return imageData;
}
- (void)storeFileAtDocumentDirectoryForData:(NSData *)data fileName:(NSString *)fileName
{
    NSString *documentDirectory = [self documentDirectory];
    
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    [data writeToFile:filePath atomically:YES];
}

- (NSString *)fileNameByExif:(NSDictionary *)exif
{
    if (!exif) {
        return nil;
    }
    NSString *dateTimeString = exif[(NSString *)kCGImagePropertyExifDateTimeOriginal];
    NSDate *date = [[FormatterUtil exifDateFormatter] dateFromString:dateTimeString];
    
    NSString *fileName = [[[FormatterUtil fileNameDateFormatter] stringFromDate:date] stringByAppendingPathExtension:@"jpg"];;
    
    return fileName;
}
- (NSString *)documentDirectory
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = nil;
    if (documentDirectories.count > 0) {
        documentDirectory = documentDirectories[0];
    }
    
    return documentDirectory;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage *)imageByCroppedSqare:(float)point {
    
	float point2x = point*2;
	CGImageRef imageRef = [self.photo CGImage];
	size_t width = CGImageGetWidth(imageRef);
	size_t height = CGImageGetHeight(imageRef);
	float resizeHeight;
	float resizeWidth;
	BOOL isWidthLong;
    
	if (width < height) {
		resizeWidth  = point2x;
		resizeHeight = height * resizeWidth / width;
		isWidthLong = NO;
	}
	else {
		resizeHeight = point2x;
		resizeWidth  = width * resizeHeight / height;
		isWidthLong = YES;
	}
    
	UIGraphicsBeginImageContext(CGSizeMake(resizeWidth, resizeHeight));
	[self.photo drawInRect:CGRectMake(0.0, 0.0, resizeWidth, resizeHeight)];
	self.photo = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	CGRect rect = CGRectMake(0.0, 0.0, point2x, point2x);
	CGImageRef cgImage = CGImageCreateWithImageInRect(self.photo.CGImage, rect);
	UIImage *croppedImage;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
		croppedImage = [UIImage imageWithCGImage:cgImage scale:2.0 orientation:UIImageOrientationUp];
	}
	else {
		croppedImage = [UIImage imageWithCGImage:cgImage];
	}
    
	CGImageRelease(cgImage);
	return croppedImage;
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
