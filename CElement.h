#import "CRect.h"

@class CPage;
@class CElement;

@protocol ElementDelegate
-(void)onElementClicked:(CElement *)obj param:(id) param;
-(void)onLinkClicked:(NSNumber *)linkPage sender:(id) sender;
-(void)popupVC:(UIViewController *)vc;
-(void)onContentRefresh;
-(bool)isEditing;
-(bool)isHotkeyShowing;
@end

@protocol ContainerDelegate <NSObject>
@optional
-(bool) onMemberAdded:(CElement *)obj;
-(void) onMemberChangedLayout:(CElement *)obj;
-(bool) onMemberRemoved:(CElement *)obj;
-(void) onMemberGetFocus:(CElement *)obj;
-(void) onMemberEndFocus:(CElement *)obj;
-(id<ElementDelegate>) getDelegate;
@end

@interface CElement : NSObject
{
    SEL _sel;
    id _target;
    bool _clicked;
}

@property (nonatomic, strong) CRect * _rect;
@property (nonatomic) bool _editable;
@property (nonatomic) bool _removeable;
@property (nonatomic) bool _hidden;
@property (nonatomic) bool _edited;
@property (nonatomic, weak ) id<ContainerDelegate> _container;
@property (nonatomic, weak ) UIView * _view;
@property (nonatomic, strong) NSNumber *_linkPage;

-(id) initWithTarget: (id) target sel: (SEL) sel container:(id<ContainerDelegate>) container;
-(UIView *) render: (UIView *) parentView bPlay: (bool) bPlay;
-(void) setLinkToNextPage;
-(void) setLinkToEnd;
-(void) setLinkToPage: (CPage *) page;
-(void) setLinkToPageIndex: (int) index;
-(void) setTarget: (id) target sel: (SEL) sel container:(id<ContainerDelegate>) container;

+(id) decodeObject: (NSCoder *) decoder key: (NSString *) key container: (id<ContainerDelegate>) container;

-(void) onClicked: (id) sender;

-(id<ElementDelegate>) getDelegate;
- (void) remove;
- (void) encodeWithCoder:(NSCoder *)encoder;
- (id) initWithCoder:(NSCoder *)decoder;
- (void) setupClickHandler;
- (void) flash;
- (void) copyFrom:(CElement *)element;

@end
