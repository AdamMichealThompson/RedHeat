//
//  SMFirstViewController.m
//  SpaceMars
//
//  Created by Adam Thompson on 13-04-20.
//  Copyright (c) 2013 Adam Thompson. All rights reserved.
//

#import "SMFirstViewController.h"



@interface SMFirstViewController ()

@end

@implementation SMFirstViewController

/*
 SpaceMars App
 
 Info available: 
 
 "abs_humidity" = "<null>";
 "atmo_opacity" = Sunny;
 ls = "293.8";
 "max_temp" = "3.05";
 "max_temp_fahrenheit" = "37.49";
 "min_temp" = "-69.47";
 "min_temp_fahrenheit" = "-93.05";
 pressure = "889.1799999999999";
 "pressure_string" = Higher;
 season = "Month 10";
 sol = 231;
 sunrise = "2013-04-03T11:00:00Z";
 sunset = "2013-04-03T22:00:00Z";
 "terrestrial_date" = "2013-04-03";
 "wind_direction" = E;
 "wind_speed" = 2;
 
 
 all of which is updated... infrequently, 
 last update was this month, on the 3rd.
 
 Never the less, it looks like this API will be updated with info as it becomes available.
 
 So what can I do with it?
 
 Visualisation is easy, but I'd like the use to have some sort of interaction.
 
 The best way I found to do that is through games.  So what simple game can I make that uses one or more data points from this report.
 
 I'd like to make a green energy game that allows the user to install systems like wind power generators, thermal power, pressure power?, solar power (obs)[atmo-opacity!]  
 Acutally, it seems most of the data does not change.
 -> The data that does reliably change:
 
 -Min/Max daily temp.
 -Pressure of atm.
 
 
 Okay, I'm going to make a simulator for a thermal power generation plant on MARS using real tempurature data
 
 Chemical: Chlorine
 Chlorine vaporizes during the day, spinning a turbine, and then cooling during Mars' long and cold night.
 
 
 Simulation parameters: $Budget, Generator Efficiency, min/max daily tempuratures.
 -Can I make the power output change with the variation in tempurature?
 
 -Guess: Higher max tempurature will cause a faster phase transition, causing a faster rotation of the turbine, and therefore more power.
 [This would be the focal point of interest, how does the performance of the plant vary from day to day?]
 
 
 
 
 RECAP: Okay, max temp [0 - 5] variation, creates power output variation
 -Would placement matter? probably not.
 ...not unless I wanted to add some sort of colonization.
 
 
 Alright, I'll start by mkaing this just a simple app.  U place one generator. Days pass.  U (might) make enough for a second one.
 
 -Maybe atmospheric pressure causes decay on the generator?
 
 What would be fun?
 For me, see how long survival
 
 
 
 
 Okay, Cam is helping me calculate the total energy produced by this reaction
 -The energy level will differ from day to day due to the difference in clorine temp.
 
 
 //Graphics
 I need a day/night cycle
 I need a powerplant
 
 
 */

