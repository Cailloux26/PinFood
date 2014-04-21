//
//  FoodMapViewController.m
//  PinFood
//
//  Created by Tanaka Koichi on 2014/04/08.
//  Copyright (c) 2014年 Tanaka Koichi. All rights reserved.
//

#import "FoodMapViewController.h"
#import "AppDelegate.h"
#import "Annotation.h"

@interface FoodMapViewController ()

@end

@implementation FoodMapViewController
@synthesize mapView, mapAnnotations, thumbnailBaseView, thumbnailAreaView, locationManager;

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
    
    // Background
    UIImage *BaseImage = [UIImage imageNamed:@"backgroung.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:BaseImage];
    
    // navigation
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(24, 61, 49, 21)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont fontWithName:@"Lato-Bold" size:22];
    title.text = @"FoodMap";
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
    
    //MapView
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10,10,300,400)];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    //thumnail
    thumbnailAreaView = [[UIView alloc]initWithFrame:CGRectMake(0, 400, 320, 100)];
    
    //thumbnailBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 400, 320, 100)];
    [self.view addSubview:thumbnailAreaView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter = kCLHeadingFilterNone;
    
    [mapView setShowsUserLocation:YES];
    
    // 現在地を取得する
    CLLocation* location;
    location = locationManager.location;
    
    // Do any additional setup after loading the view.
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = location.coordinate.latitude;
    newRegion.center.longitude = location.coordinate.longitude;
    newRegion.span.latitudeDelta = 14.2;
    newRegion.span.longitudeDelta = 14.2;
    
    mapView.scrollEnabled = YES;
	mapView.zoomEnabled = YES;
	[self.mapView setRegion:newRegion animated:YES];
    
}
- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	[self addAnnotations];
}
- (void)addAnnotations {
	
	[self.mapView removeAnnotations:self.mapView.annotations];
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	int maxCount = 6;
	int arrayCount = [appDelegate.foodArray count];
	int annotaionCount = arrayCount > maxCount ? maxCount : arrayCount;
	int offset = arrayCount - annotaionCount;
	
	self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:annotaionCount];
	
	static float margin = 4.0;
	static float thumbnailFrameSize = 46.0;
	float thumbnailBaseViewWidth = annotaionCount * (thumbnailFrameSize + margin) + margin;
	self.thumbnailBaseView = [[UIView alloc] initWithFrame:CGRectMake((320.0 - thumbnailBaseViewWidth) / 2.0, 0.0, thumbnailBaseViewWidth, thumbnailFrameSize + (margin * 2))];
    
	NSDictionary *dictionary;
	for (int i = 0; i < annotaionCount; i++) {
		
		// annotation
		dictionary = [appDelegate.foodArray objectAtIndex:i + offset];
		Annotation *annotation = [[Annotation alloc] init];
		annotation.latitude = [dictionary objectForKey:@"latitude"];
		annotation.longitude = [dictionary objectForKey:@"longitude"];
		annotation.title = [dictionary objectForKey:@"title"];
		
		NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
		[outputFormatter setDateFormat:@"MM/dd HH:mm"];
		annotation.subtitle = [outputFormatter stringFromDate:[dictionary objectForKey:@"date"]];
		[self.mapAnnotations addObject:annotation];
        
		// thumbnail
		UIImageView *thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(1.0, 1.0, 44.0, 44.0)];
		NSString *thumbnailPath = [NSString stringWithFormat:@"%@/thumbnail/%@@2x.png", [appDelegate documentPath], [dictionary objectForKey:@"id"]];
		thumbnail.image = [UIImage imageWithContentsOfFile:thumbnailPath];
		
		UIView *thumbnailFrameView = [[UIView alloc] initWithFrame:CGRectMake(margin + (i * (thumbnailFrameSize + margin)), margin, thumbnailFrameSize, thumbnailFrameSize)];
		thumbnailFrameView.backgroundColor = [UIColor whiteColor];
		[thumbnailFrameView addSubview:thumbnail];
		
		[self.thumbnailBaseView addSubview:thumbnailFrameView];
	}
	self.thumbnailAreaView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
	[self.thumbnailAreaView addSubview:self.thumbnailBaseView];
	[self.mapView addAnnotations:self.mapAnnotations];
    
    [self adjustCenterOfAnnotions];
}
- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	MKPinAnnotationView *annotationView;
	NSString* identifier = @"Pin";
	annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	
	if(annotationView == nil) {
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
		annotationView.animatesDrop = YES;
		annotationView.canShowCallout = YES;
		UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		[rightButton addTarget:self
						action:@selector(showDetails:)
			  forControlEvents:UIControlEventTouchUpInside];
		annotationView.rightCalloutAccessoryView = rightButton;
	}
	return annotationView;
}
- (void)adjustCenterOfAnnotions{
    double minLat = 9999.0;
    double minLng = 9999.0;
    double maxLat = -9999.0;
    double maxLng = -9999.0;
    double lat, lng;
    for (id<MKAnnotation> annotation in mapView.annotations){
        lat = annotation.coordinate.latitude;
        lng = annotation.coordinate.longitude;
        if(minLat > lat)
            minLat = lat;
        if(lat > maxLat)
            maxLat = lat;
        
        if(minLng > lng)
            minLng = lng;
        if(lng > maxLng)
            maxLng = lng;
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((maxLat + minLat) / 2.0, (maxLng + minLng) / 2.0);
    MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat, maxLng - minLng);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
}
- (void)showDetails:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
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
