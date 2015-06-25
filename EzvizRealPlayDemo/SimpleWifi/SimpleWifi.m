//
//  SimpleWifi.m
//  VideoGo
//
//  Created by yudan on 14-4-3.
//
//

#import "SimpleWifi.h"
// for "AF_INET"
#include <sys/socket.h>
//for ifaddrs
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#include <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import "NSData+AES128.h"

#define UDP_SEND_SPACE              2

#define MULTICAST_SPACE_IP          "239.119.0.0"
#define MULTICAST_PORT              8888  


@interface SimpleWifi()
{
    int          _udpSocket;
    
    NSArray     *_arrSsid;
    NSArray     *_arrKey;
    NSString    *_strSsid;
    NSString    *_strKey;
    
    NSThread    *_hUdpThread;
    BOOL        _bWork;
    BOOL        _bThreading;
}

@property (nonatomic, retain) NSArray * arrSsid;
@property (nonatomic, retain) NSArray * arrKey;
@property (nonatomic, copy) NSString * strSsid;
@property (nonatomic, copy) NSString * strKey;

@end

@implementation SimpleWifi

@synthesize arrSsid = _arrSsid;
@synthesize arrKey = _arrKey;
@synthesize strSsid = _strSsid;
@synthesize strKey = _strKey;

- (id)init
{
    self = [super init];
    if (self)
    {
        _udpSocket = -1;
        _bWork = NO;
        _bThreading = NO;
    }
    
    return self;
}

- (void)dealloc
{
    [_arrSsid release];
    [_arrKey release];
    [_strSsid release];
    [_strKey release];
    
    [super dealloc];
}

/**
 *  开始wifi配置
 *
 *  @param strSSID rount ssid
 *  @param strKey  rount key
 *
 *  @return 函数运行成功与否  wifi配置成功与否由boujour返回
 */
- (BOOL)StartWifiConfig:(NSString *)strSSID andKey:(NSString *)strKey
{
    self.strSsid = strSSID;
    self.arrSsid = [[[NSArray alloc] initWithArray:[self encodeNumSet:self.strSsid type:0]] autorelease];
    
    self.strKey = strKey;
    self.arrKey = [[[NSArray alloc] initWithArray:[self encodeNumSet:self.strKey type:1]] autorelease];
    
    NSLog(@"***** StartWifiConfig T1'*******");
    
    if (![self startConnect])
    {
        return NO;
    }
    
    return YES;
}

//加密设备wifi配置
- (BOOL)startWifiConfig:(NSString *)strSSID addKey:(NSString *)strKey secretKey:(NSString *)strAESKey
{
    //AES128加密
    self.strSsid = strSSID;
    NSData *ssidData = [strSSID dataUsingEncoding:NSUTF8StringEncoding];
    self.arrSsid = [self getDataBytes:[ssidData AES128EncryptWithKey:strAESKey iv:@"01234567"] type:0];
    
    self.strKey = strKey;
    NSData *keyData = [strKey dataUsingEncoding:NSUTF8StringEncoding];
    self.arrKey = [self getDataBytes:[keyData AES128EncryptWithKey:strAESKey iv:@"01234567"] type:1];
    
    if (![self startConnect])
    {
        return NO;
    }
    return YES;
}


/**
 *  停止wifi配置
 */
- (void)StopWifiConfig
{
    [self stop];
}

/**
 *  编码
 *
 *  @param strInfo ssid / key
 *  @param type    0: ssid  1: key
 *
 *  @return 编码后数组
 */
- (NSArray *)encodeNumSet:(NSString *)strInfo type:(int)type
{
    NSMutableArray * arrNum = [[NSMutableArray alloc] initWithCapacity:16];
    
    const char * szInfo = [strInfo UTF8String];
    unsigned long nLength = strlen(szInfo);
    unsigned char hValue = 0x0;
    unsigned char lValue = 0x0;
    for (int i=0; i<nLength; i++)
    {
        WifiEncodedInfo * encode = [[WifiEncodedInfo alloc] init];
        encode.seq = i & 0x3f;
        encode.type = type & 0x03;
        encode.count = nLength;
        
        int ascii = (int)szInfo[i];
        
        hValue = (ascii & 0xf0) >> 4; //取高四位的二进制数
        encode.firstData = (((2*i % 16) ^ lValue) << 4) | hValue;
        
        lValue = ascii & 0x0f;  //取低四位的二进制数
        encode.secondData = ((((2*i + 1) % 16) ^ hValue)) << 4 | lValue;
        
        [arrNum addObject:encode];
        [encode release];
    }
    
    return [arrNum autorelease];
}

