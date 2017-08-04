#import "CPage.h"
#import "CImage.h"
#import "CText.h"
#import "CTimer.h"

@interface CPageLocker : CPage
{
    UIView * _lockerAnimationView;
    UIImageView * _swipeToAcceptView;
}

@property (nonatomic, strong) CImage *_callerImage;

@property (nonatomic, strong) CText *_caller;
@property (nonatomic, strong) CText *_callerSecond;
@property (nonatomic, strong) CText *_slideBtnBack;

@property (nonatomic, strong) CText *_slideBtn;

@end
