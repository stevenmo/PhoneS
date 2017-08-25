#import <Google/Analytics.h>
#import "CPage.h"
#import "utils.h"
#import "Preference.h"
#import "CScene.h"
#import "CSettings.h"
#import "CVibrate.h"

@implementation CPage

@synthesize _templateName,_backgroundImg,_topBar,_exitPos,_view,_frame,_delegate,_backgroundKeepAspect,_thumbnail,_alpha,_hasExtendedOptions,_proximitySensorEanbled,_params,_incomingPage,_pageID,_hotkey,_transitionType,_transitionTime;

- (id)initWithTemplate: (NSString *) templateName delegate:(id) delegate params: (NSDictionary * )params
{
	self = [super init];

    _delegate = delegate;
    _backgroundKeepAspect = true;
    _templateName = templateName;
    _exitPos = CGPointMake( 5, 30 );
    _params = params;
    _alpha = [UIScreen mainScreen].brightness;
    _pageID = [[ CSettings sharedInstance ] getNewLink ];
    __vibrateMode = -1;
    
    if( templateName != nil )
    {
        _topBar = [ self createTopBar: [ self getThemeName ] delegate: delegate ];
        _topBar._container = self;
    }

    CRect * r = [ CRect initWithX:-100 posY:-90 width: 80 height:80 ];
    _hotkey = [ [ CHotKey alloc ] initWithRect: r container:self ];
    
	return self;
}

-(NSDictionary *) getCrossPlatformInfo
{
    CRect * rect = _hotkey._rect;
    
    NSNumber * rectW = [ NSNumber numberWithFloat: 0 ];
    NSNumber * rectX = rectW;
    NSNumber * rectY = rectW;
    NSNumber * rectH = rectW;
    
    NSDictionary * dic = nil;
    
    if( rect != nil ) {
        CGSize s = [ Utils getScreenSize ];
        CGRect rFrame = CGRectMake(0, 0, s.width, s.height );
        CGRect r = [ rect getRect: rFrame ];
        rectW = [ NSNumber numberWithFloat: r.size.width / rFrame.size.width ];
        rectX = [ NSNumber numberWithFloat: r.origin.x / rFrame.size.width ];
        rectY = [ NSNumber numberWithFloat: r.origin.y / rFrame.size.height ];
        rectH = [ NSNumber numberWithFloat: r.size.height / rFrame.size.height ];
    }

    dic = @{ @"_hotKeyRectX": rectX,  @"_hotKeyRectY": rectY,   @"_hotKeyRectW": rectW,  @"_hotKeyRectH": rectH,
        @"_vibrateMode" : [ NSNumber numberWithInt: __vibrateMode ],
        @"_proximitySensorEanbled" : [ NSNumber numberWithBool: _proximitySensorEanbled ],
        @"_alpha" : [ NSNumber numberWithFloat: _alpha ],
             };
    
    return dic;
}

-(id<ElementDelegate>) getDelegate
{
    return _delegate;
}

-(NSArray *) getExitItems
{
    if( _hotkey != nil )
        return [ NSArray arrayWithObject: _hotkey ];
    
    return nil;
}

-(id) getTransitionParam {
    return nil;
}

-(void) setTransitionParam: (id) param {
}

-(void) showHotkey: (bool) bShow
{
    [ _hotkey show: bShow ];
    [ _delegate onContentRefresh ];
}

-(void) setExitPage: (CPage *) page
{
    NSArray * arr = [ self getExitItems ];
    for (CElement *item in arr ) {
        [ item setLinkToPage: page ];
    }
    page._incomingPage = _pageID;
}

-(void) onHotkeyAction: (CHotKey *) hotkey
{
    if( hotkey._linkPage )
        [ _delegate onLinkClicked: hotkey._linkPage sender: hotkey ];
}

-(void)onOptionClicked: (int) optionID
{
}

