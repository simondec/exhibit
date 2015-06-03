//
//  StorageClient.m
//  Exhibit
//
//  Created by Simon de Carufel on 2015-06-02.
//  Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "StorageClient.h"

@implementation StorageClient
+ (void)putObject:(id)object forKey:(NSString *)key {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object];
    [archiver finishEncoding];
    [data writeToURL:[self saveURLForKey:key] atomically:YES];
}

+ (id)objectForKey:(NSString *)key {
    id retVal = nil;
    @try {
        NSData *data = [NSData dataWithContentsOfURL:[self saveURLForKey:key]];
        if (data) {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            retVal = [unarchiver decodeObject];
            [unarchiver finishDecoding];
        }
    } @catch (NSException * exception) {
        return nil;
    }
    return retVal;
}

+ (void)removeObjectForKey:(NSString *)key {
    NSURL * url = [self saveURLForKey:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:url error:NULL];
}

+ (NSURL *) saveURLForKey:(NSString*) key {
    NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * saveURLStr = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"exhibit.persistent.data.%@", key]];
    return [NSURL fileURLWithPath:saveURLStr];
}

+ (void)saveTemporaryFile:(NSData *)file fileName:(NSString *)fileName {
    [file writeToFile:[self temporaryFilePath:fileName] atomically:NO];
}

+ (void)deleteTemporaryFile:(NSString *)fileName {
    [[NSFileManager defaultManager] removeItemAtPath:[self temporaryFilePath:fileName] error:nil];
}

+ (NSString *)temporaryFilePath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    [self createFolderIfMissing:paths[0]];
    NSString *path = [paths[0] stringByAppendingPathComponent:fileName];
    return path;
}

+ (void)createFolderIfMissing:(NSString *)folderPath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
@end
