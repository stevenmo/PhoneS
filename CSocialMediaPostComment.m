#import "CSocialMediaPostComment.h"
#import "Preference.h"
#import "utils.h"
#import "imageUtil.h"
#import "UIActionSheet+Blocks.h"
#import "PhoneSimulator-swift.h"
#import "CSettings.h"
#import "ColorPickerViewController.h"
#import "CRichText.h"

@implementation CSocialMediaPostComment

-(id<ElementDelegate>) getDelegate
{
    return [ self._container getDelegate ];
}

-(id) initWithTarget:(id)target sel:(SEL)sel container:(id<ContainerDelegate>)container
{
    self = [ super initWithTarget:target sel:sel container:container ];

    __icon = [[ CImage alloc ] initWithIcon: @"avatar0" rect: MYRECTI(10, 4, 24, 24) target:nil sel:nil container: self optionIcons:nil backgroundColor: nil ];
    __icon._removeable = true;
    
    int color = 0;
    if ( [ CSettings sharedInstance ]._recentColor3 != nil )
        color = [ Utils convertColor: [ CSettings sharedInstance ]._recentColor3 ];
    UIFont * font = MYFONT(14);
    if ( [ CSettings sharedInstance ]._recentFont != nil )
        font = [ CSettings sharedInstance ]._recentFont;
    
    __content = [ [ CRichText alloc ] initWithText:@"<b>Jon Walker: </b> Sweet!" rect:MYRECTI(40, 0, -50, 36) color:color font: font container: self ];
    
    __content._autoFitH = true;
    __content._edited = true;
    __content._alignMode = TEXTALIGN_LEFT;
    return self;
}

-(void) updateLayout
{
    
}

-(UIView *) render: (UIView *) parentView bPlay: (bool) bPlay
{
    [ self._view removeFromSuperview ];
    
    UIView * view = [[UIView alloc ] initWithFrame: [ self._rect getRect: parentView.frame ] ];
    self._view = view;
    [ parentView addSubview: view ];
    
    [ __icon render: view bPlay:bPlay ];
    [ Utils circleMaskView: __icon._view ];
    
    [ __content render: view bPlay:bPlay ];
    
    return view;
}

-(void) onMemberChangedLayout: (CElement *) element {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onProjectEditted" object:self];
    [ [ self getDelegate ] onContentRefresh ];
}

-(bool) onMemberRemoved:(CElement *)obj
{
    NSLog(@"onMemberRemoved");
    
    __content._rect._posX = 10;
    __content._rect._width += 30;
    
    //[ __content render: self._view bPlay:false ];

    [ self render: self._view.superview bPlay: false ];
    
    return false;
}

-(CGFloat) getHeight: (UIView *) parentView {

    CGFloat h = [__content getAutoFitRect: parentView ].size.height + 3;
    return MAX(h,32);
}

-(void) onSectionHeaderClicked: (id) sender
{
    NSArray * btns = @[ @"Change Color", @"Remove Bar" ];
    
    [UIActionSheet presentOnView: self._view
                       withTitle: nil
                    cancelButton: @"Cancel"
               destructiveButton: nil
                    otherButtons: btns
                        onCancel:^(UIActionSheet *actionSheet) {
                        }
                   onDestructive:^(UIActionSheet *actionSheet) {
                   }
                 onClickedButton:^(UIActionSheet *actionSheet, NSUInteger index) {
                 }];
}

-(void) onColorSelected:  (int) color controlId:(int)controlId
{
    NSLog(@"onColorSelected");
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];

    [ encoder encodeObject: __icon forKey: @"_icon" ];
    [ encoder encodeObject: __content forKey: @"_content" ];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder:decoder ] )
    {
        __icon = [ CElement decodeObject:decoder key:@"_icon" container: self ];
        __content = [ CElement decodeObject:decoder key:@"_content" container: self ];
    }
    return self;
}

@end
