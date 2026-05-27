//
//  SETConfigurationManager.m
//  Social Engineering Toolkit
//

#import "SETConfigurationManager.h"

@interface SETConfigurationManager ()
@property (nonatomic, strong) NSMutableDictionary *config;
@end

@implementation SETConfigurationManager

+ (instancetype)sharedManager {
    static SETConfigurationManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _config = [NSMutableDictionary dictionary];
        _serverPort = 8080;
        _serverIP = @"0.0.0.0";
        _enableLogging = YES;
        
        // Set default configuration
        _config[@"server_port"] = @(8080);
        _config[@"server_ip"] = @"0.0.0.0";
        _config[@"enable_ssl"] = @(NO);
        _config[@"log_level"] = @"INFO";
        _config[@"timeout_seconds"] = @(30);
    }
    return self;
}

- (BOOL)loadConfigurationFromFile:(NSString *)filePath {
    NSString *expandedPath = [filePath stringByExpandingTildeInPath];
    NSDictionary *loadedConfig = [NSDictionary dictionaryWithContentsOfFile:expandedPath];
    
    if (loadedConfig) {
        [self.config addEntriesFromDictionary:loadedConfig];
        
        // Update properties from loaded config
        if (self.config[@"server_port"])
            self.serverPort = [self.config[@"server_port"] integerValue];
        if (self.config[@"server_ip"])
            self.serverIP = self.config[@"server_ip"];
            
        return YES;
    }
    return NO;
}

- (BOOL)saveConfiguration {
    NSString *configPath = [NSString stringWithFormat:@"~/Library/Application Support/SEToolkit/%@", kConfigFile];
    configPath = [configPath stringByExpandingTildeInPath];
    
    // Create directory if needed
    NSString *configDir = [configPath stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] createDirectoryAtPath:configDir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    return [self.config writeToFile:configPath atomically:YES];
}

- (id)valueForConfigKey:(NSString *)key {
    return self.config[key];
}

@end
