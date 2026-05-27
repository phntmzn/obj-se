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
