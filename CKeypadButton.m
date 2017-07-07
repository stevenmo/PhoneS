#import "CKeypadButton.h"
#import "utils.h"
#import "Preference.h"
#import "ImageUtil.h"

@implementation CKeypadButton

-(id) initWithNumber: (NSString *) sNumb template:(NSString *)template subString:(NSString *) subString target:(id) target sel:(SEL)sel textColor:(UIColor *)textColor ringColor: (UIColor *)ringColor pos:(CGPoint)pos width: (int) width height:(int)height
{
    NSString * sImgName = [ Utils getImageName:sNumb templateName:template ];
    NSString * sImgHigh = [ NSString stringWithFormat:@"%@_high", sImgName ];
    
    UIImage * image = [ Utils loadImage: sImgName ];
    UIImage * imageH = [ Utils loadImage: sImgHigh ];
    
    self = [ super init ];
    self.frame = CGRectMake(pos.x,pos.y,width,height);
    
    [ self setBackgroundImage:image forState: UIControlStateNormal ];
    [ self setBackgroundImage:imageH forState: UIControlStateHighlighted ];

    [ self addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside ];
    
    self._sNumber = sNumb;
    
  /*  float top = (subString.length > 0)? 5 : 18;
    float hLabel = (subString.length > 0)? width - 20 : width-20;
    
    UILabel * label = [ Utils createLabel:sNumb frame: CGRectMake(5,top,width-10,hLabel)  color:textColor font: [UIFont systemFontOfSize:40] ];
    label.textAlignment = NSTextAlignmentCenter;
    
    [ self addSubview: label ];
    
    if( subString.length > 0 )
    {
        label = [ Utils createLabel: subString frame:CGRectMake(5,width-30,width-10,20) color:textColor font: [UIFont systemFontOfSize:12] ];
        
        [ self addSubview: label ];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    UIView * circleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,width)];
    circleView.layer.cornerRadius = width/2;
    //circleView.backgroundColor = [UIColor ]
    circleView.layer.borderColor = ringColor.CGColor;
    circleView.layer.borderWidth = 2;
    
    [ self addSubview: circleView ]; */
    
    return self;
}

@end
