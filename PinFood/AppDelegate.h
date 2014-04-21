//
//  AppDelegate.h
//  PinFood
//
//  Created by Tanaka Koichi on 2014/04/08.
//  Copyright (c) 2014年 Tanaka Koichi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate>{
    UIWindow *window;
    UITabBarController *tabBarController;
	NSMutableArray *foodArray;
    UINavigationController *FoodListViewNav;
    UINavigationController *FoodMapViewNav;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) NSMutableArray *foodArray;

- (NSString *)documentPath;
- (void)checkAndCreateCacheDirectory;
- (void)recoverArray;
- (void)saveArray;
@end