-(CTopBar *) createTopBar: (NSString *) themeId delegate: (id) delegate
{
    if( themeId == nil )
        return nil;
    
    int themeIndex = [ Utils getThemeIndexByTemplateName: themeId ];
    
    UIColor * backColor = COLOR(147,41,41);
    NSNumber * obj = [ _params objectForKey:@"topbar_textcolor" ];
    int color = obj? [ obj intValue ]: ( (themeIndex == 4 || themeIndex == 5 ) ? 0 : 0xffffff );
    int batteryColor = color;
    
    NSNumber * nbatteryColor = [ _params objectForKey:@"batteryColor" ];
    if( nbatteryColor != nil )
        batteryColor = [ nbatteryColor intValue ];
    

    
    CRect * signalRects[] = { MYRECTI(6, 0, 34, 21 ), MYRECTI(6, 0, 33.5, 21 ), MYRECTI(6, 0, 32, 21 ), MYRECTI(6, 0, 21, 21 ), MYRECTI(6, 0, 33.5, 21 ), MYRECTI(6, 0, 33.5, 21 ), MYRECTI(6, 0, 33.5, 21 ) , MYRECTI(6, 0, 33.5, 21 ), MYRECTI(6, 0, 33.5, 21 ) };
    CRect * batteryRects[] = { MYRECTI(-30, 5, 24, 9.5), MYRECTI(-30, 5, 24, 12), MYRECTI(-30, 5, 24, 10.5), MYRECTI(-30, 5, 24, 9.5), MYRECTI(-30, 5, 24, 9.5), MYRECTI(-30, 5, 24, 9.5), MYRECTI(-30, 5, 24, 9.5) , MYRECTI(-30, 5, 24, 9.5), MYRECTI(-30, 5, 24, 9.5) };
    
    CTopBar * topBar = [[ CTopBar alloc ] initWithTheme: themeId container:nil color:color backgroundColor:backColor batteryRect: batteryRects[themeIndex]  batteryColor:color signalRect: signalRects[themeIndex] maxSignalIcon:@"signal5" wifiRect: MYRECTI(102, 0, 21, 21 ) maxWifiIcon:@"wifi4" carrierRect:MYRECTI( 35, 0, 70, 21) timeRect:CENTER_RECTI( 0, 0, 80, 21)];
    
    return topBar;
}

-(NSString *) getInvertedTheme: (NSString *) theme
{
    if( [ theme isEqualToString: @"theme5" ] || [ theme isEqualToString: @"theme6" ] )
        return @"theme9";
    return @"theme5";
}

-(void) invertTopBar
{
    NSString * themeId = [ self getThemeName ];
    if( !_bTopBarInverted ) {
        themeId = [ self getInvertedTheme: themeId ];
    }
    [ _topBar._view removeFromSuperview ];
    _topBar = [ self createTopBar: themeId delegate: _delegate ];
    _topBar._container = self;
    [ _topBar render: _view  bPlay: false ];
    
    _bTopBarInverted = !_bTopBarInverted;
}

-(void) copyFrom: (CPage *) page {
    if ( page._topBar != nil )
    {
        if ( _topBar._color == page._topBar._color )
            [ _topBar copyFrom: page._topBar ];
        _topBar._hidden = false;
    }
}

-(NSString *)getThemeName
{
    return [ _params objectForKey:@"theme" ];
}

- (NSString *)getImageNameWithThemem: (NSString *) name
{
    return [ Utils getImageName: name templateName: [ self getThemeName ] ];
}

- (NSString *)getImageName: (NSString *) name
{
    return [ Utils getImageName: name templateName: _templateName ];
}

