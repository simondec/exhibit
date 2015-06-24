//
//  StorageClient.h
//  Exhibit
//
//  Created by Simon de Carufel on 2015-06-02.
//  Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const StorageSettingsKey = @"StorageSettingsKey";

@interface StorageClient : NSObject
+ (void)putObject:(id)object forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;

+ (NSString *)temporaryFilePath:(NSString *)fileName;
+ (void)saveTemporaryFile:(NSData *)file fileName:(NSString *)fileName;
+ (void)deleteTemporaryFile:(NSString *)fileName;
@end
