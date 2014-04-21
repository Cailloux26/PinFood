//
//  FoodListViewController.h
//  PinFood
//
//  Created by Tanaka Koichi on 2014/04/08.
//  Copyright (c) 2014年 Tanaka Koichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraInputViewController.h"

@interface FoodListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIImagePickerController *imgPicker;
    CameraInputViewController *cameraInputViewController;
	UITableView *tableView;
    NSMutableDictionary *photoinfo;
    NSMutableDictionary *metadata;
}
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) CameraInputViewController *cameraInputViewController;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableDictionary *photoinfo;
@property (nonatomic, retain) NSMutableDictionary *metadata;

- (void)pushedCameraButton;
- (void)showLibrary:(id)sender;
- (void)showCameraInputView:(UIImage *)photo;

@end
