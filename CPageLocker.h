#import "CPage.h"
#import "CImage.h"
#import "CText.h"
#import "CTimer.h"

@interface CPageLocker : CPage
{
    UIView * _lockerAnimationView;
    CALayer * _maskLayer;
    NSTimer * _timer;
}

@property (nonatomic, strong) CTimer *_timer;
@property (nonatomic, strong) CImage *_callerImage;

@property (nonatomic, strong) CText *_caller;
@property (nonatomic, strong) CText *_callerSecond;
@property (nonatomic, strong) CText *_slideBtnBack;

@property (nonatomic, strong) CImage *_accpetBtn;
@property (nonatomic, strong) CImage *_declineBtn;
@property (nonatomic, strong) CText *_slideBtn;

@end
