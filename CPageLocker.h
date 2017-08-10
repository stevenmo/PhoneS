#import "CPage.h"
#import "CImage.h"
#import "CText.h"
#import "CTimer.h"

@interface CPageLocker : CPage
{
    int _dragReleasePos;
}

@property (nonatomic, strong) CImage *_callerImage;

@property (nonatomic, strong) CText *_caller;
@property (nonatomic, strong) CText *_callerSecond;
@property (nonatomic, strong) CText *_slideBtnBack;

@property (nonatomic, strong) CText *_slideBtn;
@property (nonatomic, strong) CImage *_accpetBtn;
@property (nonatomic, strong) CImage *_callBtn;
@property (nonatomic, strong) UIButton *_slideCallBtn;

@end
