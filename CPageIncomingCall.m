#import <AudioToolbox/AudioToolbox.h> 
#import "CPageIncomingCall.h"
#import "Preference.h"

@implementation CPageIncomingCall

@synthesize _callerImage,_caller,_callerSecond,_accpetBtn,_declineBtn;

- (id)initWithTemplate: (NSString *) templateName delegate:(id) delegate params:(NSDictionary *)params;
{
	self = [ super initWithTemplate: templateName delegate: delegate params: params ];
    self._backgroundKeepAspect = false;
    
    UIColor * backColor = [ params objectForKey:@"backgroundColor" ];
    int textColor =  [[ params objectForKey:@"textColor" ] intValue ];
    
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
        secondFont = MYFONT(16);

    //@"Jon Walker";
    _caller = [ [ CText alloc ] initWithText:@"Sean Walker" rect: [ params objectForKey:@"callerRect" ] color: textColor font: nameFont container: self ];
    _callerSecond = [ [ CText alloc ] initWithText:@"mobile" rect: [ params objectForKey:@"callerSecondRect" ]  color: textColor font: secondFont container:self ];
    
    _accpetBtn = [[ CImage alloc ] initWithIcon: [self getImageName:@"answer"] rect: [ params objectForKey:@"acceptBtnRect" ] target:nil sel:nil container: self optionIcons: nil backgroundColor:backColor ];
    [ _accpetBtn setLinkToEnd ];
    
    _declineBtn = [[ CImage alloc ] initWithIcon: [self getImageName:@"decline"] rect:[ params objectForKey:@"declineBtnRect" ] target:nil sel:nil container: self optionIcons:nil backgroundColor:backColor ];
    [ _declineBtn setLinkToEnd ];
    
	return self;
}

-(NSArray *) getExitItems
{
    return [ NSArray arrayWithObject: _accpetBtn ];
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
     
     
     
     label = [ self createCaption:@"Accept" rectName:@"caption_acceptRect" ];
     
     label.textAlignment = NSTextAlignmentCenter;
     
     
     
     label = [ self createCaption:@"Decline" rectName:@"caption_declineRect" ];
     
     label.textAlignment = NSTextAlignmentCenter;
     
     
     
     [ _callerImage render: mainV bPlay: bPlay ];
     
     [ _caller render: mainV bPlay: bPlay ];
     
     [ _callerSecond render: mainV bPlay: bPlay ];
     
     
     
     [ _accpetBtn render: mainV bPlay: bPlay ];
     
     [ _declineBtn render: mainV bPlay: bPlay ];
     
     
     
     [ _timer invalidate ];
     
     
     
     BOOL bNoFlash = [[ self._params objectForKey:@"NoFlash" ] boolValue ];
     
     
     
     if( bPlay && !bNoFlash )
     
     _timer = [ NSTimer scheduledTimerWithTimeInterval: 0.5 target:self selector:@selector(onTimerCome:) userInfo:nil repeats:YES ];
     
     
     
     return mainV;
    
    
    
//    UIImageView * imgv = [[ UIImageView alloc ] initWithFrame:parentView.bounds ];
//    imgv.image = [UIImage imageNamed:@"pie.png" ];
//
//    UIImage * image1 = [UIImage imageNamed:@"end-call1.png"  ];
//    UIImage * image2 = [UIImage imageNamed:@"end-call2.png" ];
//    UIImage * image3 = [UIImage imageNamed:@"end-call3.png" ];
//    UIImage * image4 = [UIImage imageNamed:@"end-call4.png" ];
//    UIImage * image5 = [UIImage imageNamed:@"end-call5.png" ];
//    UIImage * image6 = [UIImage imageNamed:@"end-call6.png" ];
//    [ parentView addSubview: imgv ];
//    
//    CAKeyframeAnimation *colorChange = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
//    //    colorChange.values = [NSArray arrayWithObjects:image1,image2,image3,image4, nil];
//    
//    NSMutableArray *animationSequenceArray = [[NSMutableArray alloc] init];
//    
//    [animationSequenceArray addObject:(id)image1.CGImage];
//    [animationSequenceArray addObject:(id)image2.CGImage];
//    [animationSequenceArray addObject:(id)image3.CGImage];
//    [animationSequenceArray addObject:(id)image4.CGImage];
//    [animationSequenceArray addObject:(id)image5.CGImage];
//    [animationSequenceArray addObject:(id)image6.CGImage];
//    colorChange.calculationMode = kCAAnimationDiscrete;
//    colorChange.values = animationSequenceArray;
//    colorChange.duration = 0.5;
//    colorChange.repeatCount = 1.0f;
//    colorChange.removedOnCompletion = NO;
//    [imgv.layer addAnimation:colorChange forKey:@"contents"];
//
//    
//    
//    return imgv;
    
}

-(id) getTransitionParam {
    return [ NSNumber numberWithFloat: _accpetBtn._view.frame.origin.x ];
}

-(void) onTimerCome:(id)sender
{
    [ self._topBar flash ];
    [ _accpetBtn flash ];
}

-(bool) onMemberAdded: (CElement *) obj
{
    NSLog(@"onMemberAdded");
    return true;
}

-(bool) onMemberRemoved:(CElement *)obj
{
    NSLog(@"onMemberRemoved");
    
    if( obj == _callerImage && ( _callerImage != nil ) )
    {
        NSLog(@"move up: %f", _callerImage._rect._height );

        [ _caller._rect move: 0 deltaY: - _callerImage._rect._height ];
        [ _callerSecond._rect move: 0 deltaY: - _callerImage._rect._height ];

        _callerImage = nil;
        
        return true;
    }
    return false;
}

/*
-(void) onAccepted:(id) sender
{
    NSLog(@"onAccepted");
}
     
-(void) onDeclined:(id) sender
{
    NSLog(@"onDeclined");
}*/

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];
    
    [ encoder encodeObject: _callerImage forKey: @"callerImage" ];
    [ encoder encodeObject: _caller forKey: @"caller" ];
    [ encoder encodeObject: _callerSecond forKey: @"callerSecond" ];
    [ encoder encodeObject: _accpetBtn forKey: @"accpetBtn" ];
    [ encoder encodeObject: _declineBtn forKey: @"declineBtn" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder: decoder ] )
	{
		_callerImage = [ CElement decodeObject:decoder key:@"callerImage" container:self ];
		_caller = [ CElement decodeObject: decoder key: @"caller" container:self ];
		_callerSecond = [ CElement decodeObject: decoder key: @"callerSecond" container:self ];
		_accpetBtn = [ CElement decodeObject: decoder key: @"accpetBtn" container:self ];
		_declineBtn = [ CElement decodeObject: decoder key: @"declineBtn" container:self ];
	}
    return self;
}

@end
