#import <AudioToolbox/AudioToolbox.h> 
#import "CPageHome.h"
#import "Preference.h"
#import "Utils.h"
#import "TemplateManager.h"
#import "PhotoPicker.h"
#import "EditViewController.h"
#import "HomeIconImportVC.h"
#import "EditOptionIconsVC.h"

@implementation CPageHome

- (id)initWithTemplate: (NSString *)templateName delegate:(id)delegate params:(NSDictionary *)params
{
	self = [ super initWithTemplate: templateName delegate: delegate params: params ];
    _mailNotification = [ [ CText alloc ] initWithText:@"8" rect: MYRECTI(128,-88,24,24) color: 0xffffff font: BOLDFONT(18) container: self ];
    _mailNotification._background = [ self getImageName:@"notification-icon"];
    
    [ self setupIcons ];
    
	return self;
}

-(void) setupIcons
{
    if ( [ self._templateName containsString:@"home9" ] )
        _bottomIcons = [ NSMutableArray arrayWithObjects:@"Phone", @"Safari", @"Mail", @"Music", nil ];
    else if ( [ self._templateName containsString:@"home4" ] || [ self._templateName containsString:@"home5" ] || [ self._templateName containsString:@"home6" ] )
    {
        _bottomIcons = [ NSMutableArray arrayWithObjects:@"Phone", @"Mail", @"Safari", @"Music", nil ];
    }else {
        _bottomIcons = [ NSMutableArray arrayWithObjects:@"Phone", @"Mail", @"Browser", @"Music", nil ];
    }
    _icons = [ self getIcons: false ];
}

-(NSMutableArray *) getIcons: (BOOL) bAll
{
    if ( [ self._templateName containsString:@"home9" ] )
    {
        NSMutableArray * arr = [ NSMutableArray arrayWithObjects:@"Messager", @"Notes", @"Appstore", @"Camera",  @"Health", @"FaceTime", @"Clock",  @"Book", @"Calendar", @"Twitter", @"Weather", @"Photos", @"Maps", @"Stock", @"Game-Center", @"Settings", nil ];
        return arr;
    } else if ( [ self._templateName containsString:@"home6" ] )
    {
        NSMutableArray * arr = [ NSMutableArray arrayWithObjects:@"Appstore", @"Camera", @"Messager", @"FaceTime", @"Clock", @"Passbook", @"Notes", @"Recorder",  @"Twitter", @"Weather", @"Photos", @"Maps", @"Calendar", @"Game-Center", @"Settings", nil ];
        if ( bAll )
            [ arr addObjectsFromArray: [ NSMutableArray arrayWithObjects: @"iMovie", nil ] ];
        return arr;
        
    }else if ( [ self._templateName containsString:@"home4" ] || [ self._templateName containsString:@"home5" ] )
    {
        return [ NSMutableArray arrayWithObjects:@"Appstore", @"Camera", @"Clock", @"Passbook", @"Notes", @"Weather", @"Photos", @"Maps", @"Calendar", @"Game-Center", @"Settings", nil ];
    }else if ( [ self._templateName containsString:@"home7" ] )  {
        return [ NSMutableArray arrayWithObjects:@"Calculator", @"Camera", @"Clock", @"Contacts", @"Videos", @"Weather", @"Photos", @"Calendar", @"Messages", @"Games", @"Map", @"Settings",  nil ];
    }else {
        return [ NSMutableArray arrayWithObjects:@"Calculator", @"Camera", @"Clock", @"Contacts", @"Videos", @"Weather", @"Photos", @"Calendar", @"Messages", nil ];
    }
}

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    UIView * mainV = [ super render: parentView bPlay: bPlay ];
    
    [ self createButtons: mainV ];
    [ self createBottomButtons: mainV ];
    
    for( int i=0; i < _elements.count; i++ )
    {
        CImage * img = _elements[i];
        if ( i < _icons.count )
        {
            if ( [ _icons[i] isKindOfClass: NSString.class ] )
            {
                img._caption = _icons[i];
                _icons[i] = img;
            }
        } else {
            int newI = i - (int)_icons.count;
            if ( newI < _bottomIcons.count && [ _bottomIcons[newI] isKindOfClass: NSString.class ] )
            {
                img._caption = _bottomIcons[newI];
                _bottomIcons[newI] = img;
            }
        }
        img._container = self;
        img._importable = true;
        img._removeable = true;
    }
    [ self showNotification: bPlay ];
    
    return mainV;
}