-(void) advance12Hours {

    if (!isDownloaded) {
        return;
    }
    
    nextButton.enabled = false;
    
    NSDictionary* thisReport = [masterReports objectAtIndex:recordIndex];
    
    //NSLog(@"ThisReport: %@", thisReport );
    

    
    //Play animation
    
    
    //Do calculations
    //R = 8.314
    //M =  molar mass

    //load in new day data.
    
    //Day/Night cycle
    if (isDay) {
        //is day, becoming night
        isDay = !isDay;
        
        liquidChlorineBar_yellow.backgroundColor = [UIColor blueColor];
        
        totalEnergyUsed.text = [NSString stringWithFormat:@"Chlorine cools overnight"];
        [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            liquidChlorineBar_yellow.frame = CGRectMake(liquidChlorineBar_yellow.frame.origin.x, liquidChlorineBar_yellow.frame.origin.y - 99, 50, 100);
            
            gasChlorineBar.frame = CGRectMake(gasChlorineBar.frame.origin.x, gasChlorineBar.frame.origin.y, 50, 1);
            
            liquidChlorineBar_blue.alpha = 1;

        } completion:^(BOOL finished) {
            
            liquidChlorineBar_yellow.alpha = 0;
            liquidChlorineBar_yellow.backgroundColor = [UIColor yellowColor];
            nextButton.enabled = YES;
        }];
        
        
    } else {
        
        
        
        //was night, becoming day
        int min_temp = [[thisReport objectForKey:@"min_temp"] integerValue];
        int max_temp = [[thisReport objectForKey:@"max_temp"] integerValue];
        
        currentTemp.text = [NSString stringWithFormat:@"Today's Tempuratures min = %d , max = %d ", min_temp, max_temp];

        
        double hoursOfSun = 11;
        int chlorineBoilingPoint = -34;
        int massOfChlorine = 100000;//kg
        
        double temperatureRange = abs(min_temp) + max_temp;
        //assuming tempurature rises linearly, find t s.t. temp = -34
        
        //-34 = chlorine boiling point
        double differenceToBoiling = (chlorineBoilingPoint) - min_temp;
        
        //Assuming 11H days
        //hours per degree
        double rateOfTemperatureIncrease = hoursOfSun / temperatureRange;
        
        double timeTillBoil = differenceToBoiling * rateOfTemperatureIncrease;
        
        double timeOfOperation = hoursOfSun - timeTillBoil;
        
        //using 5C
        double maxDailyVelocity = 273;
        
        //will always start at the boiling point.
        double minDailyVelocity = 253;
        
        double averageDailyVelocity = (minDailyVelocity + maxDailyVelocity)/2.0;
        
        //assuming it takes 11Hours to boil 100 000 kg chlorine
        double megaWattsPerHour = (0.5 * massOfChlorine * pow( averageDailyVelocity, 2) ) / hoursOfSun;
        megaWattsPerHour /= 1000000;
        
        double megaWattsProducedToday = megaWattsPerHour * timeOfOperation;
        
        //NSLog(@"MegaWatts produced today: %.4f", megaWattsProducedToday);
        
        //NSLog(@"Data: timeTillBoil: %.1f OperationTime: %.1f AvgVelocity: %.1f mWpH: %.3f ", timeTillBoil, timeOfOperation, averageDailyVelocity, megaWattsPerHour);
        
        //
        
        //Estimations for velocities:
        // D Celcius | Velocity of chl
        //  = 5      | 273
        //  = -33    | 253
        // 
        
        totalEnergyUsed.text = @"The cooled chlorine is heated during the day...";
        
        [UIView animateWithDuration:timeTillBoil delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            liquidChlorineBar_yellow.alpha = 1;
            liquidChlorineBar_blue.alpha = 0;
        } completion:^(BOOL finished) {
            
            totalEnergyUsed.text = [NSString stringWithFormat:@"Avg. MegaWatts/Hour: %.1f",megaWattsPerHour];
            
            [UIView animateWithDuration:timeOfOperation delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                liquidChlorineBar_yellow.frame = CGRectMake(liquidChlorineBar_yellow.frame.origin.x, liquidChlorineBar_yellow.frame.origin.y + 99, 50, 1);
                
                gasChlorineBar.frame = CGRectMake(gasChlorineBar.frame.origin.x, gasChlorineBar.frame.origin.y, 50, 100);
                
            } completion:^(BOOL finished) {
                
                totalEnergyUsed.text = [NSString stringWithFormat:@"Mega Watts Today: %.1f",megaWattsProducedToday];
                nextButton.enabled = YES;
            }];
            
            
        }];
        
        
        currentDate.text = [thisReport objectForKey:@"terrestrial_date"];
        
        isDay = !isDay;
        recordIndex --;
        
        if (recordIndex < 0) {
            recordIndex = masterReports.count-1;
        }
    }
    

    
}

