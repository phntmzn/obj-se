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
