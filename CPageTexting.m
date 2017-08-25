#import <AudioToolbox/AudioToolbox.h> 
#import "CPageTexting.h"
#import "Preference.h"
#import "CInputText.h"
#import "CKeyboard.h"
#import "EditTextRowVC.h"
#import "Utils.h"
#import "CSettings.h"

@implementation CPageTexting

@synthesize _recipientIcon,_myIcon,_keyboard,_inputText,_title,_sendBtn;

- (id)initWithTemplate: (NSString *) templateName delegate:(id) delegate params:(NSDictionary *)params
{
    //insertModeTitle:@"Conversation"
	self = [ super initWithTemplate:templateName delegate:delegate params:params ];
                               //icon:@"image1" lineHeight:25 topHeight:44 bottomHeight: 44 leftMargin: 0 rightMargin: 0 textColor:textColor font:font backgroundColor:backgroundColor ];

    self._exitPos = CGPointMake(5,70);
    
    int titleColor = [[ params objectForKey:@"titleColor"] intValue ];
    int inputTextColor = [[ params objectForKey:@"inputTextColor"] intValue ];
    int myTextColor = [[ params objectForKey:@"myTextColor"] intValue ];
    int otherTextColor = [[ params objectForKey:@"otherTextColor"] intValue ];
    int timeTextColor = [[ params objectForKey:@"timeTextColor"] intValue ];
    
    _title = [ [ CText alloc ] initWithText:@"Contact Name" rect: MYRECTI(0, self._topBar._height, 0, 44 ) color:titleColor font: [ params objectForKey:@"titleFont"] container: self ];
    
    _inputText = [[ CInputText alloc ] initWithColor: inputTextColor rect:[ params objectForKey:@"inputRect" ] script:@"" autoEnding: false font:[ params objectForKey:@"font"] container: self ];
    
    UIColor * inputBackColor = [ params objectForKey:@"inputbox_backColor"];
    if ( inputBackColor == nil ) {
        inputBackColor = [ UIColor whiteColor ];
    }
    
    _inputText._backgroundColor = inputBackColor;
    _inputText._borderColor = [ params objectForKey:@"inputbox_borderColor"];
    
    NSNumber * inputBorderCorner = [ params objectForKey:@"inputbox_borderCorner"];
    if ( inputBorderCorner == nil ) {
        inputBorderCorner = [ NSNumber numberWithInt:10 ];
    }
    
    _inputText._borderCorner = inputBorderCorner.intValue;
    _inputText._autoResizeSuperView = true;
    _inputText._editable = false;
    _inputText._hintMessage = [ params objectForKey:@"inputbox_hintMessage"];
    
    NSString * recipientIcon = @"avatar0";
    
    _sendBtn = [[ CImage alloc ] initWithIcon: [self getImageName:@"send"] rect:[ params objectForKey:@"sendRect" ] target:self sel:@selector(onBtnSendClicked:) container:self optionIcons:nil backgroundColor:nil ];
    _sendBtn._editable = false;

    int msgColor = titleColor;
    if ( [ params objectForKey:@"messagesBtnColor" ] )
        msgColor = [[ params objectForKey:@"messagesBtnColor" ] intValue ];
    UIFont * msgFont = [ params objectForKey:@"titleFont"];
    if ( [ params objectForKey:@"messagesFont" ] )
        msgFont = [ params objectForKey:@"messagesFont" ];
    
    __editBtn = [ [ CText alloc ] initWithText:@"Details" rect: [ params objectForKey:@"editRect" ]  color: msgColor font: msgFont container: self ];
    [__editBtn setLinkToEnd ];

    __messagesBtn = [ [ CText alloc ] initWithText:@"Messages" rect: [ params objectForKey:@"messagesRect" ]  color: msgColor font: msgFont container: self ];
    [__messagesBtn setLinkToEnd ];
    
    [ self createImageButtonInView:_title._view imageName:@"edit" rectName:@"editRect" ];
    
    int kh = [ Utils getScreenSize ].width / 1242 * 680;    /// 750 * 504;
    _keyboard = [[ CKeyboard alloc ] initWithBackground:[self getImageNameWithThemem:@"keyboard"] rect:MYRECTI(0,-kh,0,kh) backKeyRect: MYRECTI(-54, 107, 50, 50) target:self sel:@selector(onKeyboardClicked:) container: self ];
    
    BOOL showAtBegining = ![ CSettings sharedInstance ]._messageHideAtStart;
    
    CTextRow * tr = [[ CTextRow alloc ] initWithMode: TEXTROW_TEXTING direction:CONVERSATION_TIME name:nil title:nil body:@"Sat, Apr 7, 11:11AM" time:nil icon:recipientIcon color:timeTextColor color2:timeTextColor font:MYFONT(13) showAtBegining:showAtBegining  container: self ];
     
     [ self._textRows addObject: tr ];

    tr = [[ CTextRow alloc ] initWithMode: TEXTROW_TEXTING direction:CONVERSATION_MINE name:nil title:nil body:@"Hello" time:nil icon:recipientIcon color:myTextColor color2:timeTextColor font:MYFONT(16) showAtBegining:showAtBegining container: self ];
    
    [ self._textRows addObject: tr ];
    
     tr = [[ CTextRow alloc ] initWithMode: TEXTROW_TEXTING direction:CONVERSATION_OTHERS name:@"John Ling" title:nil body:@"Hi there" time:nil icon:recipientIcon color:otherTextColor color2:timeTextColor font:MYFONT(16) showAtBegining:showAtBegining container: self ];
     
     [ self._textRows addObject: tr ];
    
    _myInputIndex = -1;
    
    [ CSettings sharedInstance ]._messageHideAtStart = false;
    
	return self;
}

