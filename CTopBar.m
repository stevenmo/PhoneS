#import "CTopBar.h"
#import "utils.h"
#import "Preference.h"
#import "UIActionSheet+Blocks.h"
#import "CPage.h"

@implementation CTopBar

@synthesize _carrier,_background,_time,_height,_color,_battery,_signal,_wifi;


-(id) initWithTheme: (NSString *) themeId container:(id<ContainerDelegate>)container color:(int)color backgroundColor: (UIColor *) backgroundColor batteryRect: (CRect *) batteryRect batteryColor: (int) batteryColor signalRect: (CRect *) signalRect maxSignalIcon: (NSString *) maxSignalIcon wifiRect: (CRect *) wifiRect maxWifiIcon: (NSString *) maxWifiIcon carrierRect: (CRect *) carrierRect timeRect: (CRect *) timeRect
{
    self = [ super init ];
    
    //NSArray * icons = [ NSArray arrayWithObjects:@"incoming_call1/battery1", @"incoming_call1/battery2", @"incoming_call1/battery3", nil ];
    _battery = [ [ CBattery alloc ] initWithIcon:[ Utils getImageName:  @"battery" templateName: themeId ] color:batteryColor rect: batteryRect  withPercentage:false percentageColor:color container:self  optionIcons: nil backgroundColor: backgroundColor ];

    _signal = [[ CImage alloc ] initWithIcon: [ Utils getImageName:  @"signal2" templateName: themeId ]  rect: signalRect target:nil sel:nil container:self optionIcons: [ Utils getImageName: maxSignalIcon templateName: themeId ]  backgroundColor:backgroundColor ];
    _signal._removeable = true;

    _wifi = [[ CImage alloc ] initWithIcon: [ Utils getImageName:  @"wifi3" templateName: themeId ]  rect: wifiRect target:nil sel:nil container:self optionIcons: [ Utils getImageName: maxWifiIcon templateName: themeId ] backgroundColor:backgroundColor ];
    _wifi._removeable = true;

    _background = [ Utils getImageName: @"top-bar" templateName: themeId ];
    _height = 21;
    _color = color;
    _carrier = [ [ CText alloc ] initWithText: @"MintT" rect: carrierRect  color: _color font: MYFONT(12) container:self ];
    _carrier._alignMode = TEXTALIGN_CENTER;
    _time = [ [ CText alloc ] initWithText: @"9:00PM" rect: timeRect  color: _color font: MYFONT(12) container:self ];
    _time._inputType = UIKeyboardTypeNumbersAndPunctuation;

<<<<<<< HEAD
    

=======
>>>>>>> 9aba0bbf27d30443601958cc5dca6c9ab6892b56
    return self;
}

-(void) setTextColor: (int) color {
    
    _color = color;
    _carrier._color = color;
    _time._color = color;
}

-(id<ElementDelegate>) getDelegate
{
    return [ self._container getDelegate ];
}

-(void) invertTop{
    CPage * page = (CPage *)self._container;
    [ page invertTopBar ];
}

-(void) setupInvertButton: (UIView *) parentView
{
    UIButton * invertBtn;

    CRect *invertBox = CENTER_RECTX(240, 0, 100, 21);
    CGRect invertRect = invertBox.getOriginalRect;
    
    invertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    invertBtn.frame = invertRect;

    [invertBtn setTitleColor:COLOR_INT(_color) forState:UIControlStateNormal];
    invertBtn.titleLabel.font = MYFONT(12);

    [invertBtn addTarget:self
                    action:@selector(invertTop)
          forControlEvents:UIControlEventTouchUpInside];
    [invertBtn setTitle:@"Invert" forState:UIControlStateNormal];

    [ parentView addSubview: invertBtn];
}

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    UIButton * mainV = [[ UIButton alloc ] initWithFrame: CGRectMake(0,0, parentView.frame.size.width,_height) ];
    if( _background != nil )
    {
        [ mainV setBackgroundImage: [ Utils loadImage: _background ]  forState: UIControlStateNormal ];
    }
<<<<<<< HEAD
    
//    if(__initinvert){
//        CPage * page = (CPage *)self._container;
//        [ page invertTopBar ];
//    }
    CRect *invertBox = CENTER_RECTX(240, 0, 100, 21);
    CGRect invertRect = invertBox.getOriginalRect;
    __invertBtn.frame = invertRect;


    
    [__invertBtn addTarget:self
                    action:@selector(invertTop)
          forControlEvents:UIControlEventTouchUpInside];
    [__invertBtn setTitle:@"Invert" forState:UIControlStateNormal];
=======
>>>>>>> 9aba0bbf27d30443601958cc5dca6c9ab6892b56
    
    if( !bPlay)
        [ self setupInvertButton: mainV ];

    [ _carrier render: mainV bPlay: bPlay ];
    [ _time render: mainV bPlay: bPlay ];
    [ _signal render: mainV bPlay: bPlay ];
    [ _wifi render: mainV bPlay: bPlay ];
    
    [ _battery render: mainV bPlay: bPlay ];

    self._view = mainV;
    
//    if( !bPlay )
//        [ Utils setSingleTapHandlerToView: mainV delegate: nil target:self sel:@selector(onBarClicked:) ];
    
    return [super render: parentView bPlay:bPlay ];
}

-(void) onBarClicked: (id) sender
{
//    NSArray * btns = @[ @"Invert" ];
//    
//    [UIActionSheet presentOnView: self._view
//                       withTitle: nil
//                    cancelButton: @"Cancel"
//               destructiveButton: nil
//                    otherButtons: btns
//                        onCancel:^(UIActionSheet *actionSheet) {
//                        }
//                   onDestructive:^(UIActionSheet *actionSheet) {
//                   }
//                 onClickedButton:^(UIActionSheet *actionSheet, NSUInteger index) {
//                     
//                     CPage * page = (CPage *)self._container;
//                     [ page invertTopBar ];
//                 }];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];
    
    [ encoder encodeObject: _carrier forKey: @"carrier" ];
    [ encoder encodeObject: _signal forKey: @"signal" ];
    [ encoder encodeObject: _wifi forKey: @"wifi" ];
    [ encoder encodeObject: _background forKey: @"background" ];
    [ encoder encodeObject: _time forKey: @"time" ];
    [ encoder encodeInt: _color forKey: @"color" ];
    [ encoder encodeInt: _height forKey: @"height" ];
    [ encoder encodeObject:_battery forKey: @"battery" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder:decoder ] )
	{
        _carrier = [ CElement decodeObject:decoder key:@"carrier" container:self ];
        _signal = [ CElement decodeObject:decoder key:@"signal" container:self ];
        _wifi = [ CElement decodeObject:decoder key:@"wifi" container:self ];
        _time = [ CElement decodeObject:decoder key:@"time" container:self ];
        _battery = [ CElement decodeObject:decoder key:@"battery" container:self ];
        
		_background = [ decoder decodeObjectForKey: @"background" ];
        _height = [ decoder decodeIntForKey: @"height" ];
		_color = [ decoder decodeIntForKey: @"color" ];
	}
    return self;
}

- (void) copyFrom: ( CTopBar *) topBar
{
    [ super copyFrom: topBar ];
    [ _carrier copyFrom: topBar._carrier ];
    [ _signal copyFrom: topBar._signal ];
    [ _wifi copyFrom: topBar._wifi ];
    [ _time copyFrom: topBar._time ];
    [ _battery copyFrom: topBar._battery ];

    _background = topBar._background;
    _height = topBar._height;
    _color = topBar._color;
}

@end
