#import "CKeyboard.h"
#import "utils.h"
#import "Preference.h"
#import "ImageUtil.h"

@implementation CKeyboard

@synthesize _focus,_backKeyRect;

#define POPUP_LABEL_TAG  100

-(id) initWithBackground: (NSString *) img rect:(CRect *)rect backKeyRect: (CRect *) backKeyRect target:(id)target sel: (SEL) sel container:(id<ContainerDelegate>)container
{
    self = [ super initWithIcon: img rect:rect target:target sel:sel container:container optionIcons:nil backgroundColor: nil ];
    self._editable = false;
    self._backKeyRect = backKeyRect;
    return self;
}

-(void) onFocus
{
   /* int keyboardMode = 0;
    NSString * nextCh = [ _focus getNextCharacter ];
    if ( nextCh != nil ) {
        keyboardMode = [ self checkKeyboardMode: nextCh ];
    }
    [ self showKeyboard: keyboardMode ]; */
    
    [ self showKeyboard: 0 ];
}

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    UIButton * btn = (UIButton *) [ super render:parentView bPlay:bPlay ];
    btn.adjustsImageWhenHighlighted = NO;
    [ self onFocus ];
    
    if( bPlay )
    {
        [ _focus setFocus: true ];
        [ btn removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside ];
        [ btn addTarget: self action:@selector(onKeyboardTapped:forEvent:) forControlEvents:UIControlEventTouchUpInside ];
    }
    if( _backKeyRect != nil )
    {
        UIButton * backKey = [ Utils createButton: self label:@"" frame: [_backKeyRect getRect:btn.bounds ] sel:@selector(onBackKeyTapped:) ];
        [ btn addSubview: backKey ];
    }

    [ self setupPopup: btn ];
    
    return btn;
}

-(void) showKeyboard: (int) keyboardMode
{
    __keyboardMode = keyboardMode;
    NSString * sName = @"theme1/keyboard";
    
    if ( keyboardMode == 0 ) {
        sName = @"theme1/keyboard0";
    } else if ( keyboardMode == 2 ) {
        sName = @"theme1/keyboard2";
    } else if ( keyboardMode == 3 ) {
        sName = @"theme1/keyboard3";
    }
    
    UIImage * img = [ Utils loadImage: sName ];
    [ (UIButton *)self._view setBackgroundImage:img forState: UIControlStateNormal ];
}

-(void) setupPopup: (UIView *) parentView
{
    _popup = [[ UIImageView alloc ] initWithImage: [ UIImage imageNamed: @"popup" ] ];
    _popup.hidden = true;
    _popup.clipsToBounds = false;
    
    UILabel * label = [ Utils createLabel:@"" frame:CGRectMake(10, 5, 40, 40) color: [ UIColor blackColor] font: MYFONT(35) ];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = POPUP_LABEL_TAG;
    
    [ _popup addSubview: label ];
    
    [ parentView addSubview: _popup ];
}

static CGPoint popup_pos[] =   {
    /// a - z
    { -10, -50 }, { 27, -50}, { 65, -50 }, { 102, -50 }, { 139, -50}, { 176, -50 }, { 214, -50 }, { 251, -50}, { 288, -50 }, { 326, -50 },
    { 9, 0 }, { 46, 0 }, { 83, 0 }, { 120,0}, { 158, 0}, { 195,0 },{ 233,0 }, {270,0}, { 307,0 },
    { 46,50 }, { 83,50}, { 120, 50 }, { 158,50 }, { 195,50 }, { 233,50 }, { 270, 50 },
    /// 1 - 0
                    { -10, -50 }, { 27, -50}, { 65, -50 }, { 102, -50 }, { 139, -50}, { 176, -50 }, { 214, -50 }, { 251, -50}, { 288, -50 }, { 326, -50 },
    /// symbolds
                    { -10, 0 }, { 27, 0}, { 65, 0 }, { 102, 0 }, { 139, 0}, { 176, 0 }, { 214, 0 }, { 251, 0}, { 288, 0 }, { 326, 0 },
    { 55,50 },{ 105,50}, { 155, 50 }, { 205,50 }, { 255, 50 },
    /// symbolds2
    { -10, -50 }, { 27, -50}, { 65, -50 }, { 102, -50 }, { 139, -50}, { 176, -50 }, { 214, -50 }, { 251, -50}, { 288, -50 }, { 326, -50 },
    { -10, 0 }, { 27, 0}, { 65, 0 }, { 102, 0 }, { 139, 0}, { 176, 0 }, { 214, 0 }, { 251, 0}, { 288, 0 }, { 326, 0 },
};

static NSString * m_keys = @"qwertyuiopasdfghjklzxcvbnm\
1234567890\
-/:;()$&@\".,?!'\
[]{}#%^*+=\
_\\|~<>";

-(int) findKey: (NSString *) sKey
{
    NSRange range = [m_keys rangeOfString: sKey.lowercaseString ];
    
    if ( range.length > 0 )
        return (int)range.location;
    
    return -1;
}

