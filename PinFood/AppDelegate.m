//
//  AppDelegate.m
//  PinFood
//
//  Created by Tanaka Koichi on 2014/04/08.
//  Copyright (c) 2014年 Tanaka Koichi. All rights reserved.
//

#import "AppDelegate.h"
#import "FoodListViewController.h"
#import "FoodMapViewController.h"

@implementation AppDelegate

@synthesize window, tabBarController, foodArray;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self recoverArray];

    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    
    // Making ViewControllers
    FoodListViewController *FoodListView = [[FoodListViewController alloc] initWithNibName:nil bundle:nil];
    FoodListViewNav = [[UINavigationController alloc] initWithRootViewController:FoodListView];
    FoodMapViewController *FoodMapView = [[FoodMapViewController alloc] initWithNibName:nil bundle:nil];
    FoodMapViewNav = [[UINavigationController alloc] initWithRootViewController:FoodMapView];
    
    // Set NSArray to tabBarController
    NSArray *controllers = [NSArray arrayWithObjects:FoodListViewNav, FoodMapViewNav, nil];
    [tabBarController setViewControllers:controllers];
    
    
    // Set Title to Tab
    NSArray *items = tabBarController.tabBar.items;
    [[items objectAtIndex:0] setTitle:@"FoodView"];
    [[items objectAtIndex:1] setTitle:@"FoodMap"];

    // Set the first view after aunching
    window.rootViewController = tabBarController;
    
    // set white as backgroundColor
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    
    [self checkAndCreateCacheDirectory];
    
    return YES;
    
}

- (NSMutableArray *)foodArray {
	
	if (foodArray != nil) {
		return foodArray;
	}
	foodArray = [[NSMutableArray alloc] initWithCapacity:20];
	return foodArray;
}

- (void)checkAndCreateCacheDirectory {
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *pathPhoto = [[self documentPath] stringByAppendingPathComponent:@"photo"];
    NSString *pathThumbnail = [[self documentPath] stringByAppendingPathComponent:@"thumbnail"];
	
	if (![fileManager fileExistsAtPath:pathPhoto]) {
		[fileManager createDirectoryAtPath:pathPhoto withIntermediateDirectories:NO attributes:nil error:nil];
		[fileManager createDirectoryAtPath:pathThumbnail withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

//get documetPath use NSDocumentDirectory defined in NSPathUtilities.h
- (NSString *)documentPath {
    //NSUserDomainMask is homedirectory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

//get food data
- (void)recoverArray {
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [[self documentPath] stringByAppendingPathComponent:@"foodArray.dat"];
	
	if ([fileManager isReadableFileAtPath:path]) {
		NSMutableArray *recoveredArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
		self.foodArray = recoveredArray;
	}
    
}

//Save foodArray
- (void)saveArray {
    NSLog(@"self.foodArray%@",self.foodArray);
	NSString *path = [[self documentPath] stringByAppendingPathComponent:@"foodArray.dat"];
	[NSKeyedArchiver archiveRootObject: self.foodArray toFile:path];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveArray];
}

@end
