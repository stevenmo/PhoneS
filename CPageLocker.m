#import <AudioToolbox/AudioToolbox.h> 
#import "CPageLocker.h"
#import "Preference.h"
#import "Utils.h"

@implementation CPageLocker
@synthesize _callerImage,_caller,_callerSecond,_acceptBtn,_acceptBtnBack;

- (id)initWithTemplate: (NSString *) templateName delegate:(id) delegate params:(NSDictionary *)params
{
	self = [ super initWithTemplate: templateName delegate: delegate params:params ];
    
    int textColor = [[ params objectForKey:@"textColor" ] intValue ];
    UIFont * sliderFont = [ params objectForKey:@"sliderFont" ];
    
    __slideBtn = [ [ CText alloc ] initWithText:@"slide to answer" rect: [ params objectForKey:@"sliderRect" ] color: textColor font: sliderFont container: self ];
    
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
    
    _acceptBtn = [[ CImage alloc ] initWithIcon: [self getImageName:@"answerBtn"] rect: [ params objectForKey:@"acceptBtnRect" ] target:nil sel:nil container: self optionIcons: nil backgroundColor:backColor ];
    _acceptBtn._swipeable = true;

    _acceptBtnBack = [[ CImage alloc ] initWithIcon: [self getImageName:@"answerBack"] rect: [ params objectForKey:@"acceptBtnBackRect" ] target:nil sel:nil container: self optionIcons: nil backgroundColor:backColor ];
     [ _acceptBtn setLinkToEnd ];
    
	return self;
}

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    UIView * mainV = [ super render: parentView bPlay: bPlay ];
    
    
    [ _acceptBtnBack render: mainV bPlay: bPlay ];
    [ __slideBtn render:mainV bPlay:bPlay ];

    [ _acceptBtn render: mainV bPlay: bPlay ];
 //   [ __slideBtnBack render: mainV bPlay: bPlay ];
    
    [ self createImageButtonInView: mainV imageName:@"remind" rectName:@"remindRect" ];
    [ self createImageButtonInView: mainV imageName:@"message" rectName:@"messageRect" ];
    
    UILabel * label = [ self createCaption:@"Remind Me" rectName:@"caption_remindRect" ];
    label.textAlignment = NSTextAlignmentCenter;
    
    label = [ self createCaption:@"Message" rectName:@"caption_messageRect" ];
    label.textAlignment = NSTextAlignmentCenter;
    
    [ _callerImage render: mainV bPlay: bPlay ];
    [ _caller render: mainV bPlay: bPlay ];
    [ _callerSecond render: mainV bPlay: bPlay ];

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