//获取字节内存存储数据
- (NSArray*)getDataBytes:(NSData*)data type:(int)type
{
    NSMutableArray * arrNum = [[NSMutableArray alloc] initWithCapacity:16];
    
    NSUInteger lengthData = [data length];
    
    unsigned char hValue = 0x0;
    unsigned char lValue = 0x0;
    
    for (int i = 0; i <lengthData; i++)
    {
        WifiEncodedInfo * encode = [[WifiEncodedInfo alloc] init];
        encode.seq = i & 0x3f;
        encode.type = type & 0x03;
        encode.count = lengthData;
        
        NSData *subData = [data subdataWithRange:NSMakeRange(i, 1)];
        NSString *dataDes = [subData description]; //数据的十六进制
        NSString *usestr = [dataDes substringWithRange:NSMakeRange(1, 2)];
        
        int asicc = 0;//数据对应的十进制数
        
        for (int n=0 ;n < [usestr length];n++)
        {
            NSString *subStr = [usestr substringWithRange:NSMakeRange(n, 1)];
            NSString *regex = @"[a-zA-Z]";
            
            if (0 == n) //高位
            {
                if ([[NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex] evaluateWithObject:subStr])
                {
                    if ([subStr isEqualToString:@"a"])
                    {
                        asicc += 16*10;
                    }
                    
                    if ([subStr isEqualToString:@"b"])
                    {
                        asicc += 16*11;
                    }
                    
                    if ([subStr isEqualToString:@"c"])
                    {
                        asicc += 16*12;
                    }
                    if ([subStr isEqualToString:@"d"])
                    {
                        asicc += 16*13;
                    }
                    
                    if ([subStr isEqualToString:@"e"])
                    {
                        asicc += 16*14;
                    }
                    
                    if ([subStr isEqualToString:@"f"])
                    {
                        asicc += 16*15;
                    }
                    
                    //NSLog(@"高位 if ----->subStr %@",subStr);
                }
                else
                {
                    asicc += 16 *[subStr intValue];
                    //NSLog(@"高位 else ----->subStr %@",subStr);
                }
            }
            
            if ( 1 == n ) //低位
            {
                if ([[NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex] evaluateWithObject:subStr])
                {
                    if ([subStr isEqualToString:@"a"])
                    {
                        asicc += 10;
                    }
                    
                    if ([subStr isEqualToString:@"b"])
                    {
                        asicc += 11;
                    }
                    
                    if ([subStr isEqualToString:@"c"])
                    {
                        asicc += 12;
                    }
                    if ([subStr isEqualToString:@"d"])
                    {
                        asicc += 13;
                    }
                    
                    if ([subStr isEqualToString:@"e"])
                    {
                        asicc += 14;
                    }
                    
                    if ([subStr isEqualToString:@"f"])
                    {
                        asicc += 15;
                    }
                    
                    // NSLog(@"低位 if ----->subStr %@",subStr);
                }
                else
                {
                    asicc += [subStr intValue];
                    //NSLog(@"低位 else ----->subStr %@",subStr);
                }
            }
        }
        
        hValue = (asicc & 0xf0) >> 4; //取高四位的二进制数
        encode.firstData = (((2*i % 16) ^ lValue) << 4) | hValue;
        
        // NSLog(@"--->%d ---->%x",asicc,hValue);
        
        lValue = asicc & 0x0f;  //取低四位的二进制数
        encode.secondData = ((((2*i + 1) % 16) ^ hValue)) << 4 | lValue;
        
        [arrNum addObject:encode];
        [encode release];
    }
    
    return [arrNum autorelease];
}

/**
 *  编码组播ip地址
 *
 *  @param encode 编码信息
 *
 *  @return ip
 */
- (NSString *)encodeMultiIp:(WifiEncodedInfo *)encode
{
    return [NSString stringWithFormat:@"239.%d.%d.%d", (encode.type << 6) | encode.seq, encode.firstData, encode.secondData];
}


#pragma mark
#pragma mark udp send  

/**
 *  start
 *
 *  @return yes
 */
- (BOOL)startConnect
{
    _udpSocket = socket(AF_INET, SOCK_DGRAM, 0);
    
    _bWork = YES;
    [NSThread detachNewThreadSelector:@selector(udpConnectPro) toTarget:self withObject:nil];
    
    return YES;
}

/**
 *  stop udp send
 */
- (void)stop
{
    if (!_bThreading)
    {
        return;
    }
    
    _bWork = NO;
    while (_bThreading)
    {
        sleep(0.1);              // 此处不能用runloop，主线程使用runloop等待会很卡  
    }
    
    if (_udpSocket != -1)
    {
        close(_udpSocket);
        _udpSocket = -1;
    }
}

/**
 *  发送线程
 */
