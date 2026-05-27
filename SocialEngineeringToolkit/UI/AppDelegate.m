//
//  AppDelegate.m
//  Social Engineering Toolkit
//

#import "AppDelegate.h"
#import "../SETCore/Managers/SETConfigurationManager.h"
#import "../SETCore/Managers/SETLoggingManager.h"
#import "../Modules/Web Attacks/CredentialHarvester.h"

@interface AppDelegate ()
@property (strong, nonatomic) CredentialHarvester *harvester;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Initialize managers
    [[SETConfigurationManager sharedManager] loadConfigurationFromFile:@"~/Library/Application Support/SEToolkit/set.config"];
    [[SETLoggingManager sharedLogger] logMessage:@"Social Engineering Toolkit Started" withLevel:SETLogLevelInfo];
    
    // Example usage - start credential harvester
    // Uncomment to run (for authorized testing only!)
    /*
    self.harvester = [[CredentialHarvester alloc] init];
    [self.harvester startHarvestingWithURL:@"https://github.com/login" onPort:8080];
    */
    
    NSLog(@"SEToolkit is running. Configure attacks programmatically.");
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self.harvester stopHarvesting];
    [[SETLoggingManager sharedLogger] logMessage:@"Social Engineering Toolkit Terminated" withLevel:SETLogLevelInfo];
}

@end
