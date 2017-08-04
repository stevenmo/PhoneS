#import "CRect.h"
#import "CElement.h"

@interface CImage : CElement
{
}

@property (nonatomic, strong) UIImage *_image2;
@property (nonatomic, strong) NSString *_icon2;
@property (nonatomic, strong) UIImage *_image;
@property (nonatomic, strong) NSString *_icon;
@property (nonatomic, strong) NSString *_caption;
@property (nonatomic, strong) NSMutableArray *_optionIcons;
@property (nonatomic, strong) UIColor * _backgroundColor;
@property (nonatomic, strong) UIColor * _highlightColor;
@property (nonatomic, strong) NSString *_maskIcon;
@property (nonatomic) bool _swipeable;
@property (nonatomic) bool _importable;
@property (nonatomic) bool _preferPureColor;
@property (nonatomic) bool _needImportInstruction;



-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay;
-(id) initWithIcon: (NSString *) icon rect:(CRect *)rect target:(id) target sel:(SEL)sel container:(id<ContainerDelegate>)container optionIcons:(NSString *)optionIcons backgroundColor: (UIColor *) backgroundColor;

-(void) onSetBackgroundColor: (int) color;
-(void) onOptionSelected: (int) index newValue: (NSString *) newValue;
-(void) onImportedImage: (UIImage *) img;
- (id)initWithCoder:(NSCoder *)decoder;
-(void) copyFrom:(CImage *)image;
- (void) onSwipeHandle:(UIPanGestureRecognizer*)gestureRecognizer;

@end
