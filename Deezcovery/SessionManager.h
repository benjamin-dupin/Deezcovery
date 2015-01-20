//
//  SessionManager.h
//  TodoList
//
//  Created by Julien Sarazin on 19/12/14.
//  Copyright (c) 2014 Julien Sarazin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionManager : NSObject
#pragma mark - Singleton Pattern -
+ (instancetype)sharedInstance;

- (void)GET:(NSString *)path completion:(void (^)(NSDictionary *))completion;

- (void)LIST:(NSString *)path completion:(void (^)(NSArray *))completion;

- (void)PUT:(NSString *)path data:(NSDictionary *)JSON completion:(void (^)(NSDictionary *))completion;

- (void)DELETE:(NSString *)path data:(NSDictionary *)JSON completion:(void (^)(NSDictionary *))completion;

- (void)POST:(NSString *)path data:(NSDictionary *)JSON completion:(void (^)(NSDictionary *))completion;
@end