-(CTextRow *) getRowAtIndex:(int) section  index: (int) index
{
    CTextRow * row = [ super getRowAtIndex: section index: index ];
    
    if( row._direction == CONVERSATION_OTHERS )
        row._color = [[ self._params objectForKey:@"otherTextColor"] intValue ];
    else if ( row._direction == CONVERSATION_MINE )
        row._color = [[ self._params objectForKey:@"myTextColor"] intValue ];
    else
        row._color = [[ self._params objectForKey:@"timeTextColor"] intValue ];
    
    return row;
}

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    self._hideBottomBar = true;
    _keyboard._hidden = true;
    
    UIView * mainV = [ super render: parentView bPlay: bPlay ];
    [ _title render: mainV bPlay: bPlay ];
    self._tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImage * bottomBarImg = [ Utils loadImage:@"bottom_bar" templateName: self._templateName ] ;
    _bottomBar = [[ UIImageView alloc ] initWithImage: bottomBarImg ];
    _bottomBar.frame = CGRectMake(0, mainV.bounds.size.height-bottomBarImg.size.height/2,mainV.bounds.size.width, bottomBarImg.size.height/2 );
    _bottomBar.userInteractionEnabled = true;
    
    UIButton * img1 = [ self createImageButtonInView:_bottomBar imageName:@"camera" rectName:@"cameraRect" ];
    img1.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;

    
    if ( [[ self._params objectForKey:@"isImageTopBarButton"] intValue ] > 0 )
    {
        [ self createImageButtonInView:_title._view imageName:@"edit" rectName:@"editRect" ];
        [ self createImageButtonInView:_title._view imageName:@"messages" rectName:@"messagesRect" ];
    } else {
        [__editBtn render: _title._view bPlay: bPlay ];
        [__messagesBtn render: _title._view bPlay: bPlay ];
    }
    
    UIButton * btn = (UIButton *)[ _sendBtn render: _bottomBar bPlay: bPlay ];
    [ btn removeTarget:nil action:nil forControlEvents: UIControlEventTouchUpInside ];
    [ btn addTarget:self action:@selector(onBtnSendClicked:) forControlEvents:UIControlEventTouchUpInside ];
    
    btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    [ _inputText render: _bottomBar bPlay:bPlay ];
    [ mainV addSubview: _bottomBar ];
    
    if( !_keyboard._hidden )
        [ _keyboard render: mainV bPlay: bPlay ];
    _keyboard._focus = _inputText;
    
    return mainV;
}