- (bool) ifImageExists: (NSString *) name
{
    NSString * fullName = [ self getImageName: name ];
    NSString * sPath = [ NSString stringWithFormat: @"templates/%@.png", fullName ];

    NSString *pathAndFileName = [[NSBundle mainBundle] pathForResource: sPath ofType:nil ];
    bool bExist = [ Utils fileExists: pathAndFileName ];
    if( bExist )
        return bExist;

    sPath = [ NSString stringWithFormat: @"templates/%@.jpg", fullName ];
    pathAndFileName = [[NSBundle mainBundle] pathForResource: sPath ofType:nil ];
    
    return [ Utils fileExists: pathAndFileName ];
}

-(UIButton *)createImageButtonInView: (UIView *) view imageName: (NSString *) imageName  rectName: (NSString *) rectName highlightColor:(UIColor *)highlightColor
{
    CRect * r = [ _params objectForKey: rectName ];
    if( r == nil )
        return nil;
    
    return [ self createImageButtonInView: view imageName:imageName rect: r target:nil sel: nil highlightColor:highlightColor ];
}

-(UIButton *)createImageButtonInView: (UIView *) view imageName: (NSString *) imageName  rectName: (NSString *) rectName
{
    return [ self createImageButtonInView:view imageName:imageName rectName:rectName highlightColor:nil ];
}

-(void) onButtonToggled: (UIButton *) btn
{
    NSLog(@"onButtonToggled: %d", btn.selected );
    
    [ btn setSelected: !btn.selected ];
    
    NSLog(@"onButtonToggled: %d", btn.selected );
}

-(UIView *) createBarInView:(UIView *)view rectName: (NSString *)rectName colorName: (NSString *) colorName
{
    CRect * r = [ _params objectForKey: rectName ];
    if( r == nil )
        return nil;
    
    UIColor * color = [ _params objectForKey: colorName ];
    UIView * v = [[ UIView alloc ] initWithFrame: [ r getRect:view.bounds] ];
    v.backgroundColor = color;
    
    [ view addSubview: v ];
    return v;
}

-(UIButton *)createImageButtonInView: (UIView *) view imageName: (NSString *) imageName  rect: (CRect *) rect target:(id) target sel:(SEL)sel highlightColor: (UIColor *) highlightColor
{
    if( highlightColor != nil && sel == nil )
    {
        target = self;
        sel = @selector(onButtonToggled:);
    }
    
    NSString * name = [ Utils getImageName:imageName templateName:self._templateName ];
    if ( ![ Utils imageExists: name ] )
        return nil;
    
    if( highlightColor )
    {
        CGRect r = [ rect getRect: view.frame ];
        UIButton * btn = [ Utils createImageButtonWithHighlight :target imageName:name frame:r sel:sel highlightColor:highlightColor ];
        [ view addSubview: btn ];
        return btn;
    }
    
    if( _elements == nil )
        _elements = [[ NSMutableArray alloc ] init ];
    
    CImage * img = nil;
    
    for( CImage * i in _elements )
    {
        if( [ i._icon isEqualToString: name ] )
        {
            img = i;
            break;
        }
    }
    
    if( img == nil )
    {
        img = [[ CImage alloc ] initWithIcon:name rect: rect target:target sel:sel container:self optionIcons:nil backgroundColor:nil ];
        img._highlightColor = highlightColor;
        img._linkPage = PAGE_DEAD_LINK;
        [ _elements addObject: img ];
    } else
        img._rect = rect;
    
    return (UIButton *)[ img render: view bPlay: ![ self._delegate isEditing ] ];
}

-(CImage *) findElementByImageName: (NSString *) imageName
{
    NSString * name = [ Utils getImageName:imageName templateName:self._templateName ];
    for( CImage * i in _elements )
    {
        if( [ i._icon isEqualToString: name ] )
            return i;
    }
    return nil;
}

-(UIButton *)createImageButtonInView: (UIView *) view imageName: (NSString *) imageName  rect: (CRect *) rect target:(id) target sel:(SEL)sel
{
    return [ self createImageButtonInView:view imageName:imageName rect:rect target:target sel:sel highlightColor:nil ];
}