-(void) showPopup: (NSString *) str pos: (CGPoint) pos
{
    UILabel * label = (UILabel * )[ _popup viewWithTag: POPUP_LABEL_TAG ];
    label.text = str;
    
  /*  int index = [str.lowercaseString characterAtIndex: 0] - 'a';
    if ( index < 0 || index >= 30 )
        index = 0; */
    
    int index = [ self findKey: str.lowercaseString ];
    if ( index >= 0 )
    {
        //_popup.frame = CGRectMake( pos.x-40, pos.y-75, 60, 60 );
        
        _popup.frame = CGRectMake( popup_pos[index].x, popup_pos[index].y, 60, 60 );
        _popup.hidden = false;
        
        if( _timer != nil )
            [ _timer invalidate ];
        _timer = [ NSTimer scheduledTimerWithTimeInterval: 0.5 target:self selector:@selector(onTimerCome) userInfo:nil repeats:NO ];
    }
}

-(void) onTimerCome
{
    _popup.hidden = true;
    _timer = nil;
}

-(void) onKeyboardSwitchTimerCome: (NSTimer *)timer
{
    NSString * nextCh = timer.userInfo[@"nextCh"];
    int mode = [ self checkKeyboardMode: nextCh ];
    if( mode >= 0 )
        [ self showKeyboard: mode ];
    
    [ _timer invalidate ];
    _timer = nil;
}

-(int) checkKeyboardMode: (NSString *) nextCh
{
    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    NSRange range = [nextCh rangeOfCharacterFromSet:cset];
    if (range.location != NSNotFound )
        return 0;

    cset = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
    if( [nextCh rangeOfCharacterFromSet:cset].location != NSNotFound )
        return 1;
    
    cset = [NSCharacterSet characterSetWithCharactersInString:@"1234567890-/:;()$&@\".,?!'"];
    if( [nextCh rangeOfCharacterFromSet:cset].location != NSNotFound )
        return 2;

    cset = [NSCharacterSet characterSetWithCharactersInString:@"[]{}#%^*+=_\\|~<>"];
    if( [nextCh rangeOfCharacterFromSet:cset].location != NSNotFound )
        return 3;
    
    return -1;
}

-(void) onBackKeyTapped: (id) sender
{
    [ _focus outputNewText: true ];
}

-(void) onKeyboardTapped: (id) sender forEvent:(UIEvent*)event
{
    UIView *button = (UIView *)sender;
    UITouch *touch = [[event touchesForView:button] anyObject];
    CGPoint location = [touch locationInView:button];
    //NSLog(@"Location in button: %f, %f", location.x, location.y);

    if (_waitingForKeyboardSwitch)
    {
        _waitingForKeyboardSwitch = false;
        [ self showKeyboard: __keyboardMode ];
        return;
    }
    
    NSString * newCh = [ _focus outputNewText: false ];
    int keyboardMode = [ self checkKeyboardMode: newCh ];
    if( keyboardMode >= 0 && keyboardMode != __keyboardMode ) {
        __keyboardMode = keyboardMode;
        [ self showKeyboard: keyboardMode ];
    }
    
    NSString * nextCh = [ _focus getNextCharacter ];
    if ( nextCh != nil ) {
        keyboardMode = [ self checkKeyboardMode: nextCh ];
        if( keyboardMode>=0 && keyboardMode != __keyboardMode )
        {
            //_timer = [ NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(onKeyboardSwitchTimerCome:) userInfo:@{@"nextCh" : nextCh } repeats:NO ];
            //return;
            __keyboardMode = keyboardMode;
            _waitingForKeyboardSwitch = true;
        }
    }
    if( newCh!=nil && ![ newCh isEqualToString:@" "] )
        [self showPopup: newCh pos: location ];
}

-(void) slideIn:(UIView *) parentView pushTableView: (UITableView *) pushTableView pushView: (UIView *) pushView
{
    int posY = [self._rect getRect: parentView.frame ].origin.y;
    self._hidden = false;
    
    [ self render: parentView bPlay: true ];

    CGRect rect = self._view.frame;
    rect.origin.y = parentView.bounds.size.height;
    self._view.frame = rect;
    
    [ UIView animateWithDuration: 0.5 delay:0 options: UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect rect = self._view.frame;
        rect.origin.y = posY;
        self._view.frame = rect;
        
        rect = pushTableView.frame;
        rect.size.height -= self._rect._height;
        pushTableView.frame = rect;

        [ Utils tableViewScrollToBottom: pushTableView ];
        
        rect = pushView.frame;
        rect.origin.y -= self._rect._height;
        pushView.frame = rect;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) slideOut:(UIView *) parentView pushTableView: (UITableView *) pushTableView pushView: (UIView *) pushView
{
    if ( self._hidden )
        return;

    [ UIView animateWithDuration: 0.5 delay:0 options: UIViewAnimationOptionCurveEaseIn animations:^{

        CGRect rect = self._view.frame;
        rect.origin.y = parentView.bounds.size.height;
        self._view.frame = rect;
        
        rect = pushTableView.frame;
        rect.size.height += self._rect._height;
        pushTableView.frame = rect;
        
        rect = pushView.frame;
        rect.origin.y += self._rect._height;
        pushView.frame = rect;
        
    } completion:^(BOOL finished) {

        self._hidden = true;
        self._view.hidden = true;
    }];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];
    
    [ encoder encodeObject: _backKeyRect forKey: @"backKeyRect" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [ super initWithCoder: decoder] )
	{
		_backKeyRect = [ decoder decodeObjectForKey:@"backKeyRect" ];
	}
    return self;
}

@end
