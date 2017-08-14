#import "CText.h"
#import "CImage.h"
#import "CElement.h"
#import "CBattery.h"

@interface CTopBar : CElement<ContainerDelegate>
{
}

@property (nonatomic, strong) CText *_carrier;
@property (nonatomic, strong) CText *_time;
@property (nonatomic, strong) NSString *_background;
@property (nonatomic, strong) CBattery *_battery;
@property (nonatomic, strong) CImage *_signal;
@property (nonatomic, strong) CImage *_wifi;
@property (nonatomic, strong) UIButton * _invertBtn;

@property (nonatomic) int _color;
@property (nonatomic) int _height;

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay;

-(id) initWithTheme: (NSString *) themeId container:(id<ContainerDelegate>)container color:(int)color backgroundColor: (UIColor *) backgroundColor batteryRect: (CRect *) batteryRect batteryColor: (int) batteryColor signalRect: (CRect *) signalRect maxSignalIcon: (NSString *) maxSignalIcon wifiRect: (CRect *) wifiRect maxWifiIcon: (NSString *) maxWifiIcon carrierRect: (CRect *) carrierRect timeRect: (CRect *) timeRect ;
- (void) copyFrom: ( CTopBar *) topBar;
-(void) setTextColor: (int) color;


@end
