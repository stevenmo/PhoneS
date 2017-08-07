#import "CSocialMediaPost.h"
#import "Preference.h"
#import "utils.h"
#import "imageUtil.h"
#import "UIActionSheet+Blocks.h"
#import "PhoneSimulator-swift.h"
#import "VideoPicker.h"
#import "CSettings.h"
#import "ColorPickerViewController.h"
#import "CRichText.h"
#import "CSocialMediaPostComment.h"
#import "PhotoPinchVC.h"

@implementation CSocialMediaPost

-(id<ElementDelegate>) getDelegate
{
    return [ self._container getDelegate ];
}

-(id) initWithTarget:(id)target sel:(SEL)sel container:(id<ContainerDelegate>)container
{
    self = [ super initWithTarget:target sel:sel container:container ];
    
    __image = [[ CMediaArea alloc ] initWithIcon: @"unknown2" rect: MYRECTI(0,0,0,300) target:nil sel:nil container: self optionIcons:nil backgroundColor: nil ];
    [ self setupRatingIcons ];

    int color = 0xa0a0a0;
    NSNumber * hColor = (NSNumber *)[[ CSettings sharedInstance ] getObject:@"socialHeadColor" ];
    if( hColor != nil ) {
        color = [ hColor intValue ];
    }
    _headerColor = color;
    _hasHeader = true;
    
    __likeLabel = [[ CText alloc ] initWithText:@"1776 likes" rect:MYRECTI(10,36,120,22) color:0x000000 font:ITALICFONT(13) container:self ];
    __likeLabel._alignMode = TEXTALIGN_LEFT;
    [ __likeLabel setLinkToEnd ];
    
    _comments = [[ NSMutableArray alloc ] init ];
    
    return self;
}

-(void) setupRatingIcons
{
    NSString * sIconNames[RatingIconsNUMB] = { @"like", @"messages", @"share" };
    int y = 310;
    
    for( int i=0; i < RatingIconsNUMB; i++ ) {

        NSString * name = [ NSString stringWithFormat: @"social/%@", sIconNames[i] ];
        _ratingIcons[i] = [[ CImage alloc ] initWithIcon: name rect: MYRECTI(0,y,24,24) target:nil sel:nil container: self optionIcons:nil backgroundColor: nil ];
        _ratingIcons[i]._removeable = true;
    }
    _ratingIcons[0]._icon2 = @"social/likeH";
    [ self updateRatingIconPos ];
}

-(void) autoLayout: (UIView *) parentView {
    
 /*   float w = parentView.frame.size.width;
    [ ((CRichText *)__content) updateText: __content._text ];
    NSAttributedString * attr = ((CRichText *)__content)._attributedText;
    float h = [ Utils getAttributedTextSize:attr width: w-20 font: __content._font ].height + 40;
    __content._rect._height = h;
*/
    float posY = __image._rect._posY + __image._rect._height;
    for( int i=0; i < RatingIconsNUMB; i++ ) {
        _ratingIcons[i]._rect._posY = posY + 10;
    }
    __likeLabel._rect._posY = posY + 40;
    _commentPosY = posY + 66;
}

-(void) updateRatingIconPos
{
    int x = 10;
    
    for( int i=0; i < RatingIconsNUMB; i++ ) {
        
        if ( _ratingIcons[i] != nil )
        {
            _ratingIcons[i]._rect._posX = x;
            x += 35;
        }
    }
}