-(void) onMemberChangedLayout:(CElement *)obj {
    
    if( obj == _mailNotification ) {
        [ self showNotification: false ];
    }
}

-(void) showNotification: (BOOL) bPlay
{
    if ( _mailNotification._text.length == 0 )
        _mailNotification._background = nil;
    else
        _mailNotification._background = [ self getImageName:@"notification-icon"];
    
    [ _mailNotification._view removeFromSuperview ];
    [ _mailNotification render: self._view bPlay: bPlay ];
}

-(BOOL) onEditElement: (CElement *)obj param:(id)param
{
    if ( obj._container == self && [ obj isKindOfClass: CImage.class ] ) {
        
        [ self performSelector:@selector(launchVC:) withObject:obj afterDelay:0.5 ];
        return true;
    }
    return false;
}

-(void) launchVC: (CElement *)obj
{
    UIViewController * vc = [[ HomeIconImportVC alloc ] initWithObject: obj delegate:self ];
    [ self._delegate popupVC: vc ];
}

-(void)onOptionClicked: (int) optionID
{
    if ( _icons.count >= 21 )
        return;
    
    CRect * r = [ CRect initWithRect: [ self getIconPos: (int)_icons.count ] ];
    CImage * img = [[CImage alloc ] initWithIcon:nil rect:r target:self sel:nil container:self optionIcons:nil backgroundColor:nil ];
    img._caption = @"Untitled";
    img._importable = true;
    img._removeable = true;
    img._maskIcon = [ self getImageNameWithThemem: @"mask" ];
    img._optionIcons =  [self getIcons: true ];
    [ self updateOptionIconsPath: img ];
    
    NSLog(@"onOptionClicked: %@", img );
    
    [ _icons addObject: img ];
    UIView * nView = [ img render: self._view bPlay:false ];
    [ self._view addSubview: nView ];
    
    UIViewController * vc = [[ HomeIconImportVC alloc ] initWithObject: img delegate:self ];
    [ self._delegate popupVC: vc ];
}

-(void) onEditCompleted:(CImage *)image{
    
    NSLog(@"onEditCompleted: %@", image );
    [ self._delegate onContentRefresh ];
}

-(CGRect) getIconPos: (int) index {
    
    UIView * mainV = self._view;
    
    int fullW = mainV.frame.size.width;
    int buttonSizeW = [[ self._params objectForKey:@"ButtonSizeW" ] intValue ];
    if ( buttonSizeW >= 61 )
        return [ self getIconPos3: index ];
    
    int buttonSizeH = [[ self._params objectForKey:@"ButtonSizeH" ] intValue ];
    
    int top = 27;
    float interval = ( fullW - (float)buttonSizeW * 4 ) / 5;
    float intervalH = [[ self._params objectForKey:@"intervalH" ] intValue ];
    
    float x2 = interval+buttonSizeW+interval;
    float x3 = x2 + buttonSizeW + interval;
    float x4 = fullW - interval-buttonSizeW;

    float y2 = top + buttonSizeH + intervalH;
    float y3 = top + buttonSizeH * 2 + intervalH * 2;
    float y4 = y3 + ( buttonSizeH + intervalH );
    float y5 = y4 + ( buttonSizeH + intervalH );
    float y6 = y5 + ( buttonSizeH + intervalH );
    float y7 = y6 + ( buttonSizeH + intervalH );
    
    CGPoint posArr[] = { CGPointMake( interval, top ), CGPointMake( x2, top ),CGPointMake( x3, top ),CGPointMake( x4, top ),  CGPointMake( interval, y2), CGPointMake( x2, y2),  CGPointMake( x3, y2 ), CGPointMake( x4, y2 ),
        CGPointMake( interval, y3), CGPointMake( x2, y3),  CGPointMake( x3, y3 ), CGPointMake( x4, y3 ),
        CGPointMake( interval, y4), CGPointMake( x2, y4),  CGPointMake( x3, y4 ), CGPointMake( x4, y4 ),
        CGPointMake( interval, y5), CGPointMake( x2, y5),  CGPointMake( x3, y5 ), CGPointMake( x4, y5 ),
        CGPointMake( interval, y6), CGPointMake( x2, y6),  CGPointMake( x3, y6 ), CGPointMake( x4, y6 ),
        CGPointMake( interval, y7), CGPointMake( x2, y7),  CGPointMake( x3, y7 ), CGPointMake( x4, y7 ),
    };
    
    return CGRectMake( posArr[index].x, posArr[index].y, buttonSizeW, buttonSizeH );
}