-(UILabel*) createCaption: (NSString *) sText rectName:(NSString *) rectName
{
    CRect * r = [ _params objectForKey: rectName ];
    if( r == nil )
        return nil;

    UIColor * captionColor = [ UIColor grayColor ];
    UIColor * obj = [ self._params objectForKey:@"captionColor"];
    if( obj )
        captionColor = obj;
    
    UIFont * font = [ self._params objectForKey:@"captionFont"];
    if( font == nil )
        font = MYFONT(16);
    return [ Utils createLabelInView: _view text:sText frame: [ r getRect: _view.frame ] color:captionColor font:font ];
}

-(void) createLeftButton
{
    CRect * r = [ self._params objectForKey:@"leftButtonRect"];

    NSString *sText = [ self._params objectForKey:@"leftButtonText"];
    if( sText )
    {
        UIColor * captionColor = [ UIColor whiteColor ];
        UIColor * obj = [ self._params objectForKey:@"leftButtonColor"];
        if( obj )
            captionColor = obj;
        
        [ Utils createLabelInView: _view text:sText frame: [ r getRect: _view.frame ] color:captionColor font:MYFONT(16) ];
    }else
    {
        NSString * sName = [ self._params objectForKey:@"leftButtonImage"];
        [ self createImageButtonInView: _view imageName: sName rect: r target:nil sel:nil highlightColor:nil ];
    }
}

-(void) createBottomButtons: (UIView *)parentView
{
    int sizeW = [[ self._params objectForKey:@"bottomButtonSize" ] intValue ];
    if( sizeW == 0 )
        return;

    NSNumber * nsizeH = [ self._params objectForKey:@"bottomButtonSizeH" ];
    if ( nsizeH == nil ) {
        nsizeH = [ NSNumber numberWithInt: 44 ];
    }
    int sizeH = nsizeH.intValue;
    
    NSNumber * nbottomMargin = [ self._params objectForKey:@"bottomMarginH" ];
    if ( nbottomMargin == nil ) {
        nbottomMargin = [ NSNumber numberWithInt: 0 ];
    }
    int bottomMarginH = nbottomMargin.intValue;
    int y = parentView.frame.size.height - sizeH - bottomMarginH;
    
    UIView * bottomView = [[ UIView alloc ] initWithFrame: CGRectMake(0,y,parentView.frame.size.width,sizeH) ];
    bottomView.backgroundColor = [ self._params objectForKey:@"bottomBarColor" ];
    
    [ parentView addSubview: bottomView ];
    
    y = 0;
    float interval = ( parentView.frame.size.width - 5 * sizeW )/6;
    if( interval < 0 )
        interval = 0;
    
    int x = interval;
    
    for(int i=1; i <= 5; i++ )
    {
        NSString * imgName = [ NSString stringWithFormat: @"bottom_section%d", i ];
        CRect * r = MYRECTI( x, y, sizeW, sizeH );
        [ self createImageButtonInView: bottomView imageName:imgName rect: r target:nil sel: nil highlightColor: nil ];
        x += sizeW + interval;
    }
}

-(void) setupNonEditableTitle: (NSString *) sTitle
{
    UIColor * titleColor = [ UIColor whiteColor ];
    
    NSObject * obj = [ self._params objectForKey:@"titleColor"];
    if( obj )
    {
        if( [ obj isKindOfClass: NSNumber.class ] )
            titleColor = COLOR_INT( [ (NSNumber*)obj intValue ] );
        else
            titleColor = (UIColor *)obj;
    }
    UILabel * title =  [ Utils createLabelInView: _view text:sTitle frame:CGRectMake(10,22,_view.frame.size.width-20,40) color:titleColor font:BOLDFONT(20) ];
    
    title.textAlignment = NSTextAlignmentCenter;
}