-(UITableViewCell *) render: (UIView *) parentView bPlay: (bool) bPlay
{
    UITableViewCell * cell = [[ UITableViewCell alloc ] init ];
    cell.frame = CGRectMake(0,0,parentView.frame.size.width,cell.frame.size.height);
    self._view = cell;
    
    [ __image render: cell bPlay:bPlay ];
    
    for( int i=0; i < RatingIconsNUMB; i++ ) {
        [ _ratingIcons[i] render: cell bPlay: bPlay ];
    }

    [ __likeLabel render: cell bPlay: bPlay ];
    
    [ self autoLayout: parentView ];
    [ self setupComments: bPlay ];
    
    for( CSocialMediaPostComment * comment in _comments ) {
        [ comment render: cell  bPlay: bPlay ];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void) setupComments: (BOOL) bPlay {

    CGFloat y =  _commentPosY;  //__content._rect._posY;
    CGFloat w = self._view.frame.size.width;
    
    for ( CSocialMediaPostComment * comment in _comments ) {
        CGFloat h = [ comment getHeight: self._view ];
        comment._rect = MYRECTI( 0, y, w, h );
        y += h;
    }

    if( !bPlay ) {
        CGRect frame = CGRectMake(0, y, w, 30 );
        UIView * label = [ Utils createClickableLabel:@"Add comment" frame:frame color:[ UIColor blueColor ] font:MYFONT(14) target:self sel:@selector(onAddCommentClicked:) labelTag: 0 ];
        [ self._view addSubview: label ];
        
        frame = CGRectMake(0, y+30, w, 30 );
        label = [ Utils createClickableLabel:@"Remove last comment" frame:frame color:[ UIColor blueColor ] font:MYFONT(14) target:self sel:@selector(onRemoveCommentClicked:) labelTag: 0 ];
        [ self._view addSubview: label ];
    }
}

-(void) onAddCommentClicked: (id) sender {
    
    CSocialMediaPostComment * comment = [[ CSocialMediaPostComment alloc ] initWithTarget:self sel:nil container:self ];
    [ (NSMutableArray *)_comments addObject: comment ];
    UITableView * tableView = (UITableView *)self._view.superview.superview;
    [ tableView reloadData ];
}

-(void) onRemoveCommentClicked: (id) sender {
    
    [ (NSMutableArray *)_comments removeLastObject ];
    UITableView * tableView = (UITableView *)self._view.superview.superview;
    [ tableView reloadData ];
}

-(void) onMemberChangedLayout: (CElement *) element {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onProjectEditted" object:self];
    [ self autoLayout: self._view ];
    [ [ self getDelegate ] onContentRefresh ];
}

-(bool) onMemberRemoved:(CElement *)obj
{
    NSLog(@"onMemberRemoved");

    for( int i=0; i < RatingIconsNUMB; i++ ) {
        if ( _ratingIcons[i] == obj ) {
            _ratingIcons[i] = nil;
            [ self updateRatingIconPos ];
            return true;
        }
    }
    return false;
}

-(CGFloat) getContentHeight: (UITableView *) tableView {

    [ self autoLayout: tableView ];
    BOOL bPlay = [[ self getDelegate ] isEditing ]? false: true;

    CGFloat y = 0;
    for ( CSocialMediaPostComment * comment in _comments ) {
        CGFloat h = [ comment getHeight: self._view ];
        y += h;
    }
    
    CGFloat hTotal = _commentPosY + y + 10;   //__content._rect._posY + y + 10;
    return bPlay? hTotal: hTotal + 60;
}

-(UIView *) getSectionHeaderView: (UITableView *) tableView {
    
    if ( !_hasHeader )
        return nil;

    float w = tableView.frame.size.width;
    float h = [ self getSectionHeaderHeight: tableView ];

    UIButton * view = [[ UIButton alloc ] init ];
    view.backgroundColor = COLOR_INT(_headerColor);
    view.frame = CGRectMake( 0, 0, w, h );

    _headerView = view;

    BOOL bPlay =  ![ [self._container getDelegate ] isEditing ];
    
    if( _headerImage == nil )
    {
        CRect * rect = MYRECTI(0,0,0,44);
        _headerImage = [[ CImage alloc ] initWithIcon: nil rect:rect target:nil sel:nil container: self optionIcons:nil backgroundColor: nil ];
    }
    [ _headerImage render: view bPlay:bPlay ];
    _headerImage._view.userInteractionEnabled = false;

    if ( __title == nil ) {
        __title = [[ CText alloc ] initWithText:@"My Section Header" rect:MYRECTI(51,1,270,32) color:0x000000 font:BOLDFONT(16) container:self ];
        __title._alignMode = TEXTALIGN_LEFT;
        [ __title setLinkToEnd ];
        
        __subTitle = [[ CText alloc ] initWithText:@"My Location" rect:MYRECTI(51,29,270,16) color:0x000000 font:ITALICFONT(13) container:self ];
        __subTitle._alignMode = TEXTALIGN_LEFT;
        [ __subTitle setLinkToEnd ];
        
        __icon = [[ CImage alloc ] initWithIcon: @"avatar0" rect: MYRECTI(0,0,48,48) target:nil sel:nil container: self optionIcons:nil backgroundColor: nil ];
        __icon._importable = true;
        __icon._maskIcon = @"theme6/mask";
        [ __icon setLinkToEnd ];
    }
    
    [ __title render: view bPlay: bPlay ];
    [ __subTitle render: view bPlay: bPlay ];
    [ __icon render: view bPlay: bPlay ];
    
    [ Utils circleMaskView: __icon._view ];
    
    if( !bPlay )
        [ view addTarget:self action:@selector(onSectionHeaderClicked:) forControlEvents:UIControlEventTouchUpInside ];
    
    if ( !bPlay )
        [ Utils borderAnimation: view ];
    
    return view;
}

-(void) onSectionHeaderClicked: (id) sender
{
    NSArray * btns = @[ @"Change Color", @"Import Image", @"Remove Bar" ];
    
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
                     
                     if ( index == 0 ) {
                         UIViewController * vc = (UIViewController *)[ self getDelegate ];
                         [ ColorPickerViewController initWithColor: _headerColor controlId: 0 parentVC:vc delegate:self ];
                     } else if ( index == 1 ) {

                         UIViewController * parentVC = (UIViewController *)[ self getDelegate ];
                         UIViewController * vc = [[ PhotoPinchVC alloc ] initWithImage: _headerImage ];
                         
                         UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: vc ];
                         navController.modalPresentationStyle = UIModalPresentationFormSheet;
                         [ parentVC presentViewController:navController animated:TRUE completion:nil ];
                         
                     } else  {
                         _hasHeader = false;
                         [ [ self getDelegate ] onContentRefresh ];
                     }
                 }];
}

