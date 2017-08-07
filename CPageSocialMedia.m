#import <AudioToolbox/AudioToolbox.h> 
#import "CPageSocialMedia.h"
#import "Preference.h"
#import "CTextRow.h"
#import "utils.h"
#import "EditTextRowVC.h"
#import "CScene.h"
#import "CSocialMediaPost.h"

@implementation CPageSocialMedia

- (id)initWithTemplate: (NSString *) templateName delegate:(id) delegate params: (NSDictionary *) params
{
	self = [ super initWithTemplate: templateName delegate: delegate params:params ];
    __postObjects = [[ NSMutableArray alloc ] init ];
    _delegate = delegate;
    
    __titleBar = [[ CImage alloc ] initWithIcon: [self getImageName:@"titleBar"] rect: MYRECTI(0,0,0,44)  target:nil sel:nil container: self optionIcons: nil backgroundColor: 0x000000 ];
    __titleBar._preferPureColor = true;
    __titleBar._needImportInstruction = true;
    __titleBar._removeable = true;
    
    self._topBar._background = [ params objectForKey:@"topBarBackground" ];
    self._topBar._color = [ params objectForKey:@"topBarColor" ];
    
    __bottomBar = [[ CImage alloc ] initWithIcon: [self getImageName:@"bottomBar"] rect:MYRECTI(0,-44,0,44) target:nil sel:nil container: self optionIcons: nil backgroundColor: 0x000000 ];
    __bottomBar._preferPureColor = true;
    __bottomBar._needImportInstruction = true;
    
    [ self setupBottomIcons ];
    
    __titler = [[ CText alloc ] initWithText:@"My Title" rect:MYRECTI(60,0,-120,44) color:0xffffff font:BOLDFONT(16) container:self ];
    
    __postObjects = [[ NSMutableArray alloc ] init ];
    
    [ __postObjects addObject: [self getDefaultRow ] ];
    
	return self;
}

-(void) setupBottomIcons
{
    NSString * sIconNames[BottomIconsNUMB] = { @"home", @"like", @"search", @"camera", @"share" };
    int y = __bottomBar._rect._posY + 2;
    
    for( int i=0; i < BottomIconsNUMB; i++ ) {
        
        NSString * name = [ NSString stringWithFormat: @"social/%@", sIconNames[i] ];
        _bottomIcons[i] = [[ CImage alloc ] initWithIcon: name rect: MYRECTI(0,y,40,40) target:nil sel:nil container: self optionIcons:nil backgroundColor: nil ];
        _bottomIcons[i]._removeable = true;
        _bottomIcons[i]._importable = true;
        _bottomIcons[i]._needImportInstruction = true;
        
        [ _bottomIcons[i] setLinkToEnd ];
    }
    [ self updateBottomIconPos ];
}

-(void) updateBottomIconPos
{
    float x = 16;
    float w = [ Utils getScreenSize ].width;
    w = w / BottomIconsNUMB;
    
    for( int i=0; i < BottomIconsNUMB; i++ ) {
        
        if ( _bottomIcons[i] != nil )
        {
            _bottomIcons[i]._rect._posX = x;
            x += w;
        }
    }
}

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    int top = self._topBar._hidden? 0: self._topBar._height;
    
    __titleBar._rect._posY = top;
    
    top += __titleBar._rect._height;
    
    int bottom = __bottomBar._rect._height;
    
    UIView * mainV = [ super render: parentView bPlay: bPlay ];

    [ __titleBar render: mainV bPlay:bPlay ];
    [ __titler render: __titleBar._view bPlay:bPlay ];
    [ __bottomBar render: mainV bPlay:bPlay ];
    
    for( int i=0; i < BottomIconsNUMB; i++ ) {
        [ _bottomIcons[i] render: mainV bPlay: bPlay ];
    }
    
    CGRect frame = CGRectMake( 0, top, mainV.frame.size.width, mainV.frame.size.height - top - bottom );
    
    __tableView = [[ UITableView alloc ] initWithFrame:frame ];
    __tableView.delegate = self;
    __tableView.dataSource = self;
    __tableView.userInteractionEnabled = true;
    
    [ mainV addSubview: __tableView ];
    
    if ( !bPlay )
        [ self setupFooterView: __tableView ];
    
    return mainV;
}

-(CSocialMediaPost *) getDefaultRow
{
    int textColor = [[ self._params objectForKey:@"textColor" ] intValue ];
    int timeColor = textColor;
    
    if( [ self._params objectForKey:@"timeColor" ] != nil )
        timeColor = [[ self._params objectForKey:@"timeColor" ] intValue ];
    
    CSocialMediaPost * post = [[ CSocialMediaPost alloc ] initWithTarget:self sel: @selector(onPostClicked:) container: self ];
    
    return post;
}

