//
//  SessionManager.m
//
//  Created by Julien Sarazin on 19/12/14.
//  Copyright (c) 2014 Julien Sarazin. All rights reserved.
//

#import "SessionManager.h"

#define API_BASE_URL @"http://api.deezer.com"
@interface SessionManager () <NSURLSessionDelegate>
@property (strong, nonatomic) NSURLSession *currentSession;
@end

@implementation SessionManager
static SessionManager *sharedInstance = nil;

#pragma mark - Singleton Pattern -
+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (sharedInstance == nil)
            sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}
+ (id)allocWithZone:(NSZone *)zone{
    return [self sharedInstance];
}
- (id)copyWithZone:(NSZone *)zone{
    return self;
}
- (id)init{
    if(nil != (self = [super init]))
    {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.allowsCellularAccess = NO;
        [sessionConfig setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
        [sessionConfig setHTTPAdditionalHeaders:@{@"Content-Type": @"application/json"}];
        [sessionConfig setHTTPCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        sessionConfig.timeoutIntervalForRequest = 30.0;
        sessionConfig.timeoutIntervalForResource = 60.0;
        
        self.currentSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                            delegate:self
                                                       delegateQueue:nil];
    }
    return self;
}

/**
 GET Request
 **/
- (void)GET:(NSString *)path completion:(void (^)(NSDictionary *))completion{
    
    NSString *completeURL = [NSString stringWithFormat:@"%@%@", API_BASE_URL, path];
    
    //NSURL *url = [NSURL URLWithString:completeURL];
    
    NSURL *url = [completeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    id completionHandler = ^(NSData *data,
                             NSURLResponse *response,
                             NSError *error) {
        if (error){
            NSLog(@"Request Failed. Reason: %@", error.localizedDescription);
            return;
        }
        
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if (httpResp.statusCode != 200){
            NSLog(@"Unexcepected status code: %i", httpResp.statusCode);
            if (completion) completion(nil);
        }
        
        NSError *jsonError;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&jsonError];
        
        if (jsonError) {
            NSLog(@"Error during serializing JSON. Reason: %@", jsonError.localizedDescription);
            if (completion) completion(nil);
        }
        
        if(completion) completion(JSON);
    };
    
    NSLog(@"Making GET request for URL: %@", url);
    NSURLSessionDataTask *task = [self.currentSession dataTaskWithURL:url
                                                    completionHandler:completionHandler];
    
    [task resume];
}


/**
 PUT REQUEST
 **/
- (void)PUT:(NSString *)path data:(NSDictionary *)JSON completion:(void (^)(NSDictionary *))completion{
    
    NSError *error;
    NSURL *url = [NSURL URLWithString:[API_BASE_URL stringByAppendingString:path]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *jsonData = nil;
    
    if (JSON)
        jsonData = [NSJSONSerialization dataWithJSONObject:JSON
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:jsonData];
    
    id completionHandler = ^(NSData *data,
                             NSURLResponse *response,
                             NSError *error) {
        if (error){
            NSLog(@"Request Failed. Reason: %@", error.localizedDescription);
            if (completion) completion(nil);
            return;
        }
        
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if (httpResp.statusCode != 200){
            NSLog(@"Invalid status code: %i", httpResp.statusCode);
            if (completion) completion(nil);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&jsonError];
        
        if (jsonError) {
            NSLog(@"Error during serializing JSON. Reason: %@", jsonError.localizedDescription);
            if (completion) completion(nil);
            return;
        }
        
        if(completion)
            completion(JSON);
    };
    
    NSLog(@"Making PUT request for URL: %@", url);
    NSURLSessionDataTask *dataTask = [self.currentSession dataTaskWithRequest:request
                                                            completionHandler:completionHandler];
    
    [dataTask resume];
}

/**
 DELETE REQUEST
 **/
- (void)DELETE:(NSString *)path data:(NSDictionary *)JSON completion:(void (^)(NSDictionary *))completion{
    
    
    NSError *error;
    NSURL *url = [NSURL URLWithString:[API_BASE_URL stringByAppendingString:path]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *jsonData = nil;
    
    if (JSON)
        jsonData = [NSJSONSerialization dataWithJSONObject:JSON
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:jsonData];
    
    id completionHandler = ^(NSData *data,
                             NSURLResponse *response,
                             NSError *error) {
        if (error){
            NSLog(@"Request Failed. Reason: %@", error.localizedDescription);
            if (completion) completion(nil);
            return;
        }
        
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if (httpResp.statusCode != 200){
            NSLog(@"Invalid status code: %i", httpResp.statusCode);
            if (completion) completion(nil);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&jsonError];
        
        if (jsonError) {
            NSLog(@"Error during serializing JSON. Reason: %@", jsonError.localizedDescription);
            if (completion) completion(nil);
            return;
        }
        
        if(completion)
            completion(JSON);
    };
    
    NSLog(@"Making DELETE request for URL: %@", url);
    NSURLSessionDataTask *dataTask = [self.currentSession dataTaskWithRequest:request
                                                            completionHandler:completionHandler];
    
    [dataTask resume];
}

/**
 POST REQUEST
 **/
- (void)POST:(NSString *)path data:(NSDictionary *)JSON completion:(void (^)(NSDictionary *))completion{
    
    NSError *error;
    NSURL *url = [NSURL URLWithString:[API_BASE_URL stringByAppendingString:path]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *jsonData = nil;
    
    if (JSON)
        jsonData = [NSJSONSerialization dataWithJSONObject:JSON
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    
    id completionHandler = ^(NSData *data,
                             NSURLResponse *response,
                             NSError *error) {
        if (error){
            NSLog(@"Request Failed. Reason: %@", error.localizedDescription);
            if (completion) completion(nil);
            return;
        }
        
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if (httpResp.statusCode != 200){
            NSLog(@"Invalid status code: %i", httpResp.statusCode);
            if (completion) completion(nil);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&jsonError];
        
        if (jsonError) {
            NSLog(@"Error during serializing JSON. Reason: %@", jsonError.localizedDescription);
            if (completion) completion(nil);
            return;
        }
        
        if(completion) completion(JSON);
    };
    
    NSLog(@"Making POST request for URL: %@", url);
    NSURLSessionDataTask *dataTask = [self.currentSession dataTaskWithRequest:request
                                                            completionHandler:completionHandler];
    
    [dataTask resume];
}

/**
 LIST, EQUIVALENT OF GET BUT FOR COLLECTIONS, (PROVIDE AN NSARRAY AS RESPONSE OBJECT)
 **/
- (void)LIST:(NSString *)path completion:(void (^)(NSArray *))completion{
    
    [self GET:path completion:^(NSDictionary *JSON) {
        completion((NSArray *)JSON);
    }];
}

/**
 GET DATA FROM STRING
 **/
- (NSString *) getDataFrom:(NSString *)url{
    
    // URL Complete : API_BASE_URL + url
    NSString *completeURL = [NSString stringWithFormat:@"%@%@", API_BASE_URL, url];
    NSString *webUrl = [completeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *nsUrl = [NSURL URLWithString:webUrl];
    NSData *data = [NSData dataWithContentsOfURL:nsUrl];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return ret;
}

@end
