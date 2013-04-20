//
//  SMFirstViewController.h
//  SpaceMars
//
//  Created by Adam Thompson on 13-04-20.
//  Copyright (c) 2013 Adam Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMFirstViewController : UIViewController {
    
    UIImageView* background;
    
    
    //REPORT VARS
    NSMutableData* feed;
    
    NSMutableArray* masterReports;
    
    int currentPage;
    
    bool isDownloaded;
    
    //SIMULATOR IU
    
    UILabel* currentDate;
    UILabel* currentTemp;
    UILabel* totalEnergyUsed;
    
    
    bool isDay;

    
    double minMarsTemp;
    double maxMarsTemp;
    double currentMarsTemp;
    
    int recordIndex;
    
    UIButton* nextButton;
    
    UIView* liquidChlorineBar_blue;
    UIView* liquidChlorineBar_yellow;
    UIView* gasChlorineBar;
    
    
    //$1 / kg chlorine
    
    
}

@end