-(CGRect) getIconPos3: (int) index {

    UIView * mainV = self._view;
    
    int fullW = mainV.frame.size.width;
    int buttonSizeW = [[ self._params objectForKey:@"ButtonSizeW" ] intValue ];
    int buttonSizeH = [[ self._params objectForKey:@"ButtonSizeH" ] intValue ];
    
    int top = 50;
    float interval = ( fullW - (float)buttonSizeW * 3 ) / 4;
    float intervalH = [[ self._params objectForKey:@"intervalH" ] intValue ];
    
    float x2 = interval+buttonSizeW+interval;
    float x3 = fullW - interval-buttonSizeW;
    float y2 = top + buttonSizeH + intervalH;
    float y3 = top + buttonSizeH * 2 + intervalH * 2;
    float y4 = y3 + ( buttonSizeH + intervalH );
    float y5 = y4 + ( buttonSizeH + intervalH );
    float y6 = y5 + ( buttonSizeH + intervalH );
    float y7 = y6 + ( buttonSizeH + intervalH );
    
    CGPoint posArr[] = { CGPointMake( interval, top ), CGPointMake( x2, top ),CGPointMake( x3, top ), CGPointMake( interval, y2), CGPointMake( x2, y2),  CGPointMake( x3, y2 ),
        CGPointMake( interval, y3), CGPointMake( x2, y3),  CGPointMake( x3, y3 ),
        CGPointMake( interval, y4), CGPointMake( x2, y4),  CGPointMake( x3, y4 ),
        CGPointMake( interval, y5), CGPointMake( x2, y5),  CGPointMake( x3, y5 ),
        CGPointMake( interval, y6), CGPointMake( x2, y6),  CGPointMake( x3, y6 ),
        CGPointMake( interval, y7), CGPointMake( x2, y7),  CGPointMake( x3, y7 ),
    };
    
    return CGRectMake( posArr[index].x, posArr[index].y, buttonSizeW, buttonSizeH );
}

-(void) createButtons: (UIView *)mainV
{
    for(int i=0; i < _icons.count; i++ )
    {
        CGRect r = [ self getIconPos: i ];
        [ self createAItem: _icons[i] r: MYRECTR(r) mainV:mainV ];
    }
}

#define TEXT_SIZEH            25
#define MARGIN_BOTTOMBAR_TOP  13

-(void) createAItem: (NSObject *)item r: (CRect *) r mainV:(UIView *)mainV
{
    NSString * caption;
    
    if ( [ item isKindOfClass: NSString.class ] )
    {
        NSString * imgName = (NSString *)item;
        [ self createImageButtonInView:mainV imageName:imgName.lowercaseString rect: r target:self sel:nil ];
        caption = imgName;
        
        CImage * img = [ self findElementByImageName: imgName.lowercaseString ];
        img._optionIcons =  [self getIcons: true ];
        [ self updateOptionIconsPath: img ];
        
    }else{
        CImage * img = (CImage *)item;
        BOOL bFound = false;
        
        for( int i =0; i < _elements.count; i++ ) {
            if ( img == _elements[i] ){
                bFound = true;
            }
        }
        if ( !bFound ) {
            if ( img._linkPage == nil  )
                img._linkPage = PAGE_DEAD_LINK;
            [_elements addObject: img ];
        }
        img._rect = r;
        caption = img._caption;
        [ img render: mainV bPlay: ![ self._delegate isEditing ] ];
    }
    CGRect rLabel = [ r getRect: mainV.frame ];
    rLabel.origin.y += rLabel.size.height;
    rLabel.size.height = TEXT_SIZEH;
    rLabel.origin.x -= 25;
    rLabel.size.width += 50;
    
    UILabel * label = [ Utils createLabelInView:mainV text:caption frame: rLabel color: [UIColor whiteColor] font:MYFONT(14) ];
    label.textAlignment = NSTextAlignmentCenter;
}

