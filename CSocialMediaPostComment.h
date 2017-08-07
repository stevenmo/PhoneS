#import "CElement.h"
#import "CText.h"
#import "CImage.h"
#import "CMediaArea.h"
#import "PhoneSimulator-swift.h"
#import "ColorPickerViewController.h"

@interface CSocialMediaPostComment : CElement<ContainerDelegate,ColorPickerDelegate>
{
}

@property (nonatomic, strong) CText *_content;
@property (nonatomic, strong) CImage *_icon;

-(UIView *) render: (UIView *) parentView bPlay: (bool) bPlay;
-(CGFloat) getHeight: (UIView *) parentView;

@end
