#import <AudioToolbox/AudioToolbox.h> 
#import "CPageLocker.h"
#import "Preference.h"
#import "Utils.h"

@implementation CPageLocker
@synthesize _callerImage,_caller,_callerSecond;

- (id)initWithTemplate: (NSString *) templateName delegate:(id) delegate params:(NSDictionary *)params
{
	self = [ super initWithTemplate: templateName delegate: delegate params:params ];
    
    int textColor = [[ params objectForKey:@"textColor" ] intValue ];
    UIFont * sliderFont = [ params objectForKey:@"sliderFont" ];
    
    __slideBtn = [ [ CText alloc ] initWithText:@"slide to answer" rect: [ params objectForKey:@"sliderRect" ] color: textColor font: sliderFont container: self];
    
    __slideBtn._linkPage = [ NSNumber numberWithInt: 1 ];

    
    self._backgroundKeepAspect = false;
    UIColor * backColor = [ params objectForKey:@"ButtonColor"];

    _callerImage = [[ CImage alloc ] initWithIcon: @"avatar0" rect: [ params objectForKey:@"callerImageRect" ] target:nil sel:nil container: self optionIcons:@"avatar3" backgroundColor: backColor ];
    _callerImage._removeable = true;
    _callerImage._importable = true;
    _callerImage._maskIcon = [ self getImageNameWithThemem: @"mask" ];
    
    UIFont * nameFont =  [ params objectForKey:@"nameFont" ];
    if ( nameFont == nil )
        nameFont = BOLDFONT(32);
    
    UIFont * secondFont =  [ params objectForKey:@"secondFont" ];
    if ( secondFont == nil )
        secondFont = MYFONT(20);
    
    _caller = [ [ CText alloc ] initWithText:@"Jon Walker" rect: [ params objectForKey:@"callerRect" ] color: textColor font: nameFont container: self ];
    _callerSecond = [ [ CText alloc ] initWithText:@"mobile" rect: [ params objectForKey:@"callerSecondRect" ]  color: textColor font: secondFont container:self ];
    
	return self;
}

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    UIView * mainV = [ super render: parentView bPlay: bPlay ];
    
    [ self createImageButtonInView: mainV imageName:@"remind" rectName:@"remindRect" ];
    [ self createImageButtonInView: mainV imageName:@"message" rectName:@"messageRect" ];
    
    UILabel * label = [ self createCaption:@"Remind Me" rectName:@"caption_remindRect" ];
    label.textAlignment = NSTextAlignmentCenter;
    
    label = [ self createCaption:@"Message" rectName:@"caption_messageRect" ];
    label.textAlignment = NSTextAlignmentCenter;
    
    [ _callerImage render: mainV bPlay: bPlay ];
    [ _caller render: mainV bPlay: bPlay ];
    [ _callerSecond render: mainV bPlay: bPlay ];

    [ self setupSwipe: parentView bPlay:bPlay ];
    [ self doAnimation ];
    
    return mainV;
}

-(void) doAnimation
{
    UIView * view = __slideBtn._view;
    
    CALayer *maskLayer = [CALayer layer];
    UIImage *mask = [ Utils loadImage:@"shadow" templateName:@"unlock" ];
    maskLayer.contents = (id)mask.CGImage;
    maskLayer.frame = CGRectMake(-view.bounds.size.width,0,view.bounds.size.width*2,view.bounds.size.height);
    
    CABasicAnimation *move;
    move          = [CABasicAnimation animationWithKeyPath:@"position.x"];
    move.toValue  = @( 300 );
    move.fromValue =@( 0 );
    move.duration = 2;
    move.repeatCount = HUGE_VALF;
    move.removedOnCompletion = NO;
    [ maskLayer addAnimation:move forKey:@"x"];
    
    view.layer.mask = maskLayer;
}

-(void) setupSwipe:(UIView *)parentView bPlay: (BOOL) bPlay
{
    CRect * rect = [ self._params objectForKey:@"acceptBtnRect" ];
    CGRect r = [ rect getRect: parentView.bounds ];
    _ogRect = r;
    _swipeToAcceptView = [[ UIImageView alloc ] initWithFrame: r ];
    [ parentView addSubview: _swipeToAcceptView ];
    

    UIImage * img = [ Utils loadImage:@"answer" templateName: self._templateName ];
    img = [ Utils resizeImage:img maxW:r.size.width maxH:r.size.height bKeepScale:true ];
    
    UIEdgeInsets inset = UIEdgeInsetsMake( 0, 100, 0, 40);
    img = [  img resizableImageWithCapInsets: inset ];
    _swipeToAcceptView.image = img;
    
    _swipeToAcceptView.userInteractionEnabled = true;
    _swipeToAcceptView.clipsToBounds = true;
    
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanHandle:)];
    [_swipeToAcceptView addGestureRecognizer: recognizer ];
    
    __slideBtn._rect = MYRECT(25,0,0,0);
    [ __slideBtn render: _swipeToAcceptView  bPlay:bPlay ];
}

- (void) onPanHandle:(UIPanGestureRecognizer *)recognizer {
    
    UIView * view = _swipeToAcceptView;
    
    CGPoint translation = [recognizer translationInView:view.superview];
    CGFloat delta = translation.x;
    
    CGRect frame = view.frame;
    if ( frame.size.width - delta <= 140 )
        delta = frame.size.width - 140;
    
 

    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            view.frame = _ogRect;
        }
        completion:^(BOOL finished){}];
        return;
    }
    frame.origin.x += delta;
    frame.size.width -= delta;
    view.frame = frame;
    
    [recognizer setTranslation:CGPointZero inView: view.superview];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];
    
    [ encoder encodeObject: __slideBtn forKey: @"_slideBtn" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder: decoder ] )
	{
		__slideBtn = [ CElement decodeObject:decoder key:@"_slideBtn" container:self ];
	}
    return self;
}

@end
