//
//  SparkSetupSecurity.m
//  teacup-ios-app
//
//  Created by Ido Kleinman on 1/8/15.
//  Copyright (c) 2015 spark. All rights reserved.
//  setPublicKey stripping ASN.1 headers from public key data function based on code from:
//  http://blog.wingsofhermes.org/?p=75

#import "SparkSetupSecurityManager.h"

char *const kSparkSetupSecurityPublicKeystore = "kSparkSetupSecurityPublicKeystore";
#define CIPHER_BUFFER_SIZE      128


@implementation SparkSetupSecurityManager


+(SecKeyRef)getPublicKey
{
    NSMutableDictionary * keyAttr = [[NSMutableDictionary alloc] init];
    CFTypeRef publicKeyRef = NULL;
    OSStatus error = noErr;

    NSData* refTag = [[NSData alloc] initWithBytes:kSparkSetupSecurityPublicKeystore length:strlen(kSparkSetupSecurityPublicKeystore)];

    [keyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [keyAttr setObject:refTag forKey:(__bridge id)kSecAttrApplicationTag];
    [keyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    
    // Get the persistent key reference.
    error = SecItemCopyMatching((__bridge CFDictionaryRef)keyAttr, (CFTypeRef *)&publicKeyRef);
    
    if (publicKeyRef == nil || ( error != noErr && error != errSecDuplicateItem)) {
        NSLog(@"Error retrieving public key reference from keychain");
        return NULL;
    }
    
    return (SecKeyRef)publicKeyRef;
}


//-(NSData *)RSAencryptData:(NSData *)plainText withPublicKey:(SecKeyRef)pubKey
//{
//    
//}


+(BOOL)setPublicKey:(NSData *)rawASN1FormattedKey
{
    /* strip the uncessary ASN encoding guff at the start */
    unsigned char * bytes = (unsigned char *)[rawASN1FormattedKey bytes];
    size_t bytesLen = [rawASN1FormattedKey length];
    
    /* Strip the initial stuff */
    size_t i = 0;
    if (bytes[i++] != 0x30)
        return FALSE;
    
    /* Skip size bytes */
    if (bytes[i] > 0x80)
        i += bytes[i] - 0x80 + 1;
    else
        i++;
    
    if (i >= bytesLen)
        return FALSE;
    
    if (bytes[i] != 0x30)
        return FALSE;
    
    /* Skip OID */
    i += 15;
    
    if (i >= bytesLen - 2)
        return FALSE;
    
    if (bytes[i++] != 0x03)
        return FALSE;
    
    /* Skip length and null */
    if (bytes[i] > 0x80)
        i += bytes[i] - 0x80 + 1;
    else
        i++;
    
    if (i >= bytesLen)
        return FALSE;
    
    if (bytes[i++] != 0x00)
        return FALSE;
    
    if (i >= bytesLen)
        return FALSE;
    
    /* Here we go! */
    NSData * extractedKey = [NSData dataWithBytes:&bytes[i] length:bytesLen - i];
    
    /* Load as a key ref */
    OSStatus error = noErr;
    CFTypeRef persistPeer = NULL;
    
    NSData * refTag = [[NSData alloc] initWithBytes:kSparkSetupSecurityPublicKeystore length:strlen(kSparkSetupSecurityPublicKeystore)];
    NSMutableDictionary * keyAttr = [[NSMutableDictionary alloc] init];
    
    [keyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [keyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyAttr setObject:refTag forKey:(__bridge id)kSecAttrApplicationTag];
    
    /* First we delete any current keys */
    /*error = */
    SecItemDelete((__bridge CFDictionaryRef) keyAttr);
    
    [keyAttr setObject:extractedKey forKey:(__bridge id)kSecValueData];
    [keyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnPersistentRef];
    
    error = SecItemAdd((__bridge CFDictionaryRef) keyAttr, (CFTypeRef *)&persistPeer);
    
    if (persistPeer == nil || ( error != noErr && error != errSecDuplicateItem)) {
        NSLog(@"Problem adding public key to keychain");
        return FALSE;
    }
    
    CFRelease(persistPeer);
    
    CFTypeRef publicKeyRef = NULL;

    // TODO: call getPublicKey here to remove code duplication
    
    /* Now we extract the real ref */
    [keyAttr removeAllObjects];
    /*
     [keyAttr setObject:(id)persistPeer forKey:(id)kSecValuePersistentRef];
     [keyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnRef];
     */
    [keyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [keyAttr setObject:refTag forKey:(__bridge id)kSecAttrApplicationTag];
    [keyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    
    // Get the persistent key reference.
    error = SecItemCopyMatching((__bridge CFDictionaryRef)keyAttr, (CFTypeRef *)&publicKeyRef);
    
    if (publicKeyRef == nil || ( error != noErr && error != errSecDuplicateItem)) {
        NSLog(@"Error retrieving public key reference from chain");
        return FALSE;
    }
    
    
    return TRUE;
}



+(NSData *)encryptWithPublicKey:(SecKeyRef)pubKey plainText:(NSData *)plainText
{
    const uint32_t PADDING = kSecPaddingPKCS1;
    size_t cipherBufferSize = CIPHER_BUFFER_SIZE;

    uint8_t *cipherBuffer;
    cipherBuffer = (uint8_t *)calloc(cipherBufferSize, sizeof(uint8_t));
    
    size_t keyBlockSize = SecKeyGetBlockSize(pubKey);
//    NSLog(@"SecKeyGetBlockSize() public = %lu",keyBlockSize);

    if (plainText.length > keyBlockSize)
    {
        NSLog(@"plainText size must be less or equal to key block size");
        free(cipherBuffer);
        
        return nil;
    }
    
    //  Error handling
    // Encrypt using the public.
    OSStatus status = noErr;
    status = SecKeyEncrypt(pubKey,
                           PADDING,
                           plainText.bytes,
                           plainText.length,
                           &cipherBuffer[0], //remove &,[0]?
                           &cipherBufferSize
                           );

    NSData *cipherText;
    if (status == errSecSuccess)
    {
        cipherText = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
        free(cipherBuffer);
        return cipherText;

    }
    else
    {
        free(cipherBuffer);
        return nil;
    }
    
    
}



+(NSData *)decodeDataFromHexString:(NSString *)hexEncodedString // TODO: move to NSString category under helpers
{
    //    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *data= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    for (int i = 0; i < ([hexEncodedString length] / 2); i++) {
        byte_chars[0] = [hexEncodedString characterAtIndex:i*2];
        byte_chars[1] = [hexEncodedString characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}


+(NSString *)encodeDataToHexString:(NSData *)buffer // TODO: move to NSString category under helpers
{
    /* Returns hexadecimal string of NSData. */
    const unsigned char *dataBuffer = buffer.bytes;
    
    if (!dataBuffer)
        return nil;
    
    NSUInteger dataLength  = buffer.length;
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return hexString;
}

@end
