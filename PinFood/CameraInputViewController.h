//
//  CameraInputViewController.h
//  PinFood
//
//  Created by Tanaka Koichi on 2014/04/09.
//  Copyright (c) 2014年 Tanaka Koichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FormatterUtil.h"

@interface CameraInputViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate> {
	
	UIImage *photo;
	UIImage *thumbnail;
	UIImageView *photoImageView;
	UITableView *tableView;
	UIView *tableHeaderPhotoView;
	UITextField *titleTextField;
	UITextView *noteTextView;
	UINavigationBar *navigationBar;
	UIBarButtonItem *saveButton;
	CLLocationManager *locationManager;
    UITableView *InputtableView;
    NSMutableDictionary *photoinfo;
    NSMutableDictionary *meta;
}

@property (nonatomic, retain) UIImage *photo;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) UIImageView *photoImageView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *tableHeaderPhotoView;
@property (nonatomic, retain) UITextField *titleTextField;
@property (nonatomic, retain) UITextView *noteTextView;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UITableView *InputtableView;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, retain) NSMutableDictionary *photoinfo;
@property (nonatomic, retain) NSMutableDictionary *meta;

- (void)cancel;
- (void)save;
- (void)updateTitle;
- (UIImage *)imageByCroppedSqare:(float)length;
@end
