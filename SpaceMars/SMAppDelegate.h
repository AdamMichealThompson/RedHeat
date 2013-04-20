//
//  SMAppDelegate.h
//  SpaceMars
//
//  Created by Adam Thompson on 13-04-20.
//  Copyright (c) 2013 Adam Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