-(void) downloadWeather {
    NSLog(@"Weather Downloading...");
    
    
    
    NSString* urlString = @"http://marsweather.ingenology.com/v1/latest/?format=json";
    
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] delegate:self];
    
    
}
-(void) downloadWeatherHistoryPage:(int)page {
    //http://marsweather.ingenology.com/v1/archive/?page=3&format=json
    NSString* urlString = @"http://marsweather.ingenology.com/v1/archive/?page=";
    urlString = [urlString stringByAppendingFormat:@"%d&format=json", page];
    
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] delegate:self];

}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [feed setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [feed appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error description]);

    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError* myError = nil;
    NSMutableDictionary*json = [NSJSONSerialization JSONObjectWithData:feed options:NSJSONReadingMutableLeaves error:&myError];
    
    
    if (json == nil) {
        NSLog(@"Invalid JSON");
        
        nextButton.enabled =  YES;
        
        isDownloaded = true;
        recordIndex = masterReports.count - 1;
        return;
    } else {
        
        
        //NSLog(@"JSON: %@", json);
        NSMutableArray* report = [json objectForKey:@"results"];
        
        [masterReports addObjectsFromArray:(NSArray *)report];
        
        
        currentPage ++;
        [self downloadWeatherHistoryPage:currentPage];
    }
    


}


/*
 
 NSError* myError = nil;
 NSMutableDictionary*json = [NSJSONSerialization JSONObjectWithData:feed options:NSJSONReadingMutableLeaves error:&myError];
 */


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        feed = [[NSMutableData alloc] init];

        masterReports = [[NSMutableArray alloc] init];
        currentPage = 1;
        recordIndex = 0;
        isDownloaded = false;
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:background];
    background.frame = self.view.frame;
    
    //[self downloadWeather];
    [self downloadWeatherHistoryPage:currentPage];
    
    
    nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:nextButton];
    [nextButton setTitle:@"Advance 12 Hours" forState:UIControlStateNormal];
    [nextButton sizeToFit];
    nextButton.center = CGPointMake(self.view.frame.size.width - 85, 40);
    [nextButton addTarget:self action:@selector(advance12Hours) forControlEvents:UIControlEventTouchUpInside];
    
    
    currentDate = [[UILabel alloc] init];
    currentDate.font = [UIFont fontWithName:@"Futura" size:26];
    currentDate.backgroundColor = [UIColor clearColor];
    currentDate.text = @"MARS";
    currentDate.textColor = [UIColor whiteColor];
    [self.view addSubview:currentDate];
    currentDate.frame = CGRectMake(0, 0, 320, 60);
    
    currentTemp = [[UILabel alloc] init];
    currentTemp.font = [UIFont fontWithName:@"Futura" size:16];
    currentTemp.backgroundColor = [UIColor clearColor];
    currentTemp.numberOfLines = 2;
    currentTemp.text = @"Press Advance to start!";
    currentTemp.textColor = [UIColor whiteColor];
    [self.view addSubview:currentTemp];
    currentTemp.frame = CGRectMake(120, 120, 320-120, 80);
    
    totalEnergyUsed = [[UILabel alloc] init];
    totalEnergyUsed.numberOfLines = 3;
    totalEnergyUsed.font = [UIFont fontWithName:@"Futura" size:16];
    totalEnergyUsed.backgroundColor = [UIColor clearColor];
    totalEnergyUsed.text = @"|| Thermal Generator || Uses the boiling point of chlorine to move a turbine!";
    totalEnergyUsed.textColor = [UIColor whiteColor];
    [self.view addSubview:totalEnergyUsed];
    totalEnergyUsed.frame = CGRectMake(120, 200, 320-120, 120);
    
    nextButton.enabled =  NO;
    
    
    UIImageView* frame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"generator-frame"]];
    [self.view addSubview:frame];
    frame.frame = CGRectMake(35, self.view.frame.size.height - 450, 100, 400);
    
    liquidChlorineBar_blue = [[UIView alloc] initWithFrame:CGRectMake(60, self.view.frame.size.height - 200, 50, 100)];
    liquidChlorineBar_blue.backgroundColor = [UIColor blueColor];
    
    liquidChlorineBar_yellow = [[UIView alloc] initWithFrame:liquidChlorineBar_blue.frame];
    liquidChlorineBar_yellow.backgroundColor = [UIColor yellowColor];
    liquidChlorineBar_yellow.alpha = 0.0;
    
    [self.view addSubview:liquidChlorineBar_blue];
    [self.view addSubview:liquidChlorineBar_yellow];
    
    gasChlorineBar = [[UIView alloc] initWithFrame:CGRectMake( 60, self.view.frame.size.height - 400, 50, 1)];
    [self.view addSubview:gasChlorineBar];
    gasChlorineBar.backgroundColor = [UIColor yellowColor];
    gasChlorineBar.alpha = 1;
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