-(void) setupNavigationButtons: (NSString *)prevPageBtn nextPageBtn: (NSString *) nextPageBtn bTextMode:(bool)bTextMode
{
    _previousBtn = [ self setupNonEditableButton: prevPageBtn bTextMode:bTextMode destPage: PAGE_PREV ];
    _nextBtn = [ self setupNonEditableButton: nextPageBtn bTextMode:bTextMode destPage: PAGE_NEXT ];
}

-(CText *) setupNonEditableButton: (NSString *) btnName bTextMode:(bool)bTextMode destPage: (int) destPage
{
    NSString * imgName = [ [ btnName lowercaseString ] stringByReplacingOccurrencesOfString: @" " withString:@"-" ];
    NSString * btnRect = [ NSString stringWithFormat:@"%@Rect", imgName ];
    int btnColor = 0xffffff;
    if( [ _params objectForKey:@"btnFontColor" ] )
        btnColor = [[ _params objectForKey:@"btnFontColor" ] intValue ];
    
    CText * btn = [[ CText alloc ] initWithText:bTextMode? btnName: @"" rect:[ _params objectForKey:btnRect ]  color:btnColor font:MYFONT(14) container:self ];
    
    btn._background = [ self getImageName: imgName ];
    
    btn._editable = false;
    btn._linkPage = [ NSNumber numberWithInt: destPage ];
    
    return btn;
}

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    [ self setupViews:parentView bPlay:bPlay bResetView:true ];
    return _view;
}

-(void) initView: (UIView *) parentView bPlay:(bool)bPlay {
    
    if( _view )
        [ _view removeFromSuperview ];
    
    CGRect frame = (_frame==nil)? parentView.frame : [_frame getRect: parentView.frame ];
    UIView * mainV = [[ UIView alloc ] initWithFrame: frame ];
    _view = mainV;
    UIColor * bkColor = [_params objectForKey:@"backgroundColor" ];
    if( bkColor != nil )
        mainV.backgroundColor = bkColor;
    [ self loadBackgroundImage ];
    [ parentView addSubview: mainV ];
}

-(UIView *) setupViews: (UIView *) parentView bPlay:(bool)bPlay bResetView: (BOOL) bResetView
{
    if( bResetView || self._view == nil )
        [ self initView:parentView bPlay:bPlay ];
    else {
        [ parentView bringSubviewToFront: self._view ];
    }
    
    if( _topBar != nil && !_topBar._hidden )
        [_topBar render: _view bPlay: bPlay ];
    
    _view.userInteractionEnabled = true;
    
    [ self setupBackgroundClickHandler: _view bPlay: bPlay ];
    
    [ _previousBtn render: _view bPlay: bPlay ];
    [ _nextBtn render: _view bPlay: bPlay ];
    
    [ _hotkey render: _view bPlay:bPlay ];
    [ self renderProperties: bPlay ];
    
    return _view;
}

-(void) renderProperties: (BOOL) bPlay {
    
    [ __triggerTimer invalidate ];
    __triggerTimer = nil;
    
    [ self changeBrightness: _alpha ];
    [ self applyProximity: _proximitySensorEanbled ];
    
    if ( bPlay )
        [[ CVibrate sharedInstance ] play: self._vibrateMode ];
    
    NSString * action = bPlay? @"Play" : @"Preview";
    [[GAI sharedInstance].defaultTracker send: [[GAIDictionaryBuilder createEventWithCategory: _templateName
                                                                                       action: action
                                                                                        label: CURRENT_DEVICE_ID
                                                                                        value: nil ] build] ];
}

-(void) onRenderCompleted:(UIView *) parentView bPlay:(bool)bPlay
{
    [ self._view bringSubviewToFront: _hotkey._view  ];
}

-(void) onPageRemoved: ( NSNumber * ) pageId
{
    NSArray * arr = [ self getExitItems ];
    for (CElement *item in arr ) {
        if ( [ item._linkPage intValue ] == [ pageId intValue ] )
        {
            [ item setLinkToEnd ];
        }
    }
}