-(void) onColorSelected:  (int) color controlId:(int)controlId
{
    NSLog(@"onColorSelected");
    _headerColor = color;
    _headerView.backgroundColor = COLOR_INT(color);
    [ [ CSettings sharedInstance ] saveObject: [NSNumber numberWithInt:color ] key:@"socialHeadColor" ];
}

-(CGFloat) getSectionHeaderHeight: (UITableView *) tableView {
    
    if( _hasHeader )
        return 48;
    return 0;
}

+(CSocialMediaPost *) copyFrom:(CSocialMediaPost *)post
{
    NSData *encodedObject = [ NSKeyedArchiver archivedDataWithRootObject: post ];
    return [ NSKeyedUnarchiver unarchiveObjectWithData: encodedObject ];
}

-(CElement *) copyElement: (CElement *) element
{
    CElement * newObj;
    
    if( [ element isKindOfClass: CText.class ] ) {
        newObj = [[ CText alloc ] init ];
    } else {
        newObj = [[ CImage alloc ] init ];
    }
    
    [ newObj copyFrom: element ];
    newObj._container = self;
    
    return newObj;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];

    [ encoder encodeObject: _headerImage forKey: @"_headerImage" ];
    [ encoder encodeObject: __title forKey: @"_title" ];
    [ encoder encodeObject: __subTitle forKey: @"_subTitle" ];
    [ encoder encodeObject: __icon forKey: @"_icon" ];
    [ encoder encodeObject: __image forKey: @"_image" ];
    [ encoder encodeInt: _headerColor forKey: @"_headerColor" ];
    [ encoder encodeBool: _hasHeader forKey: @"_hasHeader" ];
    [ encoder encodeObject: _comments forKey: @"_comments" ];
    [ encoder encodeObject: __likeLabel forKey: @"_likeLabel" ];
    
    for( int i=0; i < RatingIconsNUMB; i++ ) {

        NSString * sKey = [ NSString stringWithFormat:@"ratingIcon%d", i ];
        [ encoder encodeObject: _ratingIcons[i] forKey: sKey ];
    }
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder:decoder ] )
    {
        _headerImage = [ CElement decodeObject:decoder key:@"_headerImage" container: self ];
        __title = [ CElement decodeObject:decoder key:@"_title" container: self ];
        __subTitle = [ CElement decodeObject:decoder key:@"_subTitle" container: self ];
        __icon = [ CElement decodeObject:decoder key:@"_icon" container: self ];
        __image = [ CElement decodeObject:decoder key:@"_image" container: self ];
        _headerColor = [ decoder decodeIntForKey:@"_headerColor" ];
        _hasHeader = [ decoder decodeBoolForKey:@"_hasHeader" ];
        _comments = [ decoder decodeObjectForKey: @"_comments" ];
        for( CSocialMediaPostComment * comment in _comments ) {
            comment._container = self;
        }
        
        __likeLabel = [ CElement decodeObject:decoder key:@"_likeLabel" container: self ];
        
        for( int i=0; i < RatingIconsNUMB; i++ ) {
            
            NSString * sKey = [ NSString stringWithFormat:@"ratingIcon%d", i ];
            _ratingIcons[i] = [ CElement decodeObject:decoder key:sKey container: self ];
        }
    }
    return self;
}

@end
