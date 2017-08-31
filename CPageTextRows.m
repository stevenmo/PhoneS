#import <AudioToolbox/AudioToolbox.h> 
#import "CPageTextRows.h"
#import "Preference.h"
#import "CTextRow.h"
#import "utils.h"
#import "EditTextRowVC.h"
#import "CScene.h"

@implementation CPageTextRows

@synthesize _textRows,_tableView;

- (id)initWithTemplate: (NSString *) templateName delegate:(id) delegate params: (NSDictionary *) params
{
	self = [ super initWithTemplate: templateName delegate: delegate params:params ];
    _textRows = [[ NSMutableArray alloc ] init ];
    _mode = [[ params objectForKey:@"mode" ] intValue ];
    _delegate = delegate;
    
    _bottomHeight = [ [ params objectForKey: @"bottomHeight" ] intValue ];
    _topHeight = [ [ params objectForKey: @"topHeight" ] intValue ];
    _leftMargin = [ [ params objectForKey: @"leftMargin" ] intValue ];
    _rightMargin = [ [ params objectForKey: @"rightMargin" ] intValue ];
    _icon = [ params objectForKey: @"icon" ];
    
    _linkElement = [ self getDefaultRow ];
    _linkElement._linkPage = PAGE_END_LINK;
    
	return self;
}

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    UIView * mainV = [ super render: parentView bPlay: bPlay ];
    
    if( bPlay )
    {
        [ self getInsertDirection ];
    }
    
    CGRect frame = CGRectMake( _leftMargin, self._topBar._height + _topHeight, mainV.frame.size.width-_leftMargin-_rightMargin, mainV.frame.size.height - self._topBar._height - _bottomHeight -_topHeight );
    
    _tableView = [[ UITableView alloc ] initWithFrame: frame ];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.userInteractionEnabled = true;
    
    NSString * sBackImage = [ self._params objectForKey:@"tableBackground" ];
    if( sBackImage )
    {
        UIImage * img = [ Utils loadImage: sBackImage templateName: self._templateName ];
        _tableView.backgroundView = [[ UIImageView alloc ] initWithImage:  img ];
    }else
        _tableView.backgroundView = nil;
    

    
    
    UIColor * bkColor = [ self._params objectForKey:@"backgroundColor" ];
    if( bkColor == nil )
        bkColor = [UIColor clearColor];
    _tableView.backgroundColor = bkColor;
    
    [ self setupBackgroundClickHandler: _tableView bPlay: bPlay ];

    [ self setupKeyboardDimissHandler ];
    
    [ Utils addFooter: _tableView ];
    
    [ mainV addSubview: _tableView ];
    
    if( !__hideBottomBar && _bottomHeight > 0 )
    {
        CRect * r = MYRECTI(0, - _bottomHeight, 0, _bottomHeight );
        [ self createImageButtonInView: mainV imageName:@"bottom_bar" rect: r target:nil sel:nil ];
    }
    [ self initRows: bPlay ];
    
    return mainV;
}

-(void) setupKeyboardDimissHandler
{
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    gesture.direction = UISwipeGestureRecognizerDirectionDown;
    gesture.delegate = self;
    [ _tableView addGestureRecognizer: gesture ];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer     shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void) hideKeyboard:(id) noti
{
    NSLog(@"hideKeyboard");
}

-(CTextRow *) getDefaultRow
{
    int textColor = [[ self._params objectForKey:@"textColor" ] intValue ];
    int timeColor = textColor;
    
    if( [ self._params objectForKey:@"timeColor" ] != nil )
        timeColor = [[ self._params objectForKey:@"timeColor" ] intValue ];
    
    CTextRow * textRow = [[ CTextRow alloc ] initWithMode: _mode direction:0 name:@"" title:@"" body:@"" time:@"" icon:@"avatar0" color:textColor color2: timeColor font:MYFONT(16) showAtBegining: true container: self ];
    
    return textRow;
}

-(NSArray *) getExitItems
{
    return [ NSArray arrayWithObject: _linkElement ];
}

-(void)onOptionClicked: (int) optionID
{
    [ _textRows addObject: [self getDefaultRow ] ];
    
    UIViewController * vc = [ EditTextRowVC initWithTextRow: _textRows index: (int)_textRows.count-1 parentView: _tableView title: [ self._params objectForKey:@"insertModeTitle"] ];
    [ self._delegate popupVC: vc ];
}

-(void) initRows: (bool) bPlay
{
    int total = (int)_textRows.count;
    bool bFoundHidden = false;
    
    _lastAnimatedRow = -1;
    
    for( int i=0 ; i < total ; i++ )
    {
        CTextRow * row;
        
        if( _insertFromTop )
            row = [ _textRows objectAtIndex: total - 1 - i ];
        else
            row = [ _textRows objectAtIndex: i ];

        if( bPlay )
        {
            if( !bFoundHidden && row._showingAtBegining )
                row._hidden = false;
            else
            {
                bFoundHidden = true;
                row._hidden = true;
            }
        }else
            row._hidden = false;
    }
    if( bPlay )
        [ self checkNextRow: true ];
}

-(void) setupTimer: (CTextRow *) row
{
    [ _timer invalidate ];
    _timer = [ NSTimer scheduledTimerWithTimeInterval: row._showingDelay target:self selector:@selector(onTimerCome:) userInfo:row repeats:NO ];
}

-(int) getRenderedRows: (int) section
{
    int total = (int)_textRows.count;
    if( [ self._delegate isEditing ] )
        return total;
    
    int i = 0;
    for( ; i < total ; i++ )
    {
        CTextRow * row;
        
        if( _insertFromTop )
            row = [ _textRows objectAtIndex: total - 1 - i ];
        else
            row = [ _textRows objectAtIndex: i ];
        
        if( !row._hidden )
            continue;
        else
            break;
    }
    return i;
}