-(void) applyProximity: (bool) bEnable
{
    _proximitySensorEanbled = bEnable;
    [ [ UIDevice currentDevice] setProximityMonitoringEnabled: _proximitySensorEanbled ];
}

-(UIImageView *) loadBackgroundImage
{
    UIImage * img = _backgroundImg;
    bool bHigh = false;
    
    if( img == nil && _templateName != nil )
    {
        if( self._view.frame.size.height >= 568 )
        {
            img = [ Utils loadImage: @"backgroundH" templateName: _templateName ];
            _backgroundKeepAspect = false;
            bHigh = img != nil;
        }
        if( img == nil )
        {
            img = [ Utils loadImage: @"backgroundx" templateName: _templateName ];
            if( img == nil )
                img = [ Utils loadImage: @"background" templateName: _templateName ];
            else
                _backgroundKeepAspect = false;
        }
    }
    if( img == nil )
        return nil;
    
    UIImageView * backV = [[ UIImageView alloc ] initWithImage: img ];
    if( _backgroundKeepAspect )
    {
        CGSize s = self._view.frame.size;
        backV.frame = CGRectMake(0,0, s.width, s.width/img.size.width * img.size.height );
        
        //NSLog(@"frame: %f,%f", backV.frame.size.width, backV.frame.size.height );
    }else
    {
        if( bHigh )
        {
            CGSize s = self._view.frame.size;
            backV.frame = CGRectMake(0,0, s.width, img.size.height/2 );
        }else
            backV.frame = self._view.bounds;
    }
    [ self._view insertSubview: backV atIndex: 0 ];
    return backV;
}

-(void) setupBackgroundClickHandler: (UIView *)view bPlay: (bool) bPlay
{
    if( !bPlay )
    {
        if( [ _delegate respondsToSelector:@selector(onWholePageClicked:)] )
            [ Utils setSingleTapHandlerToView: view delegate: self target:_delegate sel:@selector(onWholePageClicked:) ];
    }
}

-(void) setupExitHandler
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 3.0;
    [ _view addGestureRecognizer:longPress ];
}

-(void)handleLongPress:(UILongPressGestureRecognizer*)sender
{
    NSLog(@"handleLongPress");
    if (sender.state == UIGestureRecognizerStateBegan){
        [ _delegate onPlayExit ];
    }
}

-(void) playInit: (UIView *) parentView bPlay: (BOOL) bPlay {
}

-(void) playEnd
{
    NSLog(@"page playEnd %@", self );
    
    if( _view )
    {
        [ _view removeFromSuperview ];
        _view = nil;
    }
}

-(UIView *) getBackgroundView
{
    UIView * view = _view;
    _view = nil;
    return view;
}

-(UIImage *) getThumbnail
{
    if( _thumbnail != nil )
        return _thumbnail;
    if( _backgroundImg != nil )
        return _backgroundImg;
    
    return [ Utils loadImage: _templateName ];
}

-(void) updateThumbnail
{
    _thumbnail = [ Utils captureView: self._view ];
}

-(UIImage *) captureScreenshot: ( UIView *) mainView fileName: (NSString *) fileName {
    
    UIView * view = [ self render: mainView bPlay: true ];
    UIImage * img = [ Utils captureView: view ];
    [ view removeFromSuperview ];
    [ Utils saveJPGImage:img fileName: fileName ];
    
    return img;
}

-(void) changeBrightness: (float) brightness
{
    _alpha = brightness;
    if (_delegate != nil ) {
        [UIScreen mainScreen].brightness =  [ _delegate getEnvBrightness ] * brightness;
    }
}

