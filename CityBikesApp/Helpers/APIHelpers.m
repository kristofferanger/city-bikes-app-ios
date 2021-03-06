//
//  APIHelpers.m
//  MyRobotFriends
//
//  Created by Kristoffer Anger on 2018-03-24.
//  Copyright © 2018 Kristoffer Anger. All rights reserved.
//

#import "APIHelpers.h"

#define API_KEY @""
#define BASE_URL @"api.citybik.es/v2/networks"
#define TIMEOUT 15.0f

@implementation APIHelpers

@dynamic defaultTimeoutInterval;

+ (NSURLSessionDataTask *)makeRequestWithEndpoint:(nonnull NSString *)endpoint queryParameters:(nullable NSDictionary *)parameters completion:(void (^)(NSDictionary *response))completion {

    // create request with url - base, path and queries
    NSURL *url = [self URLWithPath:endpoint queryParameters:parameters];
    NSLog(@"Request URL: %@", url.absoluteString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = TIMEOUT;

    // make request and parse the data
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data , NSURLResponse *urlResponse, NSError *error) {
        
        NSDictionary *response = nil;
        if (error == nil) {
            response = [NSDictionary dictionaryWithObjectsAndKeys:[self serializeJsonData:data], @"result", nil];
        }
        else {
            response = [NSDictionary dictionaryWithObjectsAndKeys:error, @"error", nil];
        }
        // returning data on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(response);
        });
    }];
    [dataTask resume];
    return dataTask;
}

#pragma mark - helper methods

+ (id)serializeJsonData:(NSData *)data {
    
    // serialize json data and return an array
    // returning nil if operation fails or json is not an array or dictionary
    NSError *error = nil;
    id returnValue = nil;

    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (error == nil && ([jsonObject isKindOfClass:[NSArray class]] || [jsonObject isKindOfClass:[NSDictionary class]])) {
        returnValue = jsonObject;
    }
    else if (error == nil) {
        NSLog (@"Got data in unexpected format: %@", jsonObject);
    }
    else {
        NSLog (@"Got an error: %@", error.description);
    }
    return returnValue;
}


+ (NSURL *)URLWithPath:(nonnull NSString *)path queryParameters:(nullable NSDictionary *)parameters {
    
    // create queries
    NSMutableArray *queryItems = [NSMutableArray new];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  key, id obj, BOOL *stop) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:obj]];
    }];
    // add api key by default if it exists
    if ([API_KEY length]) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"api_key" value:API_KEY]];
    }
    
    // build URL
    NSURLComponents *urlComponents = [NSURLComponents new];
    urlComponents.scheme = @"https";
    urlComponents.path = [BASE_URL stringByAppendingString:path];
    urlComponents.queryItems = queryItems;
    
    return urlComponents.URL;
}

@end
