//
//  BonjourBrowser.m
//  SimpleWifi
//
//  Created by yudan on 14-3-19.
//  Copyright (c) 2014年 yudan. All rights reserved.
//

#import "BonjourBrowser.h"
#import <Foundation/NSNetServices.h>


// A category on NSNetService that's used to sort NSNetService objects by their name.
@interface NSNetService (BrowserViewControllerAdditions)
- (NSComparisonResult) localizedCaseInsensitiveCompareByName:(NSNetService*)aService;
@end

@implementation NSNetService (BrowserViewControllerAdditions)
- (NSComparisonResult) localizedCaseInsensitiveCompareByName:(NSNetService*)aService {
	return [[self name] localizedCaseInsensitiveCompare:[aService name]];
}
@end


@interface BonjourBrowser() <NSNetServiceBrowserDelegate>
{
    NSNetServiceBrowser* _netServiceBrowser;
	NSMutableArray * _arrBonjourServer;
    
    BOOL bThreading;  // 线程是否结束
    BOOL bWork;       // 线程工作标示
    
    unsigned int _nTimeout;  // 超时时间，=0 标示不检测超时
    NSTimer * _searchTimer;  // 超时检测线程/s
}

@property (nonatomic, retain) NSNetServiceBrowser * netServiceBrowser;
@property (nonatomic, retain) NSTimer * searchTimer;
@property (nonatomic, assign) unsigned int nTimeout;

@end


@implementation BonjourBrowser

@synthesize type = _type;
@synthesize domain = _domain;
@synthesize netServiceBrowser = _netServiceBrowser;
@synthesize delegate = _delegate;
@synthesize searchTimer = _searchTimer;
@synthesize nTimeout = _nTimeout;


- (id)init
{
    self = [super init];
    if (self)
    {
        self.type = kBoujourSearchType;
        self.domain = kBoujourSearchDomain;
        self.nTimeout = BONJOURSEARCH_DEFAULT_TIMEOUT;
    }
    
    return self;
}

- (id) initForType:(NSString*)type inDomain:(NSString*)domain timeout:(unsigned int)nTimeout
{
    if (self = [super init])
    {
        self.type = type;
        self.domain = domain;
        self.nTimeout = nTimeout;
    }
    
    return self;
}

- (void)dealloc
{
    if ([self.searchTimer isValid])
    {
        [self.searchTimer invalidate];
        self.searchTimer = nil;
    }
    
    if (bThreading)
    {
        [self stopBonjour];
    }
    
    self.netServiceBrowser.delegate = nil;
    self.netServiceBrowser = nil;
    
    self.type = nil;
    self.domain = nil;
    
    [_arrBonjourServer release];

    [super dealloc];
}

// 开始bonjour搜索
- (void)startBonjour
{
    [self stopBonjour];
    
    if (!self.netServiceBrowser)
    {
        self.netServiceBrowser = [[[NSNetServiceBrowser alloc] init] autorelease];
        self.netServiceBrowser.delegate = self;
    }
    
    bWork = YES;
    [NSThread detachNewThreadSelector:@selector(searchServer) toTarget:self withObject:nil];
    
    if (self.nTimeout > 0)
    {
        self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:self.nTimeout target:self selector:@selector(bonjourSearchTimeout) userInfo:nil repeats:NO];
    }
}

// 关闭Bonjour搜索
- (void)stopBonjour
{
    if (!bThreading)
    {
        return;
    }
    
    if ([self.searchTimer isValid])
    {
        [self.searchTimer invalidate];
        self.searchTimer = nil;
    }
    
    bWork = NO;
    while (bThreading)
    {
        usleep(100 * 1000);  
    }
    
    [self.netServiceBrowser stop];
}

// 当前是否搜索中
- (BOOL)isBonjouring
{
    if (bThreading)
    {
        return YES;
    }
    
    return NO;  
}

// 查找bonjour服务
- (void)searchServer
{
    bThreading = YES;
    while (bWork)
    {
        [self searchForServicesOfType];
        
        for (int i=0; i<10; i++)
        {
            if (!bWork)
            {
                bThreading = NO;
                break;  
            }
            
            usleep(100 * 1000);  
        }
    }
    
    bThreading = NO;
}

- (void)searchForServicesOfType
{

	[self.netServiceBrowser stop];
    
    if (!_arrBonjourServer)
    {
        _arrBonjourServer = [[NSMutableArray alloc] initWithCapacity:1];
    }
    else
    {
        [_arrBonjourServer removeAllObjects];
    }
    
	[self.netServiceBrowser searchForServicesOfType:self.type inDomain:self.domain];
    
}

/**
 *  发现设备
 */
- (void)finishSearch
{
    if ([_arrBonjourServer count] == 0)
    {
        return;
    }
    
    // [_arrBonjourServer sortUsingSelector:@selector(localizedCaseInsensitiveCompareByName:)];
    
    
    if ([_delegate respondsToSelector:@selector(finishSearchBonjourServer:)])
    {
        [_delegate finishSearchBonjourServer:_arrBonjourServer];
    }
}

/**
 *  bonjour search 超时
 */
- (void)bonjourSearchTimeout
{
    [self stopBonjour];
    
    if ([_delegate respondsToSelector:@selector(TimeourSearchBonjourServer)])
    {
        [_delegate TimeourSearchBonjourServer];
    }
}

#pragma mark -
#pragma mark NetServiceBrowser delegate  
- (void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser didFindService:(NSNetService*)service moreComing:(BOOL)moreComing
{
	// If a service came online, add it to the list and update the table view if no more events are queued.
    if (!service)
    {
        NSLog(@"service is nil");
        return;
    }
    
    NSLog(@"service is %@", service);
    // NSLog(@"%@", [service TXTRecordData]);
    
	[_arrBonjourServer addObject:service.name];
    
	// If moreComing is NO, it means that there are no more messages in the queue from the Bonjour daemon, so we should update the UI.
	// When moreComing is set, we don't update the UI so that it doesn't 'flash'.
	if (!moreComing)
    {
		[self finishSearch];
	}
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    NSLog(@"service remove is %@", aNetService);
//    NSString * strIn = [NSString stringWithFormat:@"server lost is %@", aNetService];
//    [CAttention showAutoHiddenAttention:strIn toView:[UIApplication sharedApplication].keyWindow];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didNotSearch:(NSDictionary *)errorDict
{
    NSLog(@"service find failed. error is %@", errorDict);
}

@end