-(void)onOptionClicked: (int) optionID
{
    [ __postObjects addObject: [self getDefaultRow ] ];
    [ __tableView reloadData ];
    
   /* UIViewController * vc = [ EditTextRowVC initWithTextRow: _textRows index: (int)_textRows.count-1 parentView: _tableView title: [ self._params objectForKey:@"insertModeTitle"] ];
    [ self._delegate popupVC: vc ]; */
}

-(void) setupFooterView: (UITableView *) tableView
{
    int fullW = tableView.frame.size.width;
    
    UIView * view = [[ UIView alloc ] initWithFrame:CGRectMake(0,0, fullW, 240 ) ];
    
    UIView * label = [ Utils createClickableLabel:@"Add a new section" frame:CGRectMake(0,0,fullW, 35 ) color:[UIColor blueColor ] font: MYFONT(14) target:self sel:@selector(onAddPostClicked:) labelTag:0 ];
    [ view addSubview: label ];
    
    label = [ Utils createClickableLabel:@"Remove the last section" frame:CGRectMake(0,35,fullW, 35 ) color:[UIColor blueColor ] font: MYFONT(14) target:self sel:@selector(onAddPostClicked:) labelTag:0 ];
    [ view addSubview: label ];
    
    [ Utils setupSingleTapHandler: label target:self sel:@selector(onRemoveSectionClicked:) ];
    
    [ Utils createLabelInView:view text:@"Top menu" frame: CGRectMake(10,80,100,30) color:[UIColor blackColor ] font: MYFONT(14) ];
    
    UISwitch * sw = [[ UISwitch alloc ] initWithFrame:CGRectMake(fullW-60,80,60,30) ];
    sw.on = !self._topBar._hidden;
    [sw addTarget: self action: @selector(onTopMenuSwitch:) forControlEvents: UIControlEventValueChanged ];
    [ view addSubview: sw ];
    
    [ tableView setTableFooterView: view ];
}

-(void) onPostClicked:( id) sender
{
}

-(void) onTopMenuSwitch: (UISwitch *) sw {
    
    self._topBar._hidden = !self._topBar._hidden;
    [ self._delegate onContentRefresh ];
}

-(void) onRemoveSectionClicked: (id) sender
{
    [ __postObjects removeLastObject ];
    [ __tableView reloadData ];
}

-(bool) onMemberRemoved:(CElement *)obj
{
    NSLog(@"onMemberRemoved");
    
    if( obj == __titleBar )
    {
        [__titleBar._view removeFromSuperview ];
        __titleBar = nil;
    }
    [ self._delegate onContentRefresh ];
    
    return true;
}

-(void) onAddPostClicked: (id) sender
{
    [ self onOptionClicked: 0 ];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];

    [ encoder encodeObject: __postObjects forKey: @"_postObjects" ];
    [ encoder encodeObject: __titleBar forKey: @"_titleBar" ];
    [ encoder encodeObject: __titler forKey: @"_title" ];
    [ encoder encodeObject: __bottomBar forKey: @"_bottomBar" ];
    
    for( int i=0; i < BottomIconsNUMB; i++ ) {
        
        NSString * sKey = [ NSString stringWithFormat:@"ratingIcon%d", i ];
        [ encoder encodeObject: _bottomIcons[i] forKey: sKey ];
    }
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder: decoder ] )
	{
		__postObjects = [ decoder decodeObjectForKey: @"_postObjects" ];
        for( CSocialMediaPost * post in __postObjects ) {
            post._container = self;
        }
        __titleBar = [ CElement decodeObject:decoder key:@"_titleBar" container:self ];
        __titler = [ CElement decodeObject:decoder key:@"_title" container:self ];
        __bottomBar = [ CElement decodeObject:decoder key:@"_bottomBar" container:self ];
        
        for( int i=0; i < BottomIconsNUMB; i++ ) {
            
            NSString * sKey = [ NSString stringWithFormat:@"ratingIcon%d", i ];
            _bottomIcons[i] = [ CElement decodeObject:decoder key:sKey container: self ];
        }
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return __postObjects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSocialMediaPost * obj = __postObjects[indexPath.section];
    return [ obj render: tableView  bPlay: ![ self._delegate isEditing ] ];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CSocialMediaPost * obj = __postObjects[indexPath.section];
    return [ obj getContentHeight: tableView ];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CSocialMediaPost * obj = __postObjects[section];
    return [ obj getSectionHeaderHeight: tableView ];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CSocialMediaPost * obj = __postObjects[section];
    return [ obj getSectionHeaderView: tableView ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
