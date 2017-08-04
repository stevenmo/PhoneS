#import "CImage.h"
#import "utils.h"
#import "Preference.h"

@implementation CImage

@synthesize _icon,_optionIcons,_image,_backgroundColor,_swipeable,_importable,_maskIcon;

-(id) initWithIcon: (NSString *) icon rect:(CRect *)rect target:(id) target sel:(SEL)sel container:(id<ContainerDelegate>)container optionIcons:(NSString *)optionIcons backgroundColor:(UIColor *)backgroundColor
{
    self = [ super initWithTarget: target sel:sel container:container ];
    _icon = icon;
    _optionIcons = [ self createIconNameArray: optionIcons ];
    _backgroundColor = backgroundColor;
    
    self._rect = rect;
    return self;
}

-(NSMutableArray *) createIconNameArray: (NSString *)maxIconName
{
    if( maxIconName == nil )
        return nil;
    
    int len = (int)maxIconName.length-1;
    
    int numb = [ maxIconName substringFromIndex: len ].intValue;
    if( numb >= 1  )
    {
        NSMutableArray * arr = [[ NSMutableArray alloc ] init ];
        NSString * prefix = [ maxIconName substringToIndex: len ];
        
        for( int i=0; i < numb+1; i++ )
        {
            NSString * s = [ NSString stringWithFormat:@"%@%d", prefix, i ];
            [ arr addObject: s ];
        }
        return arr;
    }
    return nil;
}

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    if( bPlay && (__icon2 != nil && _sel == nil ) )
    {
        _target = self;
        _sel = @selector(onButtonToggled:);
    }
    
    UIButton * btn = [ Utils createImageButtonWithHighlight: _target imageName: self._icon frame: [ self._rect getRect: parentView.frame ] sel: _sel highlightColor: self._highlightColor ];
    self._view = btn;

    if( _swipeable && bPlay )
        [ self setupSwipe ];
    
    if( __icon2 != nil || __image2 != nil ) {
        
        UIImage * img = __image2;
        if( img == nil )
            img = [ Utils loadImage: __icon2 ];
        
        [ btn setImage: img forState:UIControlStateSelected ];
        [ btn setImage: img forState:UIControlStateHighlighted ];
    }
    if( _sel == nil )
    {
        if( bPlay && !_swipeable && self._linkPage != nil )
        {
            [ btn removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside ];
            [ btn addTarget: self action:@selector(onLinkClicked:) forControlEvents:UIControlEventTouchUpInside ];
        }
    }
    if( _maskIcon != nil )
    {
        CALayer *mask = [CALayer layer];
        mask.contents = (id)[[ Utils loadImage: _maskIcon ] CGImage];
        mask.frame = btn.bounds;
        btn.layer.mask = mask;
        btn.layer.masksToBounds = YES;
    }
    if( __preferPureColor && _backgroundColor != nil )
        btn.backgroundColor = _backgroundColor;
    else if( _image != nil )
        [ self onImportedImage: _image ];

    return [ super render:parentView bPlay:bPlay ];
}

-(void) setupSwipe
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeHandle:)];


    
    [self._view addGestureRecognizer: recognizer ];
}

- (void) onSwipeHandle:(UIPanGestureRecognizer*)gestureRecognizer
{
    NSLog(@"onSwipeHandle");
    CGPoint translation = [gestureRecognizer translationInView: self._view];
    CGPoint center = self._view.center;
    if(center.x < 270){
        center.x += translation.x;
    }
    self._view.center = center;
    [gestureRecognizer setTranslation:CGPointZero inView:self._view];
//    self._view.center = CGPointMake(100, 100);
    
    [ [self getDelegate] onLinkClicked: self._linkPage sender: self ];
}

-(void) onButtonToggled: (UIButton *) btn
{
    NSLog(@"onButtonToggled: %d", btn.selected );
    
    [ btn setSelected: !btn.selected ];
}

-(void) onLinkClicked: (id) sender
{
    [ [ self getDelegate ] onLinkClicked: self._linkPage sender: self ];
}