-(BOOL) onKeyAction: (bool) bBackword {
    return false;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ encoder encodeInt: _exitPos.x forKey: @"exitPosX" ];
    [ encoder encodeInt: _exitPos.y forKey: @"exitPosY" ];
    [ encoder encodeFloat: _alpha forKey: @"alpha" ];
    [ encoder encodeBool: _hasExtendedOptions forKey: @"hasExtendedOptions" ];
    [ encoder encodeBool: _proximitySensorEanbled forKey: @"proximitySensorEanbled" ];
    [ encoder encodeBool: _backgroundKeepAspect forKey: @"backgroundKeepAspect" ];
    [ encoder encodeBool: __partScreen forKey: @"partScreen" ];
    
    [ encoder encodeObject: _incomingPage forKey: @"incomingPage" ];
    [ encoder encodeObject: _pageID forKey: @"pageID" ];
    
    [ encoder encodeObject: _topBar forKey: @"topBar" ];
    [ encoder encodeObject: _templateName forKey: @"background" ];
    [ encoder encodeObject: _params forKey: @"params" ];
    [ encoder encodeObject: _backgroundImg forKey: @"backgroundImg" ];
    [ encoder encodeObject: _thumbnail forKey: @"thumbnail" ];

    [ encoder encodeObject: _nextBtn forKey: @"nextBtn" ];
    [ encoder encodeObject: _previousBtn forKey: @"previousBtn" ];

    [ encoder encodeObject: _hotkey forKey: @"_hotkey" ];
    [ encoder encodeInt: _transitionType forKey: @"transitionType" ];
    [ encoder encodeInt: __vibrateMode forKey: @"vibrateMode" ];

    [ encoder encodeFloat: _transitionTime forKey: @"transitionTime" ];
    [ encoder encodeInt: __triggerMode forKey: @"triggerMode" ];
    [ encoder encodeFloat: __triggerTime forKey: @"triggerTime" ];
    
    [ encoder encodeObject: _elements forKey: @"_elements" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super init] )
	{
		_topBar = [ decoder decodeObjectForKey: @"topBar" ];
        _topBar._container = self;
		_templateName = [ decoder decodeObjectForKey: @"background" ];
		_backgroundImg = [ decoder decodeObjectForKey: @"backgroundImg" ];
		_params = [ decoder decodeObjectForKey: @"params" ];
		_thumbnail = [ decoder decodeObjectForKey: @"thumbnail" ];

        _incomingPage = [ decoder decodeObjectForKey: @"incomingPage" ];
        _pageID = [ decoder decodeObjectForKey: @"pageID" ];
        
        _alpha = [ decoder decodeFloatForKey: @"alpha" ];
        _hasExtendedOptions = [ decoder decodeBoolForKey: @"hasExtendedOptions" ];
        _proximitySensorEanbled = [ decoder decodeBoolForKey: @"proximitySensorEanbled" ];
        _backgroundKeepAspect = [ decoder decodeBoolForKey: @"backgroundKeepAspect" ];
        __partScreen = [ decoder decodeBoolForKey: @"partScreen" ];
        
		_nextBtn = [ CElement decodeObject:decoder key:@"nextBtn" container:self ];
		_previousBtn = [ CElement decodeObject:decoder key:@"previousBtn" container:self ];

        _hotkey = [ CElement decodeObject:decoder key:@"_hotkey" container:self ];

        _transitionType = [ decoder decodeIntForKey: @"transitionType" ];
        _transitionTime = [ decoder decodeFloatForKey: @"transitionTime" ];

        __vibrateMode = [ decoder decodeIntForKey: @"vibrateMode" ];
        __triggerMode = [ decoder decodeIntForKey: @"triggerMode" ];
        __triggerTime = [ decoder decodeFloatForKey: @"triggerTime" ];
        
        int x = [ decoder decodeIntForKey: @"exitPosX" ];
        int y = [ decoder decodeIntForKey: @"exitPosY" ];
        
        _exitPos = CGPointMake( x, y );
        
		_elements = [ decoder decodeObjectForKey: @"_elements" ];
        for( int i=0; i < _elements.count; i++ )
        {
            CImage * img = _elements[i];
            img._container = self;
        }
	}
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view != _view )
        return NO;
    
    return YES;
}

@end
