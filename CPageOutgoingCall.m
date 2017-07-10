#import <AudioToolbox/AudioToolbox.h> 
#import "CPageOutgoingCall.h"
#import "CPageIncomingCall.h"
#import "Preference.h"
#import "utils.h"
#import "CScene.h"
#import "CTimer.h"

@implementation CPageOutgoingCall

@synthesize _callerImage,_caller,_callerSecond,_endCallBtn,_timer;

- (id)initWithTemplate: (NSString *) templateName delegate:(id) delegate params:(NSDictionary *)params
{
	self = [ super initWithTemplate: templateName delegate: delegate params: params ];
    //self._topBar._background = @"incoming_call1/top-bar";
    
    int textColor =  [[ params objectForKey:@"textColor" ] intValue ];

    if ( [ params objectForKey:@"callerImageRect" ] )
    {
        _callerImage = [[ CImage alloc ] initWithIcon:@"avatar0" rect: [ params objectForKey:@"callerImageRect" ] target:nil sel:nil container:self optionIcons:@"avatar3" backgroundColor:nil ];
        _callerImage._removeable = true;
        _callerImage._importable = true;
        _callerImage._maskIcon = [ self getImageNameWithThemem: @"mask" ];
    }
    
    UIFont * nameFont =  [ params objectForKey:@"nameFont" ];
    if ( nameFont == nil )
        nameFont = BOLDFONT(32);
    
    UIFont * secondFont =  [ params objectForKey:@"secondFont" ];
    if ( secondFont == nil )
        secondFont = MYFONT(16);
    
    _caller = [ [ CText alloc ] initWithText:@"Jon Walker" rect: [ params objectForKey:@"callerRect" ] color: textColor font: nameFont container: self ];
    _callerSecond = [ [ CText alloc ] initWithText:@"Mobile" rect: [ params objectForKey:@"callerSecondRect" ] color: textColor font: secondFont container: self ];
    
    _endCallBtn = [[ CImage alloc ] initWithIcon: [self getImageName:@"end-call"] rect: [ params objectForKey:@"endCallRect" ] target:nil sel:nil  container: self optionIcons: nil backgroundColor: [ params objectForKey:@"backgroundColor" ] ];
    _endCallBtn._editable = true;
    _endCallBtn._linkPage = PAGE_END_LINK;
    
    _timer = [[ CTimer alloc ] initWithColor:textColor rect: [ params objectForKey:@"callerSecondRect" ] font: secondFont container: self ];
    
	return self;
}

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    UIView * mainV = [ super render: parentView bPlay: bPlay ];

    [ self createImageButtonInView:mainV imageName:@"top-bar" rectName:@"topBarRect" ];
    [ self createImageButtonInView:mainV imageName:@"bottom-bar" rectName:@"bottomBarRect" ];
    
    [ _callerImage render: mainV bPlay: bPlay ];
    [ _caller render: mainV bPlay: bPlay ];
    [ _callerSecond render: mainV bPlay: bPlay ];
    
    [ _endCallBtn render: mainV bPlay: bPlay ];

    int top = [[ self._params objectForKey: @"buttonTop" ] intValue ];
    CRect * r = [ self._params objectForKey: @"bottomBarRect" ];
    int bottomBarH = r._height;
    if( bottomBarH == 0 )
        bottomBarH = mainV.frame.size.height - [ _endCallBtn._rect getRect: mainV.frame ].origin.y ;
    
    CRect * rect = [ self._params objectForKey: @"buttonArea" ];
    CGRect posArr[6];
    
    if( rect )
    {
        top = [ rect getRect: mainV.frame].origin.y;
        int left = [ rect getRect: mainV.frame].origin.x;

        [ self createImageButtonInView:mainV imageName:@"buttons-box" rectName:@"buttonArea"  ];

        for(int i=0; i < 6; i++ )
        {
            NSString * key = [ NSString stringWithFormat: @"buttonRect%d", i+1 ] ;
            posArr[i] = [[ self._params objectForKey:key ] getRect: mainV.frame ];
            posArr[i].origin.x += left;
            posArr[i].origin.y += top;
        }
        [ self createButtons:posArr mainV:mainV ];
    }else
    {
        if( top == 0 )
        {
            for(int i=0; i < 6; i++ )
            {
                NSString * key = [ NSString stringWithFormat: @"buttonRect%d", i+1 ] ;
                posArr[i] = [[ self._params objectForKey:key ] getRect: mainV.frame ];
            }
            [ self createButtons:posArr mainV:mainV ];
        }else
        {
            int fullW = mainV.frame.size.width;
            
            int dX = [[ self._params objectForKey: @"buttonDistanceX" ] intValue ];
            int dY = [[ self._params objectForKey: @"buttonDistanceY" ] intValue ];
            
            int bWidth = [[ self._params objectForKey: @"buttonWidth" ] intValue ];
            int bHeight = [[ self._params objectForKey: @"buttonHeight" ] intValue ];

            double ratio = mainV.frame.size.width / 320;
            bWidth *= ratio;
            bHeight *= ratio;
            
            top = top + ( parentView.frame.size.height - top - bottomBarH - (dY + bHeight) * 2 ) / 2;
            
            int off = (fullW - bWidth * 3 - dX * 2)/2;
            
            posArr[0] = CGRectMake( off, top, bWidth, bHeight );
            posArr[1] = CGRectMake( off + bWidth + dX, top, bWidth, bHeight );
            posArr[2] = CGRectMake( off + (bWidth + dX)*2, top, bWidth, bHeight );
            top += bHeight + dY;
            posArr[3] = CGRectMake( off, top, bWidth, bHeight );
            posArr[4] = CGRectMake( off + bWidth + dX, top, bWidth, bHeight );
            posArr[5] = CGRectMake( off + (bWidth + dX)*2, top, bWidth, bHeight );
            
            [ self createButtons:posArr mainV:mainV ];
        }
    }
    [ _timer render: mainV bPlay:bPlay ];
    _timer._backgroundView = _callerSecond._view;
    
    if( bPlay && _btnEndCallOrgPos > 0 ) {
        [ self runAnimation: _btnEndCallOrgPos ];
    }
    
    return mainV;
}