-(void) onOptionSelected: (int) index newValue: (NSString *) newValue
{
    if( index >=0 )
        newValue = [ _optionIcons objectAtIndex: index ];
    
    if( newValue ==nil )
        return;
    
    self._edited = true;
    _icon = newValue;
    
    UIButton * btn = (UIButton * )self._view;
    UIImage * image = [ Utils loadImage: newValue ];
    
    [ btn setBackgroundImage:image forState: UIControlStateNormal ];
    
    if( [ self._container respondsToSelector: @selector(onMemberAdded:) ] )
    {
        if( [ self._container onMemberAdded: self ] )
            [ [self getDelegate] onContentRefresh ];
    }
}

-(void) onImportedImage: (UIImage *) img
{
    NSLog(@"onImportedImage: %f,%f,%f", img.scale, img.size.width, img.size.height );
    _image = img;
    self._edited = true;
    
    if( self._preferPureColor )
        self._backgroundColor = nil;
    
    UIButton * btn = (UIButton * )self._view;
    
    if( img == nil )
        img = [ Utils loadImage: _icon ];
    
    [ btn setBackgroundImage: img forState: UIControlStateNormal ];
}

-(void) onSetBackgroundColor: (int) color {
    
    self._backgroundColor = COLOR_INT(color);
    self._edited = true;
    
    UIButton * btn = (UIButton * )self._view;
    [ btn setBackgroundImage:nil forState: UIControlStateNormal ];
    btn.backgroundColor = self._backgroundColor;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];

    [ encoder encodeBool: __preferPureColor forKey: @"preferPureColor" ];
    [ encoder encodeBool: __needImportInstruction forKey: @"needImportInstruction" ];

    [ encoder encodeBool: _swipeable forKey: @"swipeable" ];
    [ encoder encodeBool: _importable forKey: @"importable" ];
    [ encoder encodeObject: _maskIcon forKey: @"maskIcon" ];
    
    [ encoder encodeObject: __caption forKey: @"caption" ];
    [ encoder encodeObject: _icon forKey: @"icon" ];
    [ encoder encodeObject: __icon2 forKey: @"icon2" ];
    [ encoder encodeObject: _optionIcons forKey: @"optionIcons" ];
    [ encoder encodeObject: __image2 forKey: @"image2" ];
    [ encoder encodeObject: _image forKey: @"image" ];
    [ encoder encodeObject: _backgroundColor forKey: @"backgroundColor" ];
    [ encoder encodeObject: __highlightColor forKey: @"highlightColor" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder: decoder ] )
	{
        __preferPureColor = [ decoder decodeBoolForKey: @"preferPureColor" ];
        __needImportInstruction = [ decoder decodeBoolForKey: @"needImportInstruction" ];

        _swipeable = [ decoder decodeBoolForKey: @"swipeable" ];
		_importable = [ decoder decodeBoolForKey: @"importable" ];
		_maskIcon = [ decoder decodeObjectForKey: @"maskIcon" ];

        __caption = [ decoder decodeObjectForKey: @"caption" ];
		_icon = [ decoder decodeObjectForKey: @"icon" ];
        __icon2 = [ decoder decodeObjectForKey: @"icon2" ];
		_optionIcons = [ decoder decodeObjectForKey: @"optionIcons" ];
		_image = [ decoder decodeObjectForKey: @"image" ];
        __image2 = [ decoder decodeObjectForKey: @"image2" ];
		_backgroundColor = [ decoder decodeObjectForKey: @"backgroundColor" ];
        __highlightColor = [ decoder decodeObjectForKey: @"highlightColor" ];
    }
    return self;
}

-(void) copyFrom:(CImage *)image
{
    [ super copyFrom: image ];
    _swipeable = image._swipeable;
    _importable = image._importable;
    _maskIcon = image._maskIcon;
    __caption = image._caption;
    _icon = image._icon;
    _optionIcons = image._optionIcons;
    _image = image._image;
    _backgroundColor = image._backgroundColor;
    __highlightColor = image._highlightColor;
}

@end