- (void)udpConnectPro
{
    _bThreading = YES;
    
    while (_bWork)
    {
        // separator
        for (int nCount = 0; nCount < 5; nCount++)
        {
            [self sendSpaceUdpPacket];
            
        }
        
        // ssid
        for (int nCount=0; nCount<[self.arrSsid count]; nCount++)
        {
            [self sendOneUdpPacket:[self.arrSsid objectAtIndex:nCount]];
        }
        
        // separator
        for (int nCount = 0; nCount < 5; nCount++)
        {
            [self sendSpaceUdpPacket];
            
        }
        
        // key
        for (int nCount=0; nCount<[self.arrKey count]; nCount++)
        {
            [self sendOneUdpPacket:[self.arrKey objectAtIndex:nCount]];
        }
        
        if (UDP_SEND_SPACE != 0)
        {
            usleep(UDP_SEND_SPACE * 1000);
        }
    }
    
    _bThreading = NO;
}

/**
 *  单个报文发布
 *
 *  @param nLength 长度
 */
- (void)sendSpaceUdpPacket
{
    if (_udpSocket == -1)
    {
        return;
    }
    
    struct sockaddr_in address;//处理网络通信的地址
    bzero(&address,sizeof(address));
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    
    struct sockaddr_in multiAddr;
    bzero(&multiAddr, sizeof(multiAddr));
    multiAddr.sin_family = AF_INET;
    multiAddr.sin_addr.s_addr = inet_addr(MULTICAST_SPACE_IP);
    
    [self JoinMulticastGroup:_udpSocket multi:&multiAddr face:&address];
    
    char * szData = (char *)malloc(10 +1);
    memset(szData, 0, 10);
    szData[10] = '\0';
    
    multiAddr.sin_port = MULTICAST_PORT;
    if (0 >= sendto(_udpSocket, szData, 10, 0, (struct sockaddr *)&multiAddr, sizeof(multiAddr)))
    {
#ifdef DEBUG
        NSLog(@"failed to send udp socket. ");
#endif
    }
    
}

/**
 *  单个报文发布
 *
 *  @param nLength 长度
 */
- (void)sendOneUdpPacket:(WifiEncodedInfo *)encode
{
    if (_udpSocket == -1)
    {
        return;
    }
    
    NSLog(@"encode info: %@", encode);
    
    // 编码组播ip
    NSString * strMultiIp = [self encodeMultiIp:encode];
    
    struct sockaddr_in address;//处理网络通信的地址
    bzero(&address,sizeof(address));
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    
    struct sockaddr_in multiAddr;
    bzero(&multiAddr, sizeof(multiAddr));
    multiAddr.sin_family = AF_INET;
    multiAddr.sin_addr.s_addr = inet_addr([strMultiIp UTF8String]);
    
    [self JoinMulticastGroup:_udpSocket multi:&multiAddr face:&address];
    
    char * szData = (char *)malloc(encode.count + 36 +1);
    memset(szData, 0, encode.count + 36);
    szData[encode.count + 36] = '\0';
    
    multiAddr.sin_port = MULTICAST_PORT;
    if (0 >= sendto(_udpSocket, szData, encode.count+36, 0, (struct sockaddr *)&multiAddr, sizeof(multiAddr)))
    {
#ifdef DEBUG
        NSLog(@"failed to send udp socket. multiIp is %@", strMultiIp);
#endif
    }
    
    free(szData);
    
}

- (int)JoinMulticastGroup:(int)socket multi:(struct sockaddr_in *)group face:(struct sockaddr_in *)iface
{
    struct ip_mreq   mreqv4;
    char            *optval=NULL;
    int              optlevel = 0,
    option = 0,
    optlen = 0,
    rc;
    
    rc = 0;
    if (group->sin_family == AF_INET)
    {
        // Setup the v4 option values and ip_mreq structure
        optlevel = IPPROTO_IP;
        option   = IP_ADD_MEMBERSHIP;
        optval   = (char *)& mreqv4;
        optlen   = sizeof(mreqv4);
        
        mreqv4.imr_multiaddr.s_addr = group->sin_addr.s_addr;
        mreqv4.imr_interface.s_addr = iface->sin_addr.s_addr;
        
    }
    else if (group->sin_family == AF_INET6)
    {
#ifdef DEBUG
        NSLog(@"Attemtping to join multicast group for invalid address family!");
#endif
        rc = -1;
    }
    
    if (rc != -1)
    {
        // Join the group
        rc = setsockopt(
                        socket,
                        optlevel,
                        option,
                        optval,
                        optlen
                        );
        if (rc == -1)
        {
            // NSLog(@"failed to join multi group. multi ip is %d, face ip is %d. ", group->sin_addr.s_addr, iface->sin_addr.s_addr);
        }
        else
        {

        }
    }
    
    return rc;
}


@end



@implementation WifiEncodedInfo

@synthesize firstData;
@synthesize secondData;
@synthesize seq;
@synthesize type;
@synthesize count;

- (NSString *)description
{
    NSString *desp = [NSString stringWithFormat:@"firstData: %c, secondData: %c, seq: %c, type: %c, count: %d",
                      firstData,
                      secondData,
                      seq,
                      type,
                      count];
    return desp;
}

@end