-(void) getInsertDirection
{
    _insertFromTop = false;
    if ( _textRows.count >= 2 )
    {
        CTextRow * row1 = [_textRows objectAtIndex: 0 ];
        CTextRow * row2 = [_textRows objectAtIndex: _textRows.count - 1 ];
        if( !row1._showingAtBegining && row1._showingDelay > row2._showingDelay )
            _insertFromTop = true;
    }
}

-(CTextRow *) getRowAtIndex:(int) section  index: (int) index
{
    if( _insertFromTop )
    {
        int n = [ self getRenderedRows: section ];
        int delta = (int)_textRows.count - n;
        return [ _textRows objectAtIndex: delta + index ];
    }
    return [ _textRows objectAtIndex: index ];
}

-(void) checkNextRow: (BOOL) bFirstTime
{
    int total = (int)_textRows.count;
    for( int i=0; i < total; i++ )
    {
        int index = _insertFromTop? total - i - 1: i;
        CTextRow * row = [ _textRows objectAtIndex: index ];
        
        if( !row._hidden )
            continue;
        if( row._direction == CONVERSATION_MINE )
            break;
        
        _lastAnimatedRow = i;
        if ( !bFirstTime )
            [ self renderRow: row ];
        //[ self setupTimer: row ];    IOS10
        break;
    }
}

-(void) rollbackRows {
    
    if( _lastAnimatedRow >= 0 ) {
        
        if ( _lastAnimatedRow < _textRows.count ) {

            CTextRow * row = [ _textRows objectAtIndex: _lastAnimatedRow ];
            row._hidden = true;
            [ _tableView reloadData ];
        }
        _lastAnimatedRow--;
    }
}

-(void) onTimerCome: (NSTimer *)timer
{
    CTextRow * row = [ timer userInfo ];
    [ self renderRow: row ];
}

-(void) renderRow: (CTextRow *) row
{
    row._hidden = false;

    [ _tableView reloadData ];
    
    [ _tableView beginUpdates ];
    {
        int index = _insertFromTop? 0: [ self getRenderedRows: 0 ] - 1;
        if ( index >= 0 ) {
            NSIndexPath * ip = [ NSIndexPath indexPathForRow: index inSection: 0 ];
            
            int ani = _insertFromTop? UITableViewScrollPositionTop: UITableViewScrollPositionBottom;
            [ _tableView scrollToRowAtIndexPath: ip atScrollPosition: ani animated: TRUE ];
            
            ani = _insertFromTop? UITableViewRowAnimationTop: UITableViewRowAnimationLeft;
            [ _tableView reloadRowsAtIndexPaths: @[ip] withRowAnimation: ani ];
        }
    }
    [ _tableView endUpdates ];
    
    [ self checkNextRow : true ];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];

    [ encoder encodeObject: _textRows forKey: @"_textRows" ];
    [ encoder encodeInt: _mode forKey: @"_mode" ];
    [ encoder encodeInt: _bottomHeight forKey: @"_bottomHeight" ];
    [ encoder encodeInt: _topHeight forKey: @"_topHeight" ];
    [ encoder encodeInt: _leftMargin forKey: @"_leftMargin" ];
    [ encoder encodeInt: _rightMargin forKey: @"_rightMargin" ];
    [ encoder encodeObject: _icon forKey: @"_icon" ];
    [ encoder encodeObject: _linkElement forKey: @"_linkElement" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder: decoder ] )
	{
		_textRows = [ decoder decodeObjectForKey: @"_textRows" ];
        for( CElement * e in _textRows )
            e._container = self;
        
		_mode = [ decoder decodeIntForKey: @"_mode" ];
		_bottomHeight = [ decoder decodeIntForKey: @"_bottomHeight" ];
		_topHeight = [ decoder decodeIntForKey: @"_topHeight" ];
		_leftMargin = [ decoder decodeIntForKey: @"_leftMargin" ];
		_rightMargin = [ decoder decodeIntForKey: @"_rightMargin" ];
		_icon = [ decoder decodeObjectForKey: @"_icon" ];
        _linkElement = [ CElement decodeObject:decoder key:@"_linkElement" container:self ];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ self getRenderedRows: (int)section ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTextRow * tr = [ self getRowAtIndex: (int)indexPath.section index: (int)indexPath.row ];
    
    UITableViewCell * cell = [ tr render: tableView bPlay: ![ self._delegate isEditing ] ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIColor * clr = [ self._params objectForKey:@"dividerColor" ];
    if( clr )
    {
        int height = [ tr getHeight: tableView.frame.size.width ];
        [ Utils addLineH: cell color: clr posY: height - 1 ];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    if ( [cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)] )
        [cell setPreservesSuperviewLayoutMargins:NO];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTextRow * tr = [ self getRowAtIndex: (int)indexPath.section index: (int)indexPath.row ];
    return [ tr getHeight: tableView.frame.size.width ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( ![ self._delegate isEditing ] )
    {
        [ self._delegate onLinkClicked: _linkElement._linkPage sender: self ];
    }else{
        UIViewController * vc = [ EditTextRowVC initWithTextRow: _textRows index: (int)indexPath.row parentView: _tableView title:[ self._params objectForKey:@"insertModeTitle"] ];
        
        [ self._delegate onElementClicked: _linkElement  param:vc ];
    }
}
-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    [super setBackgroundImage:backgroundImage];
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:backgroundImage];
    [_tableView setBackgroundColor:UIColor.clearColor];
    [_tableView setBackgroundView:bg];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view != _tableView )
        return NO;
    
    return YES;
}


@end
