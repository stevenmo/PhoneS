#import <AudioToolbox/AudioToolbox.h> 
#import "CPageLocker.h"
#import "Preference.h"
#import "CScene.h"
#import "Utils.h"

@implementation CPageLocker
@synthesize _callerImage,_caller,_callerSecond,_accpetBtn,_callBtn;

- (id)initWithTemplate: (NSString *) templateName delegate:(id) delegate params:(NSDictionary *)params
{
	self = [ super initWithTemplate: templateName delegate: delegate params:params ];
    
    int textColor = [[ params objectForKey:@"textColor" ] intValue ];
    UIFont * sliderFont = [ params objectForKey:@"sliderFont" ];
    
    __slideBtn = [ [ CText alloc ] initWithText:@"slide to answer" rect: [ params objectForKey:@"sliderRect" ] color: textColor font: sliderFont container: self];
    __slideBtn._editable = false;
    
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
    
    _accpetBtn = [[ CImage alloc ] initWithIcon: [self getImageName:@"answer"] rect: [ params objectForKey:@"acceptBtnRect" ] target:nil sel:nil container: self optionIcons: nil backgroundColor:backColor ];
    [ _accpetBtn setLinkToEnd ];
    
    _callBtn = [[ CImage alloc ] initWithIcon: [self getImageName:@"answerBtn"] rect: [ params objectForKey:@"callBtnRect" ] target:nil sel:nil container: self optionIcons: nil backgroundColor:backColor ];
    [ _callBtn setLinkToEnd ];
    
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

    [ _accpetBtn setTarget:self sel:@selector(onAccepted:) container: self ];
    [ _accpetBtn render: mainV bPlay: bPlay ];
    
    [ _callBtn render: mainV bPlay: bPlay ];
    
    [ self setupSwipe: parentView bPlay:bPlay ];
    
    if( bPlay )
        [ self doAnimation ];
    
    return mainV;
}

-(id) getTransitionParam {
    
    if ( _dragReleasePos > 0 )
        return [ NSNumber numberWithInt: _dragReleasePos ];
    
    return nil;
}

-(void) doAnimation
{
    UIView * view = __slideBtn._view;
    
    CALayer *maskLayer = [CALayer layer];
    UIImage *mask = [ Utils loadImage:@"shadow" templateName: self._templateName ];
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
    
    UIButton * btn  = (UIButton *)_accpetBtn._view;
    UIButton * call = (UIButton *)_callBtn._view;

    UIImage * img = [ Utils loadImage:@"answer" templateName: self._templateName ];
    img = [ Utils resizeImage:img maxW:r.size.width maxH:r.size.height bKeepScale:true ];
    
    UIEdgeInsets inset = UIEdgeInsetsMake( 0, 40, 0, 40);
    img = [  img resizableImageWithCapInsets: inset ];
    
    [ btn setBackgroundImage: img forState: UIControlStateNormal ];
    
    UIImage * callImg = [ Utils loadImage:@"answerBtn" templateName: self._templateName ];
    callImg = [ Utils resizeImage:callImg maxW:r.size.width maxH:r.size.height bKeepScale:true ];
    [ call setBackgroundImage: callImg forState: UIControlStateNormal ];
    
    if ( bPlay ) {
//        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanHandle:)];
        UIPanGestureRecognizer *recognizerCall = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCallBtn:)];
//        [ btn addGestureRecognizer: recognizer ];
        [btn addGestureRecognizer: recognizerCall ];
    }
    btn.clipsToBounds = true;
    call.clipsToBounds = true;
    
    __slideBtn._rect = MYRECT(25,0,0,0);
    [ __slideBtn render: btn  bPlay:bPlay ];
    __slideBtn._view.userInteractionEnabled = false;
    _callBtn._view.userInteractionEnabled = false;
}
- (void) onCallBtn : (UIPanGestureRecognizer *)recognizerCall {
    
    UIView * view = _callBtn._view;
    CRect * rect = [ self._params objectForKey:@"callBtnRect" ];
    CGRect r = [ rect getRect: self._view.bounds ];
    
    
    UIView * view2 = recognizerCall.view;
    CRect * rect2 = [ self._params objectForKey:@"acceptBtnRect" ];
    CGRect r2 = [ rect2 getRect: self._view.bounds ];
    
    
    CGPoint translation = [recognizerCall translationInView:view.superview];
    CGFloat delta = translation.x;
    
    CGRect frame = view.frame;
    CGRect frame2 = view2.frame;
    
    if (frame.origin.x < 250){
        frame.origin.x += delta;
//        delta = frame2.size.width - 100;
    }
    if ( frame2.size.width - delta <= 86 )
            delta = frame2.size.width - 86;
    
    frame2.origin.x += delta;
    frame2.size.width -= delta;
    
    
    view.frame = frame;
    view2.frame = frame2;
    if(recognizerCall.state == UIGestureRecognizerStateEnded){
        
        if ( frame.origin.x < 200 && ((_callBtn._linkPage.intValue != PAGE_END )||(_accpetBtn._linkPage.intValue != PAGE_END)) )
        {
            _dragReleasePos = frame.origin.x;
            [ _callBtn onLinkClicked: self ];
            return;
        }
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            view.frame = r;
            view2.frame = r2;
        }
                         completion:^(BOOL finished){}];
        return;
    }

    
//    [recognizerCall setTranslation:CGPointZero inView: view.superview];
    [recognizerCall setTranslation:CGPointZero inView: view2.superview];
    
}
//- (void) onPanHandle:(UIPanGestureRecognizer *)recognizer {
//    
//    UIView * view = recognizer.view;
//    
//    CRect * rect = [ self._params objectForKey:@"acceptBtnRect" ];
//    CGRect r = [ rect getRect: self._view.bounds ];
//    
//    CGPoint translation = [recognizer translationInView:view.superview];
//    CGFloat delta = translation.x;
//    
//    CGRect frame = view.frame;
//    if ( frame.size.width - delta <= 140 )
//        delta = frame.size.width - 140;
//
//    frame.origin.x += delta;
//    frame.size.width -= delta;
//    
//    if(recognizer.state == UIGestureRecognizerStateEnded){
//        
//        if ( frame.size.width < 150 && (_accpetBtn._linkPage.intValue != PAGE_END ) )
//        {
//            _dragReleasePos = frame.origin.x;
//            [ _accpetBtn onLinkClicked: self ];
//            return;
//        }
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            view.frame = r;
//        }
//        completion:^(BOOL finished){}];
//        return;
//    }
//    view.frame = frame;
//    
//    [recognizer setTranslation:CGPointZero inView: view.superview];
//}

- (void) onAccepted:(id) sender
{
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];
    
    [ encoder encodeObject: __slideBtn forKey: @"_slideBtn" ];
    [ encoder encodeObject: _callerImage forKey: @"callerImage" ];
    [ encoder encodeObject: _caller forKey: @"caller" ];
    [ encoder encodeObject: _callerSecond forKey: @"callerSecond" ];
    [ encoder encodeObject: _accpetBtn forKey: @"accpetBtn" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder: decoder ] )
	{
		__slideBtn = [ CElement decodeObject:decoder key:@"_slideBtn" container:self ];
        _callerImage = [ CElement decodeObject:decoder key:@"callerImage" container:self ];
        _caller = [ CElement decodeObject:decoder key:@"caller" container:self ];
        _callerSecond = [ CElement decodeObject:decoder key:@"callerSecond" container:self ];
        _accpetBtn = [ CElement decodeObject:decoder key:@"accpetBtn" container:self ];
	}
    return self;
}

@end