-(void) setTransitionParam: (id) param {
    
    BOOL bAnimation = [[ self._params objectForKey: @"hasAnimation" ] intValue ];
    if ( bAnimation && [ param isKindOfClass: NSNumber.class ] ) {
        _btnEndCallOrgPos = [((NSNumber *) param) floatValue ];
    }
}

- (UIImage*) imageWithImage:(UIImage*) source rotatedByHue:(CGFloat) deltaHueRadians;
{
    // Create a Core Image version of the image.
    CIImage *sourceCore = [CIImage imageWithCGImage:[source CGImage]];
    
    // Apply a CIHueAdjust filter
    CIFilter *hueAdjust = [CIFilter filterWithName:@"CIHueAdjust"];
    [hueAdjust setDefaults];
    [hueAdjust setValue: sourceCore forKey: @"inputImage"];
    [hueAdjust setValue: [NSNumber numberWithFloat: deltaHueRadians] forKey: @"inputAngle"];
    CIImage *resultCore = [hueAdjust valueForKey: @"outputImage"];
    
    // Convert the filter output back into a UIImage.
    // This section from http://stackoverflow.com/a/7797578/1318452
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef resultRef = [context createCGImage:resultCore fromRect:[resultCore extent]];
    UIImage *result = [UIImage imageWithCGImage:resultRef];
    CGImageRelease(resultRef);
    
    return result;
}

