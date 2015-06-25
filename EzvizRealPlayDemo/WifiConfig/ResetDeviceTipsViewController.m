//
//  ResetDeviceTipsViewController.m
//  VideoGo
//
//  Created by yudan on 14-6-11.
//
//

#import "ResetDeviceTipsViewController.h"
#import "TipsPublicView.h"
#import "WifiInfoViewController.h"

@interface ResetDeviceTipsViewController ()
{
    TipsPublicView           *_titleView;
    
    UIImageView              *_tipsImgView;
    UILabel                  *_tipsLab;
    UIButton                 *_nextBtn;
}

@end

@implementation ResetDeviceTipsViewController

@synthesize strSN = _strSN;
@synthesize bSupportNet = _bSupportNet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.strSN = nil;
    
    [_titleView release];
    [_tipsImgView release];
    [_tipsLab release];
    [_nextBtn release];  
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleView = [[TipsPublicView alloc] initWithFrame:CGRectMake(0, gfStatusBarSpace, gfScreenWidth, 44) withTitle:NSLocalizedString(@"复位设备", nil)];
    [_titleView addBackBtnTouchEvent:self action:@selector(onClickBackBtn)];
    [_titleView showMenuBtn];
    [self.view addSubview:_titleView];
    
    _tipsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (gfScreenHeight - 140)/2 - 52, 320, 140)];
    _tipsImgView.image = [UIImage imageNamed:@"connect_reset.png"];
    _tipsImgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:_tipsImgView];
    
    int nTop = _tipsImgView.frame.origin.y + _tipsImgView.frame.size.height + 20;
    _tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(20, nTop, gfScreenWidth - 40, 50)];
    _tipsLab.font = [UIFont systemFontOfSize:16.0f];
    _tipsLab.backgroundColor = [UIColor clearColor];
    _tipsLab.numberOfLines = 0;
    _tipsLab.lineBreakMode = UILineBreakModeWordWrap;  
    _tipsLab.textColor = UIColorFromRGB(0x333333, 1.0f);
    _tipsLab.textAlignment = UITextAlignmentCenter;
    _tipsLab.text = NSLocalizedString(@"连接电源的状态下，长按设备上的reset键10秒后松开", nil);
    [self.view addSubview:_tipsLab];
    
    _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, gfScreenHeight - 44 - (40 - gfStatusBarSpace), gfScreenWidth - 40, 44)];
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"public_long_btn.png"] forState:UIControlStateNormal];
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"public_long_btn_sel.png"] forState:UIControlStateHighlighted];
    [_nextBtn setTitle:NSLocalizedString(@"重置好了", nil) forState:UIControlStateNormal];
    
    [self.view addSubview:_nextBtn];
    [_nextBtn addTarget:self action:@selector(onClickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)onClickBackBtn
{
    [self back];
}

- (void)onClickNextBtn
{
    [self back];
}

// 返回上层
- (void)back
{
    //覆盖式动画
    if([self respondsToSelector:@selector(presentingViewController)])
    {
        if (self.presentingViewController)
        {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        if (self.parentViewController.modalViewController)
        {
            [self.parentViewController dismissModalViewControllerAnimated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


@end