-(void) updateOptionIconsPath: (CImage *) img
{
    for( int i=0; i < img._optionIcons.count; i++ ) {

        img._optionIcons[i] = [ Utils getImageName: img._optionIcons[i] templateName: self._templateName ].lowercaseString;
    }
}

-(void) createBottomButtons: (UIView *)parentView
{
    int sizeW = [[ self._params objectForKey:@"bottomButtonSizeW" ] intValue ];
    if( sizeW == 0 )
        return;
    
    int sizeH = [[ self._params objectForKey:@"bottomButtonSizeH" ] intValue ];
    int y = parentView.frame.size.height - sizeH - TEXT_SIZEH - MARGIN_BOTTOMBAR_TOP;
    
    UIImageView * bottomView = [[ UIImageView alloc ] initWithFrame: CGRectMake(0,y,parentView.frame.size.width,sizeH+TEXT_SIZEH + MARGIN_BOTTOMBAR_TOP ) ];
    bottomView.backgroundColor = [ self._params objectForKey:@"bottomBarColor" ];
    bottomView.userInteractionEnabled = true;
    if( bottomView.backgroundColor == nil )
    {
        NSString * imgName = [ self getImageName: @"bottom-bar" ];
        bottomView.image = [ Utils loadImage: imgName ];
    }
    [ parentView addSubview: bottomView ];
    
    y = MARGIN_BOTTOMBAR_TOP;
    float interval = ( parentView.frame.size.width - 4 * sizeW )/5;
    int x = interval;
    
    for(int i=0; i < _bottomIcons.count; i++ )
    {
        CRect * r = MYRECTI( x, y, sizeW, sizeH );
        
        [ self createAItem:_bottomIcons[i] r:r mainV: bottomView ];
        if( i == 1 )
            [ _mailNotification._rect setPos: r._posX - 8 posY: bottomView.frame.origin.y + r._posY -8 ];
        
        x += sizeW + interval;
    }
}

-(bool) onMemberRemoved:(CElement *)obj
{
    NSLog(@"onMemberRemoved");
    
    for( int index = (int)_icons.count-1; (int)index >=0; index-- )
    {
        if ( obj == _icons[index] )
            [ _icons removeObjectAtIndex:index ];
    }

    for( int index = (int)_bottomIcons.count-1; (int)index >=0; index-- )
    {
        if ( obj == _bottomIcons[index] )
            [ _bottomIcons removeObjectAtIndex:index ];
    }
    
    for( int i =0; i < _elements.count; i++ ) {
        if ( obj == _elements[i] ) {
            [_elements removeObject: obj ];
            break;
        }
    }
    
    [ self._delegate onContentRefresh ];
    
    return true;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];

    [ encoder encodeObject: _icons forKey: @"_icons" ];
    [ encoder encodeObject: _bottomIcons forKey: @"_bottomIcons" ];
    [ encoder encodeObject: _mailNotification forKey: @"_mailNotification" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder: decoder ] )
	{
        _icons = [ decoder decodeObjectForKey: @"_icons" ];
        _bottomIcons = [ decoder decodeObjectForKey: @"_bottomIcons" ];
        _mailNotification = [ CElement decodeObject:decoder key:@"_mailNotification" container:self ];
    }
    return self;
}


@end