-(void) runAnimation: (float) orgPos
{
    UIButton * btn = (UIButton *)_endCallBtn._view;
    
 //   UIImage * image1 = [ Utils loadImage:@"answer" templateName:self._templateName ];
    UIImage * image = [ Utils loadImage:@"end-call" templateName:self._templateName ];
    image = [ self imageWithImage:image rotatedByHue: 90 ];
    
    UIImageView * fView = [[ UIImageView alloc ] initWithImage:image ];
    fView.frame = btn.bounds;
    [fView setTintColor:[UIColor redColor]];
    
    [ btn addSubview: fView ];
    
    CGRect frame = btn.frame;
    int nowPos = frame.origin.x;
    btn.frame = CGRectMake(orgPos, frame.origin.y, frame.size.width, frame.size.height );
    
    float duration = 0.5;
    float rotations = 1.0;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;

    [ btn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation" ];
    
    CABasicAnimation *move;
    move          = [CABasicAnimation animationWithKeyPath:@"position.x"];
    move.byValue  = @( nowPos - orgPos );
    move.duration = duration;
    move.removedOnCompletion = NO;
    move.fillMode = kCAFillModeBoth;
    [ btn.layer addAnimation:move forKey:@"x"];
    
 /*   CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    keyframeAnimation.values = [ NSArray arrayWithObjects: image1, image, nil ];
    
    keyframeAnimation.repeatCount = 1.0f;
    keyframeAnimation.duration = duration;
    
    keyframeAnimation.removedOnCompletion = NO;
    
    [fView.layer addAnimation:keyframeAnimation forKey:@"flingAnimation"]; */
    
  /*  UIColor *fromColor = [UIColor redColor];
    UIColor *toColor = [UIColor yellowColor];
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"tintColor"];
    colorAnimation.duration = 1.0;
    colorAnimation.fromValue = (id)fromColor.CGColor;
    colorAnimation.toValue = (id)toColor.CGColor;
    
    [ btn.layer addAnimation:move forKey:@"tintColor"]; */
    
  /*  CABasicAnimation* fadeAnimation;
    fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    fadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    fadeAnimation.duration = duration;
    fadeAnimation.cumulative = YES;
    fadeAnimation.repeatCount = 1;
    fadeAnimation.fillMode = kCAFillModeBoth;
    fadeAnimation.removedOnCompletion = NO;
    
    [ fView.layer addAnimation:fadeAnimation forKey:@"fadeAnimation" ]; */
}

-(void) createButtons: (CGRect *) posArr mainV: (UIView *)mainV
{
    [ self createImageButtonInView:mainV imageName:@"mute" rect:MYRECTR(posArr[0]) target:nil sel:nil highlightColor: HIGHLIGHT_COLOR ];
    
    [ self createDesc:mainV rect:posArr[0] text:@"mute"];
    
    [ self createDesc:mainV rect:posArr[1] text:@"keypad"];
    [ self createImageButtonInView:mainV imageName:@"keypad" rect:MYRECTR(posArr[1]) target:nil sel:nil  ];

    [ self createDesc:mainV rect:posArr[2] text:@"speaker"];
    [ self createImageButtonInView:mainV imageName:@"speaker" rect:MYRECTR(posArr[2]) target:nil sel:nil highlightColor: HIGHLIGHT_COLOR ];
    
    [ self createDesc:mainV rect:posArr[3] text:@"add call"];
    [ self createImageButtonInView:mainV imageName:@"add-call" rect:MYRECTR(posArr[3]) target:nil sel:nil  ];
    
    [ self createDesc:mainV rect:posArr[4] text:@"Face Time"];
    [ self createImageButtonInView:mainV imageName:@"facetime" rect:MYRECTR(posArr[4]) target:nil sel:nil  ];
    
    [ self createDesc:mainV rect:posArr[5] text:@"contacts"];
    [ self createImageButtonInView:mainV imageName:@"contacts" rect:MYRECTR(posArr[5]) target:nil sel:nil  ];
}

-(void) createDesc: (UIView * )mainV rect: (CGRect) rect text: (NSString *) text
{
    if( [ self._params objectForKey: @"buttonHasText" ] )
    {
        CGRect rectNew = CGRectMake( rect.origin.x-10, rect.origin.y + rect.size.height + 4, rect.size.width+20, 20  );
        
        UILabel * label = [ Utils createLabel:text frame:rectNew color:[UIColor lightGrayColor] font:MYFONT(12) ];
        label.textAlignment = NSTextAlignmentCenter;
        
        [ mainV addSubview: label ];
    }
}

-(bool) onMemberRemoved:(CElement *)obj
{
    NSLog(@"onMemberRemoved");
    
    if( obj == _callerImage && ( _callerImage != nil ) )
    {
        [ _caller._rect move: - _callerImage._rect._width deltaY: 0 ];
        [ _caller._rect extend: _callerImage._rect._width deltaH: 0 ];
        
        [ _callerSecond._rect move: - _callerImage._rect._width deltaY: 0 ];
        [ _callerSecond._rect extend: _callerImage._rect._width deltaH: 0 ];
        
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

-(void) copyFrom: (CPage *) page {
    
    [ super copyFrom: page ];
    if ( [ page isKindOfClass: CPageIncomingCall.class ] ) {
        CPageIncomingCall * p = (CPageIncomingCall *) page;
        _caller._text = p._caller._text;
        _caller._font = p._caller._font;
        _caller._color = p._caller._color;
        _callerImage._image = p._callerImage._image;
        _callerImage._icon = p._callerImage._icon;
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];
    
    [ encoder encodeObject: _callerImage forKey: @"callerImage" ];
    [ encoder encodeObject: _caller forKey: @"caller" ];
    [ encoder encodeObject: _callerSecond forKey: @"callerSecond" ];
    [ encoder encodeObject: _endCallBtn forKey: @"endCallBtn" ];
    [ encoder encodeObject: _timer forKey: @"timer" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder: decoder ] )
	{
		_callerImage = [ CElement decodeObject:decoder key:@"callerImage" container:self ];
		_caller = [ CElement decodeObject:decoder key:@"caller" container:self ];
		_callerSecond = [ CElement decodeObject:decoder key:@"callerSecond" container:self ];
		_endCallBtn = [ CElement decodeObject:decoder key:@"endCallBtn" container:self ];
		_timer = [ CElement decodeObject:decoder key:@"timer" container:self ];
    }
    return self;
}

@end
