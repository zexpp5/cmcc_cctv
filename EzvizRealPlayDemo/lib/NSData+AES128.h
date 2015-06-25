//
//  NSData+AES128.h
//  VideoGo
//
//  Created by hongyangwei on 13-7-5.
//
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonCryptor.h>
@interface NSData (AES128)

- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv;

- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;

- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;

@end