-(void) hideKeyboard:(id) noti
{
    NSLog(@"hideKeyboard");
    [ _keyboard slideOut: self._view pushTableView: self._tableView pushView: _bottomBar ];
}

-(int) getMyScriptIndex
{
    for(int i=0; i < self._textRows.count; i++ )
    {
        CTextRow * row = self._textRows[i];
        if( row._direction == CONVERSATION_MINE && row._hidden )
            return i;
    }
    return -1;
}

-(void) onBtnSendClicked: (id) sender
{
    if( _myInputIndex < 0 )
        return;
    
    [ self onMemberEndFocus: _inputText ];
    [ self onMemberGetFocus: _inputText ];
}

-(void) onMemberGetFocus: (CInputText *) input
{
    if( [ self._delegate isEditing ] )
        return;
    
    _myInputIndex = [ self getMyScriptIndex ];
    if( _myInputIndex >= 0 )
    {
        CTextRow * row = self._textRows[_myInputIndex];
        input._script = row._body;
    }
    if( _keyboard._hidden )
        [ _keyboard slideIn: self._view pushTableView: self._tableView pushView: _bottomBar ];
    else
        [ _keyboard onFocus ];
    
    [ self._tableView becomeFirstResponder ];
}

-(void) onMemberEndFocus:(CInputText *) input
{
    [ input updateScript: @"" ];
    
    if ( _myInputIndex >=0 && _myInputIndex < self._textRows.count )
    {
        CTextRow * row = self._textRows[_myInputIndex];
        [ self renderRow: row ];
    }
}

-(void) playEnd
{
    [ super playEnd ];
    [ self onMemberEndFocus: _inputText ];
}

-(void) onKeyboardClicked: (id) sender
{
    //[ self onOptionClicked: 0 ];
}

-(BOOL) onKeyAction: (bool) bBackword {
    
    if( bBackword && _lastAnimatedRow < 0 )
        return false;
    
    if ( bBackword ) {
        [ self rollbackRows ];
        
        if( _lastAnimatedRow >= 0 ) {
            CTextRow * row = [ self._textRows objectAtIndex: _lastAnimatedRow ];
            if ( row._direction == CONVERSATION_MINE )
                [ self onMemberGetFocus: _inputText ];
        }
    }
    else
        [ self checkNextRow: false ];
    
    return true;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];
    
    [ encoder encodeObject: _keyboard forKey: @"keyboard" ];
    [ encoder encodeObject: _inputText forKey: @"inputText" ];
    [ encoder encodeObject: _title forKey: @"title" ];
    [ encoder encodeObject: _sendBtn forKey: @"sendBtn" ];
    [ encoder encodeObject: __messagesBtn forKey: @"messageBtn" ];
    [ encoder encodeObject: __editBtn forKey: @"editBtn" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder: decoder ] )
	{
		_keyboard = [ CElement decodeObject:decoder key:@"keyboard" container:self ];
		_inputText = [ CElement decodeObject:decoder key:@"inputText" container:self ];
		_title = [ CElement decodeObject:decoder key:@"title" container:self ];
		_sendBtn = [ CElement decodeObject:decoder key:@"sendBtn" container:self ];
        __messagesBtn = [ CElement decodeObject:decoder key:@"messageBtn" container:self ];
        __editBtn = [ CElement decodeObject:decoder key:@"editBtn" container:self ];
    }
    return self;
}

@end
