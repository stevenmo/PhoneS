#import <AudioToolbox/AudioToolbox.h> 
#import "CPageSocialMedia.h"
#import "Preference.h"
#import "CTextRow.h"
#import "utils.h"
#import "EditTextRowVC.h"
#import "CScene.h"
#import "CSocialMediaPost.h"
#import "ImageUtil.h"

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
        //_bottomIcons[i]._removeable = true;
        _bottomIcons[i]._importable = true;
        _bottomIcons[i]._needImportInstruction = true;
        
        [ _bottomIcons[i] setLinkToEnd ];
    }
    [ self updateBottomIconPos ];
}

-(void) updateBottomIconPos
{
    float w = [ Utils getScreenSize ].width;
    int gap = ( w - BottomIconsNUMB * 40 ) / BottomIconsNUMB;
    w = gap + 40;
    int x = gap/2;
    
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
    _cells = [[ NSMutableArray alloc ] init ];
    
    int top = self._topBar._hidden? 0: self._topBar._height;
    __titleBar._rect._posY = top;
    
    top += __titleBar._rect._height;
    
    int bottom = __bottomBar._rect._height;
    
    UIView * mainV = [ super render: parentView bPlay: bPlay ];

    [ __titleBar render: mainV bPlay:bPlay ];
    [ __titler render: __titleBar._view bPlay:bPlay ];
    
    [ __bottomBar render: mainV bPlay:bPlay ];
    
    [ self updateBottomIconPos ];
    
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
    else
        [ self prepareCells ];
    
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
    
    UIView * label = [ Utils createClickableLabel:@"Add a new section" frame:CGRectMake(0,0,fullW, 30 ) color:[UIColor blueColor ] font: MYFONT(14) target:self sel:@selector(onAddPostClicked:) labelTag:0 ];
    [ view addSubview: label ];

    label = [ Utils createClickableLabel:@"Duplicate last section" frame:CGRectMake(0,30,fullW, 30 ) color:[UIColor blueColor ] font: MYFONT(14) target:self sel:@selector(onDuplicateSectionClicked:) labelTag:0 ];
    [ view addSubview: label ];
    
    label = [ Utils createClickableLabel:@"Remove the last section" frame:CGRectMake(0,60,fullW, 30 ) color:[UIColor blueColor ] font: MYFONT(14) target:self sel:@selector(onRemoveSectionClicked:) labelTag:0 ];
    [ view addSubview: label ];
    
    [ Utils createLabelInView:view text:@"Top menu" frame: CGRectMake(10,110,100,30) color:[UIColor blackColor ] font: MYFONT(14) ];
    
    UISwitch * sw = [[ UISwitch alloc ] initWithFrame:CGRectMake(fullW-60,110,60,30) ];
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

-(void) onDuplicateSectionClicked: (id) sender
{
    if( __postObjects.count > 0 )
    {
        CSocialMediaPost * post = [ CSocialMediaPost copyFrom: __postObjects.lastObject ];
        post._container = self;
        [__postObjects addObject: post ];
        [ __tableView reloadData ];
    }
}

-(void) onRemoveSectionClicked: (id) sender
{
    [ __postObjects removeLastObject ];
    [ __tableView reloadData ];
}

-(BOOL) removeBottomIcon: (CElement *)obj
{
    for( int i=0; i < BottomIconsNUMB; i++ ) {
        if ( obj == _bottomIcons[i] ) {
            [ (CImage *)obj remove ];
            return true;
        }
    }
    return false;
}

-(bool) onMemberRemoved:(CElement *)obj
{
    NSLog(@"onMemberRemoved");
    
    if( obj == __titleBar )
    {
        [__titleBar._view removeFromSuperview ];
        __titleBar = nil;
    } //else
      //  [ self removeBottomIcon: obj ];
        
    [ self._delegate onContentRefresh ];
    
    return true;
}

-(void) onAddPostClicked: (id) sender
{
    [ self onOptionClicked: 0 ];
}

-(UIImage *) captureScreenshot: ( UIView *) mainView fileName: (NSString *) fileName {
    
    UIView * view = [ self render: mainView bPlay: true ];
    CGFloat totalH = __tableView.contentSize.height;
    CGFloat h = view.frame.size.height;
    CGFloat hNow = h;
    UIImage * imgTop, *imgBottom;
    
    int topBarHeight = self._topBar._hidden? 0: self._topBar._height;
    topBarHeight += __titleBar._rect._height;
    
    NSString *sPath = [ fileName stringByDeletingPathExtension ];
    int index = 0;
    
    for ( CGFloat yy = 0; yy < totalH;  )
    {
        if ( yy > 0 )
            __tableView.contentOffset = CGPointMake( 0, yy - topBarHeight - 44 );
        
        UIImage * img = [ Utils captureView: view ];
        
        if ( yy > 0 )
        {
            hNow = h - topBarHeight - 44 - 44;
            img = [ Utils cropImage:img cropRect: CGRectMake(0,topBarHeight+44,img.size.width,hNow ) ];
        } else {
            hNow = h - 44 - 44;
            imgTop = [ Utils cropImage:img cropRect: CGRectMake(0,0,img.size.width,topBarHeight ) ];
            imgBottom = [ Utils cropImage:img cropRect: CGRectMake(0,h-44,img.size.width,44 ) ];
            img = [ Utils cropImage:img cropRect: CGRectMake(0,0,img.size.width,hNow ) ];
        }

        CGSize newImageSize;
        
        if ( yy == 0 )
        {
            newImageSize = CGSizeMake( img.size.width, totalH + topBarHeight + 44 );
            //UIGraphicsBeginImageContextWithOptions(newImageSize, NO, 0 );
        }
        else
            yy = yy;
        
        //[img drawAtPoint:CGPointMake(0,yy)];
        NSString *sName = [ NSString stringWithFormat:@"%@_%d.jpg", sPath, index ];
        [ Utils saveJPGImage:img fileName: sName ];
        yy += hNow;
        index++;
    }
    
    [ view removeFromSuperview ];

    [imgBottom drawAtPoint:CGPointMake(0,totalH + topBarHeight)];
    
    //UIImage *imgFull = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    //[ Utils saveJPGImage:imgFull fileName: fileName ];
    
    if ( imgTop != nil ) {
        
        NSString *sPath = [ fileName stringByDeletingPathExtension ];
        NSString *sName = [ NSString stringWithFormat:@"%@_top.jpg", sPath ];
        [ Utils saveJPGImage:imgTop fileName: sName ];
        sName = [ NSString stringWithFormat:@"%@_bottom.jpg", sPath ];
        [ Utils saveJPGImage:imgBottom fileName: sName ];
    }
    return nil;
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

-(void) prepareCells
{
    for( int i= 0; i < __postObjects.count ; i++ )
    {
        CSocialMediaPost * obj = __postObjects[i];
        [ _cells addObject: [ obj render: __tableView  bPlay: true ] ];
    }
}

-(void) playEnd
{
    [ super playEnd ];
    _cells = nil;
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
    if ( indexPath.section < _cells.count )
        return _cells[indexPath.section];
    else {
        CSocialMediaPost * obj = __postObjects[indexPath.section];
        return [ obj render: tableView  bPlay: ![ self._delegate isEditing ] ];
    }
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
