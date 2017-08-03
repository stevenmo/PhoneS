#import <AudioToolbox/AudioToolbox.h> 
#import "CPageLocker.h"
#import "Preference.h"
#import "Utils.h"



@implementation CPageLocker
@synthesize _callerImage,_caller,_callerSecond,_accpetBtn,_declineBtn;


- (id)initWithTemplate: (NSString *) templateName delegate:(id) delegate params:(NSDictionary *)params
{
	self = [ super initWithTemplate: templateName delegate: delegate params:params ];
    
    int textColor = [[ params objectForKey:@"textColor" ] intValue ];
    
    UIFont * timerFont = [ params objectForKey:@"timerFont" ];
    
    __timer = [[ CTimer alloc ] initWithColor:textColor rect: [ params objectForKey:@"timerRect" ] font: timerFont container: self ];
    
    UIFont * sliderFont = [ params objectForKey:@"sliderFont" ];
    
    __slideBtnBack = [ [ CText alloc ] initWithText:@"slide to answer" rect: [ params objectForKey:@"sliderRect" ] color: 0x000000 font: sliderFont container: self ];
    __slideBtn = [ [ CText alloc ] initWithText:@"slide to answer" rect: [ params objectForKey:@"sliderRect" ] color: textColor font: sliderFont container: self ];
    
    __slideBtn._linkPage = [ NSNumber numberWithInt: 1 ];
    
    self._backgroundKeepAspect = false;
    UIColor * backColor = [ params objectForKey:@"ButtonColor"];

    
    //self._topBar._background = [ self getImageName: @"top-bar" ];
    
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
    
    //@"Jon Walker";
    _caller = [ [ CText alloc ] initWithText:@"Sean Walker" rect: [ params objectForKey:@"callerRect" ] color: textColor font: nameFont container: self ];
    _callerSecond = [ [ CText alloc ] initWithText:@"mobile" rect: [ params objectForKey:@"callerSecondRect" ]  color: textColor font: secondFont container:self ];
    
    
    _accpetBtn = [[ CImage alloc ] initWithIcon: [self getImageName:@"answer"] rect: [ params objectForKey:@"acceptBtnRect" ] target:nil sel:nil container: self optionIcons: nil backgroundColor:backColor ];
    [ _accpetBtn setLinkToEnd ];
/*
    _declineBtn = [[ CImage alloc ] initWithIcon: [self getImageName:@"decline"] rect:[ params objectForKey:@"declineBtnRect" ] target:nil sel:nil container: self optionIcons:nil backgroundColor:backColor ];
    [ _declineBtn setLinkToEnd ];
*/
    
    //self._topBar._background = [ self getImageName: @"top-bar" ];
    
    
    
	return self;
}

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    UIView * mainV = [ super render: parentView bPlay: bPlay ];
    

    //  [ __timer render:mainV bPlay:bPlay ];
    [ _accpetBtn render: mainV bPlay: bPlay ];
    [ __slideBtnBack render: mainV bPlay: bPlay ];
    [ __slideBtn render:mainV bPlay:bPlay ];
    
    UIView * view = __slideBtn._view;
    [ self createImageButtonInView: mainV imageName:@"remind" rectName:@"remindRect" ];
    [ self createImageButtonInView: mainV imageName:@"message" rectName:@"messageRect" ];
    
    UILabel * label = [ self createCaption:@"Remind Me" rectName:@"caption_remindRect" ];
    label.textAlignment = NSTextAlignmentCenter;
    
    label = [ self createCaption:@"Message" rectName:@"caption_messageRect" ];
    label.textAlignment = NSTextAlignmentCenter;
/*
    label = [ self createCaption:@"Accept" rectName:@"caption_acceptRect" ];
    label.textAlignment = NSTextAlignmentCenter;
    
    label = [ self createCaption:@"Decline" rectName:@"caption_declineRect" ];
    label.textAlignment = NSTextAlignmentCenter;
 */
    [ _callerImage render: mainV bPlay: bPlay ];
    [ _caller render: mainV bPlay: bPlay ];
    [ _callerSecond render: mainV bPlay: bPlay ];

    

//    [ _declineBtn render: mainV bPlay: bPlay ];
    
//    UIImageView * imgV = [[ UIImageView alloc ] initWithFrame: view.frame ];
//    imgV.image = [ Utils loadImage:@"shadow" templateName:@"unlock" ];
//    _lockerAnimationView = imgV;
    
    CALayer *maskLayer = [CALayer layer];
    UIImage *mask = [ Utils loadImage:@"shadow" templateName:@"unlock" ];
    UIImage *blacktext = [ Utils loadImage:@"blackText.png" templateName:@"unlock" ];
    maskLayer.contents = (id)blacktext.CGImage;
    maskLayer.contents = (id)mask.CGImage;
    //  maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.frame = view.bounds;
    _maskLayer = maskLayer;
    
    UIFont * systemFont16 = MYFONT(32);
    
    CATextLayer * layer = [[ CATextLayer alloc ] init ];
    layer.foregroundColor = [UIColor whiteColor].CGColor;
    layer.font = CGFontCreateWithFontName( (CFStringRef)systemFont16.fontName );
    layer.fontSize = systemFont16.pointSize;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.drawsAsynchronously = false;
    //layer.actions = @{ CANullAction.CA_ANIMATION_CONTENTS: CANullAction() };
    layer.contentsScale = [ UIScreen mainScreen ].scale;
    layer.frame = view.bounds;
    layer.string = @"";
    //caTextLayer.frame = CGRectMake(playbackTimeImage.layer.bounds.origin.x, ((playbackTimeImage.layer.bounds.height - playbackTimeLayer.fontSize) / 2), playbackTimeImage.layer.bounds.width, playbackTimeLayer.fontSize * 1.2)
    
    view.layer.mask = maskLayer;
    [ view.layer addSublayer: layer ];
    
    //[ mainV addSubview: imgV ];

    _timer = [ NSTimer scheduledTimerWithTimeInterval: 0.05 target:self selector:@selector(onTimerCome) userInfo:nil repeats:YES ];
    
    return mainV;
}

-(void) onTimerCome
{
    UIView * view = __slideBtn._view;
    
    CGRect frame = _maskLayer.frame;
    if ( frame.origin.x >= view.frame.size.width - 100)
        frame.origin.x = -150;
    
    NSLog(@"on timer come: %f", frame.origin.x );
    _maskLayer.frame = CGRectMake( frame.origin.x + 3, frame.origin.y, frame.size.width, frame.size.height );
    [ view setNeedsDisplay ];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];
    
    [ encoder encodeObject: __timer forKey: @"_timer" ];
    [ encoder encodeObject: __slideBtn forKey: @"_slideBtn" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder: decoder ] )
	{
		__timer = [ CElement decodeObject:decoder key:@"_timer" container:self ];
		__slideBtn = [ CElement decodeObject:decoder key:@"_slideBtn" container:self ];
	}
    return self;
}

@end
