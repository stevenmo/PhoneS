#import "TemplateManager.h"
#import "Preference.h"
#import "CSceneTemplate.h"
#import "CPageIncomingCall.h"
#import "CPageIncomingMail.h"
#import "CPageCalling.h"
#import "CPageOutgoingCall.h"
#import "CPageComposeEMail.h"
#import "CSceneIncomingCall.h"
#import "CPageTexting.h"
#import "CSceneCamera.h"
#import "CSceneIncomingMail.h"
#import "CTextRow.h"
#import "CDialog.h"
#import "CPageAlert.h"
#import "CPageChromeKey.h"
#import "CPageVideoPlayer.h"
#import "CPageContacts.h"
#import "CPageContactDetail.h"
#import "CPageCustom.h"
#import "CPageMailBox.h"
#import "CPageHome.h"
#import "CPageScanner.h"
#import "CPageKeypad.h"
#import "CPageFavorites.h"
#import "CPageScrolling.h"
#import "CPageSocialMedia.h"
#import "Utils.h"
#import "CPageCamera.h"
#import "CPageFaceTime.h"
#import "CPageGallery.h"
#import "CPageLocker.h"

#define MYINT(a)  [ NSNumber numberWithInt: a ]
#define THEME_NUMB    8

@implementation TemplateManager

@synthesize _groups,_groupNames;

static TemplateManager * m_instance;

+(TemplateManager *)sharedInstance
{
    if( m_instance == nil )
        m_instance = [ [ TemplateManager alloc ] init ];
    return m_instance;
}

-(id) init
{
    self = [ super init ];
    
    _groups = [[ NSMutableArray alloc ] init ];
    _groupNames = [[ NSMutableArray alloc ] init ];

    _templates = [[Templates alloc ] init ];
    
    [ self initTemplates ];
    return self;
}

-(CPage *) createPageByTemplate2: (NSString *) templateId delegate:(id) delegate {

    NSString * model = [ Utils getDeviceModel ];
    NSDictionary * dic = _templates._dic[templateId][model];
    if( dic == nil ) {
        dic = _templates._dic[templateId][@"iPhone6"];
    }
    
    CPage * page;
    
    if ( [ templateId containsString:@"alert" ] ) {
        
        CDialog * dialog = [[ CDialog alloc ] initWithTemplate: templateId container:nil params: dic ];
        page = [[ CPageAlert alloc ] initWithTemplate:templateId delegate:delegate alert:dialog flashFreq: 0.0 params: dic ];
        page._topBar._hidden = true;
    } else
        page = [ (CPage *)[NSClassFromString( dic[@"className"] ) alloc] initWithTemplate:templateId delegate:delegate params: dic ];
    
    return page;
}

-(CPage *) createPageByTemplate: (NSString *) templateId delegate:(id) delegate
{
    return [ self createPageByTemplate2:templateId delegate:delegate ];
    
    CPage * page = nil;
    NSDictionary * dic;
    
    if( [ templateId hasPrefix: @"incoming_call" ] )
    {
        if( [ templateId isEqualToString: @"incoming_call1" ] )
        {
            if ( [ Utils isIPad ] )
                dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYRECT(95, 58.5, 130, 130),@"callerImageRect",
                                  CENTER_RECT(0, -18, 240, 60 ), @"callerRect",
                                  CENTER_RECT(0, 30, 120, 30 ), @"callerSecondRect",
                                  MYRECT(-160, -116, 140, 60 ),@"acceptBtnRect",
                                  MYRECT(20, -116, 140, 60 ),@"declineBtnRect",
                                  MYRECT(-160, -180, 140, 60 ),@"remindRect",
                                  MYRECT(20, -180, 140, 60 ),@"messageRect",
                                  MYINT(0xffffff),@"textColor",
                                  COLOR(147,41,41),@"backgroundColor",
                                  @"theme1", @"theme",
                                  nil];
            else
                dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYRECT(95, 58.5, 130, 130),@"callerImageRect",
                   CENTER_RECT(0, -18, 240, 60 ), @"callerRect",
                   CENTER_RECT(0, 30, 120, 30 ), @"callerSecondRect",
                   MYRECT(-160, -116, 160, 60 ),@"acceptBtnRect",
                   MYRECT(0, -116, 160, 60 ),@"declineBtnRect",
                   MYRECT(-160, -180, 160, 60 ),@"remindRect",
                   MYRECT(0, -180, 160, 60 ),@"messageRect",
                   MYINT(0xffffff),@"textColor",
                   COLOR(147,41,41),@"backgroundColor",
                   @"theme1", @"theme",
                   nil];

        }else
        if( [ templateId isEqualToString: @"incoming_call2" ] )
        {
            if ( [ Utils getScreenSize ].height >= 600 && ![ Utils isIPad ] )
            {
                dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                       MYRECT(89, 45, 142, 123.5 ),@"callerImageRect",
                       MYRECT(20, 190, 280, 60 ), @"callerRect",
                       MYRECT(90, 250, 140, 35 ), @"callerSecondRect",
                       MYRECT(111, 432.5, 98.5, 85.5 ),@"acceptBtnRect",
                       MYRECT(111, 345, 98.5, 85.5 ),@"declineBtnRect",
                       MYRECT(38, 388.5, 98.5, 85.5 ),@"remindRect",
                       MYRECT(185, 388.5, 98.5, 85.5 ),@"messageRect",
                       MYINT(0xffffff),@"textColor",
                       COLOR(15,17,38),@"backgroundColor",
                       @"theme2", @"theme",
                       nil];
            } else {
                dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                       MYRECT(89, 30, 142, 123.5 ),@"callerImageRect",
                       MYRECT(20, 165, 280, 60 ), @"callerRect",
                       MYRECT(90, 225, 140, 35 ), @"callerSecondRect",
                       MYRECT(111, 382.5, 98.5, 85.5 ),@"acceptBtnRect",
                       MYRECT(111, 295, 98.5, 85.5 ),@"declineBtnRect",
                       MYRECT(38, 338.5, 98.5, 85.5 ),@"remindRect",
                       MYRECT(185, 338.5, 98.5, 85.5 ),@"messageRect",
                       MYINT(0xffffff),@"textColor",
                       COLOR(15,17,38),@"backgroundColor",
                       @"theme2", @"theme",
                       nil];
            }
        }else
        if( [ templateId isEqualToString: @"incoming_call3" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   CENTER_RECT(0, -140, 280, 70 ), @"callerRect",
                   CENTER_RECT(0, -80, 140, 35 ), @"callerSecondRect",
                   MYRECT(164.5, -120, 130, 66 ),@"acceptBtnRect",
                   MYRECT(25.5, -120, 130, 66 ),@"declineBtnRect",
                   MYRECT(25.5, -210, 130, 66 ),@"remindRect",
                   MYRECT(164.5, -210, 130, 66 ),@"messageRect",
                   MYINT(0xffffff),@"textColor",
                   COLOR(15,17,38),@"backgroundColor",
                   @"theme3", @"theme",
                   nil];
        }else
        if( [ templateId isEqualToString: @"incoming_call4" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYRECT(20, 20, 280, 60 ), @"callerRect",
                   MYRECT(90, 80, 140, 35 ), @"callerSecondRect",
                   MYRECT(20, -195, 126, 52 ),@"acceptBtnRect",
                   MYRECT(170, -195, 126, 52 ),@"declineBtnRect",
                   MYRECT(20, -125, 280, 46 ),@"remindRect",
                   MYRECT(20, -68, 280, 46 ),@"messageRect",
                   MYINT(0xffffff),@"textColor",
                   COLOR(15,17,38),@"backgroundColor",
                   @"theme4", @"theme",
                   nil];
        }else
        if( [ templateId isEqualToString: @"incoming_call5" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   CENTER_RECT(0, -140, 280, 70 ), @"callerRect",
                   CENTER_RECT(0, -80, 140, 35 ), @"callerSecondRect",
                   MYRECT(164, -95, 140, 66 ),@"acceptBtnRect",
                   MYRECT(16, -95, 140, 66 ),@"declineBtnRect",
                   MYRECT(16, -180, 140, 66 ),@"remindRect",
                   MYRECT(164, -180, 140, 66 ),@"messageRect",
                   MYINT(0xffffff),@"textColor",
                   COLOR(15,17,38),@"backgroundColor",
                   @"theme4", @"theme",
                   nil];
        }else
        if( [ templateId isEqualToString: @"incoming_call6" ] )
        {
                dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                       CENTER_RECT(0, -140, 280, 70 ), @"callerRect",
                       CENTER_RECT(0, -80, 140, 35 ), @"callerSecondRect",
                       MYRECT(200, -115, 70, 70 ),@"acceptBtnRect",
                       MYRECT(40, -115,  70, 70 ),@"declineBtnRect",
                       MYRECT(60, -185, 19, 20 ),@"remindRect",
                       MYRECT(220, -185, 23, 20 ),@"messageRect",
                       MYRECT(20, -164, 110, 30 ),@"caption_remindRect",
                       MYRECT(180, -164, 110, 30 ),@"caption_messageRect",
                       MYRECT(180, -45, 110, 30 ),@"caption_acceptRect",
                       MYRECT(20, -45, 110, 30 ),@"caption_declineRect",
                       MYINT(0xffffff),@"textColor",
                       [UIColor whiteColor],@"captionColor",
                       COLOR(15,17,38),@"backgroundColor",
                       @"theme6", @"theme",
                       nil];
        }else
        if( [ templateId isEqualToString: @"incoming_call7" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   CENTER_RECT(0, -180, 280, 70 ), @"callerRect",
                   CENTER_RECT(0, -120, 140, 35 ), @"callerSecondRect",
                   MYRECT(20, -180, 280, 60 ),@"acceptBtnRect",
                   MYRECT(20, -110, 280, 60 ),@"declineBtnRect",
                   MYINT(0xffffff),@"textColor",
                   [UIColor whiteColor],@"captionColor",
                   COLOR(0,0,0),@"backgroundColor",
                   @"theme7", @"theme",
                   nil];
        }else
            if( [ templateId isEqualToString: @"incoming_call8" ] )
            {
                dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                       CENTER_RECT(0, -180, 280, 70 ), @"callerRect",
                       CENTER_RECT(0, -120, 140, 35 ), @"callerSecondRect",
                       MYRECT(20, -180, 280, 60 ),@"acceptBtnRect",
                       MYRECT(20, -110, 280, 60 ),@"declineBtnRect",
                       MYINT(0xffffff),@"textColor",
                       [UIColor grayColor],@"captionColor",
                       COLOR(0,0,0),@"backgroundColor",
                       @"theme8", @"theme",
                       nil];
            }
        else if( [ templateId isEqualToString: @"incoming_call9" ] )
            {
                dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                       CENTER_RECTX(0, 56, 280, 48 ), @"callerRect",
                       CENTER_RECTX(0, 105, 140, 28 ), @"callerSecondRect",
                       CENTER_RECTX( 83, -152, 66, 66 ),@"acceptBtnRect",
                       CENTER_RECTX( -83, -152,  66, 66 ),@"declineBtnRect",
                       CENTER_RECTX( 83, -86, 110, 30 ),@"caption_acceptRect",
                       CENTER_RECTX( -83, -86, 110, 30 ),@"caption_declineRect",
                       CENTER_RECTX(-83, -229, 22, 22 ),@"remindRect",
                       CENTER_RECTX( 83, -225, 19, 17 ),@"messageRect",
                       CENTER_RECTX(-83, -207, 110, 30 ),@"caption_remindRect",
                       CENTER_RECTX( 83, -207, 110, 30 ),@"caption_messageRect",
                       [ UIFont systemFontOfSize:30 weight: UIFontWeightLight], @"nameFont",
                       MYFONT(17), @"secondFont",
                       MYFONT(13), @"captionFont",
                       MYINT(0xffffff),@"textColor",
                       MYINT(0x1), @"NoFlash",
                       [UIColor whiteColor],@"captionColor",
                       MYINT(0x00ff00),@"batteryColor",
                       COLOR(15,17,38),@"backgroundColor",
                       @"theme9", @"theme",
                       nil];
            }
        else if( [ templateId isEqualToString: @"incoming_call10" ] )
        {
        }
        page = [[ CPageIncomingCall alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
        
    }else if( [ templateId hasPrefix: @"outgoing_call" ] )
    {
        if ( [ templateId isEqualToString: @"outgoing_call1" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYRECT(30, 58, 80, 80 ),@"callerImageRect",
                   MYRECT( 110, 58, 180, 44 ) , @"callerRect",
                   MYRECT( 110, 104, 180, 36 ), @"callerSecondRect",
                   MYRECT(16, -100, -32, 66 ),@"endCallRect",
                   MYINT(175),@"buttonTop",
                   MYINT(20),@"buttonDistanceX",
                   MYINT(20),@"buttonDistanceY",
                   MYINT(73.5),@"buttonWidth",
                   MYINT(73.5),@"buttonHeight",
                   MYINT(0xffffff),@"textColor",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme1", @"theme",
                   nil];
        }else
        if ( [ templateId isEqualToString: @"outgoing_call2" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYRECT(16, 58, 94, 80 ),@"callerImageRect",
                   MYRECT( 110, 58, 180, 44 ) , @"callerRect",
                   MYRECT( 110, 104, 180, 36 ), @"callerSecondRect",
                   
                   CENTER_RECT(0, 69, 99, 86 ),@"endCallRect",
                   CENTER_RECT(-73, 26, 99, 86 ),@"buttonRect1",
                   CENTER_RECT(  0, -17, 99, 86 ),@"buttonRect2",
                   CENTER_RECT(-73, 112, 99, 86 ),@"buttonRect3",
                   CENTER_RECT(  0, 155, 99, 86 ),@"buttonRect4",
                   CENTER_RECT( 73, 26, 99, 86 ),@"buttonRect5",
                   CENTER_RECT( 74, 111.5, 99, 86 ),@"buttonRect6",
                   
                   MYINT(0xffffff),@"textColor",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme2", @"theme",
                   nil];
        }else
        if ( [ templateId isEqualToString: @"outgoing_call3" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYRECT(30, 58, 80, 80 ),@"callerImageRect",
                   MYRECT( 110, 58, 180, 44 ) , @"callerRect",
                   MYRECT( 110, 104, 180, 36 ), @"callerSecondRect",
                   MYRECT(25, -100, -50, 66 ),@"endCallRect",
                   MYINT(175),@"buttonTop",
                   MYINT(20),@"buttonDistanceX",
                   MYINT(20),@"buttonDistanceY",
                   MYINT(73.5),@"buttonWidth",
                   MYINT(73.5),@"buttonHeight",
                   MYINT(0xffffff),@"textColor",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme3", @"theme",
                   nil];
        }else
        if ( [ templateId isEqualToString: @"outgoing_call4" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYRECT(0, 16, 0, 120 ),@"topBarRect",
                   MYRECT(0, -92, 0, 92 ),@"bottomBarRect",
                   MYRECT(30, 40, 80, 80 ),@"callerImageRect",
                   MYRECT( 110, 40, 180, 44 ), @"callerRect",
                   MYRECT( 110, 84, 180, 36 ), @"callerSecondRect",
                   MYRECT( 25, -76, -50, 60 ),@"endCallRect",
                   MYRECT(12, 17.5, 70, 80 ),@"buttonRect1",
                   MYRECT(16, 120.5, 65, 80 ),@"buttonRect2",
                   MYRECT(196, 120.5, 65, 80 ),@"buttonRect3",
                   MYRECT(108, 121, 65, 80 ),@"buttonRect4",
                   MYRECT(108.5, 16.5, 65, 80 ),@"buttonRect5",
                   MYRECT(196, 15, 65, 80 ),@"buttonRect6",
                   CENTER_RECT( 0, 20, 276, 212 ),@"buttonArea",
                   MYINT(0xffffff),@"textColor",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme4", @"theme",
                   nil];
        }else
        if ( [ templateId isEqualToString: @"outgoing_call5" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYRECT(30, 40, 80, 80 ),@"callerImageRect",
                   MYRECT( 110, 40, 180, 44 ), @"callerRect",
                   MYRECT( 110, 85, 180, 36 ), @"callerSecondRect",
                   MYRECT(25, -90, -50, 60 ),@"endCallRect",
                   MYINT(145),@"buttonTop",
                   MYINT(20),@"buttonDistanceX",
                   MYINT(20),@"buttonDistanceY",
                   MYINT(75),@"buttonWidth",
                   MYINT(96.5),@"buttonHeight",
                   MYINT(0xffffff),@"textColor",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme5", @"theme",
                   nil];
        }else
        if ( [ templateId isEqualToString: @"outgoing_call6" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYRECT(-100, 40, 80, 80 ),@"callerImageRect",
                   MYRECT( 20, 40, 180, 44 ), @"callerRect",
                   MYRECT( 20, 85, 180, 36 ), @"callerSecondRect",
                   MYRECT(25, -90, -50, 60 ),@"endCallRect",
                   MYINT(145),@"buttonTop",
                   MYINT(20),@"buttonDistanceX",
                   MYINT(20),@"buttonDistanceY",
                   MYINT(75),@"buttonWidth",
                   MYINT(96.5),@"buttonHeight",
                   MYINT(0xffffff),@"textColor",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme6", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"outgoing_call7" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYRECT( 20, 40, 280, 44 ), @"callerRect",
                   MYRECT( 20, 80, 280, 36 ), @"callerSecondRect",
                   MYRECT(25, -100, -50, 60 ),@"endCallRect",
                   MYINT(145),@"buttonTop",
                   MYINT(60),@"buttonDistanceX",
                   MYINT(40),@"buttonDistanceY",
                   MYINT(40),@"buttonWidth",
                   MYINT(48),@"buttonHeight",
                   MYINT(0xffffff),@"textColor",
                   MYINT(1),@"buttonHasText",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme7", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"outgoing_call8" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYRECT( 20, 40, 280, 44 ), @"callerRect",
                   MYRECT( 20, 80, 280, 36 ), @"callerSecondRect",
                   MYRECT(25, -100, -50, 60 ),@"endCallRect",
                   MYINT(145),@"buttonTop",
                   MYINT(60),@"buttonDistanceX",
                   MYINT(40),@"buttonDistanceY",
                   MYINT(40),@"buttonWidth",
                   MYINT(48),@"buttonHeight",
                   MYINT(0xffffff),@"textColor",
                   MYINT(1),@"buttonHasText",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme8", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"outgoing_call9" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   CENTER_RECTX( 0, 56, 260, 48 ), @"callerRect",
                   CENTER_RECTX( 0, 107, 260, 28 ), @"callerSecondRect",
                   CENTER_RECTX(0, -152, 66, 66 ),@"endCallRect",
                   [ UIFont systemFontOfSize:30 weight: UIFontWeightLight], @"nameFont",
                   MYFONT(17), @"secondFont",
                   MYFONT(13), @"captionFont",
                   MYINT(140),@"buttonTop",
                   MYINT(20),@"buttonDistanceX",
                   MYINT(37),@"buttonDistanceY",
                   MYINT(56),@"buttonWidth",
                   MYINT(56),@"buttonHeight",
                   MYINT(1),@"buttonHasText",
                   MYINT(1),@"hasAnimation",
                   MYINT(0xffffff),@"textColor",
                   [UIColor blackColor],@"backgroundColor",
                   MYINT(0x00ff00),@"batteryColor",
                   @"theme9", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"outgoing_call10" ] )
        {
        }

        page = [[ CPageOutgoingCall alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
        
    }else if( [ templateId hasPrefix: @"inbox" ] )
    {
        if ( [ templateId isEqualToString: @"inbox1" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYINT(TEXTROW_FULL),@"mode",
                   MYINT(100),@"lineHeight",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   CENTER_RECTX(0, -38, 200, 35), @"bottomRect",
                   MYRECTI(-45, 32, 35, 21.5),@"editRect",
                   MYRECTI( 5, 31, 91, 24),@"mailboxRect",
                   MYRECTI( -46, -40, 36, 36),@"composeRect",
                   @"new-mail",@"icon",
                   MYFONT(14),@"font",
                   MYINT(0x0ffffff),@"textColor",
                   MYINT(0x0ffffff),@"bottomTextColor",
                   MYINT(0x808080),@"timeColor",
                   MYINT(0x0ffffff),@"titleColor",
                   [UIColor blackColor],@"backgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme1", @"theme",
                   @"Email Info",@"insertModeTitle",
                   nil];
        }else if ( [ templateId isEqualToString: @"inbox2" ] )
        {
                dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                       MYINT(TEXTROW_FULL),@"mode",
                       MYINT(100),@"lineHeight",
                       MYINT(44), @"topHeight",
                       MYINT(40), @"bottomHeight",
                       CENTER_RECTX(0, -38, 200, 35), @"bottomRect",
                       MYRECTI(-43, 32, 33, 20),@"editRect",
                       MYRECTI( 5, 31, 93, 23),@"mailboxRect",
                       MYRECTI( -46, -40, 36, 36),@"composeRect",
                       @"new-mail",@"icon",
                       MYFONT(14),@"font",
                       MYINT(0x0ffffff),@"textColor",
                       MYINT(0x0ffffff),@"bottomTextColor",
                       MYINT(0x808080),@"timeColor",
                       MYINT(0x0ffffff),@"titleColor",
                       [UIColor blackColor],@"backgroundColor",
                       MYINT(true), @"hasOptions",
                       @"theme2", @"theme",
                       @"Email Info",@"insertModeTitle",
                       nil];
        }else if ( [ templateId isEqualToString: @"inbox3" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYINT(TEXTROW_FULL),@"mode",
                   MYINT(100),@"lineHeight",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   CENTER_RECTX(0, -38, 200, 35), @"bottomRect",
                   MYRECTI(-55, 32, 50, 22),@"editRect",
                   MYRECTI( 5, 32, 93, 23),@"mailboxRect",
                   MYRECTI( -46, -40, 36, 36),@"composeRect",
                   @"new-mail",@"icon",
                   MYFONT(14),@"font",
                   MYINT(0x0ffffff),@"textColor",
                   MYINT(0x0ffffff),@"bottomTextColor",
                   MYINT(0x808080),@"timeColor",
                   MYINT(0x0ffffff),@"titleColor",
                   [UIColor blackColor],@"backgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme3", @"theme",
                   @"Email Info",@"insertModeTitle",
                   nil];
        }else if ( [ templateId isEqualToString: @"inbox4" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYINT(TEXTROW_FULL),@"mode",
                   MYINT(100),@"lineHeight",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   MYRECTI(0, -44, 0, 44), @"bottomRect",
                   MYRECTI(-60, 27, 51.5, 30.5),@"editRect",
                   MYRECTI( 5, 27, 78, 30.5),@"mailboxRect",
                   MYRECTI( -46, -40, 36, 36),@"composeRect",
                   @"blue-dot",@"icon",
                   MYFONT(14),@"font",
                   MYINT(0x0),@"textColor",
                   MYINT(0x0ffffff),@"topButtonColor",
                   MYINT(0x0ffffff),@"bottomTextColor",
                   MYINT(0x808080),@"timeColor",
                   MYINT(0x0ffffff),@"titleColor",
                   MYINT(0x738ce0),@"timeColor",
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme4", @"theme",
                   @"Email Info",@"insertModeTitle",
                   nil];
        }else if ( [ templateId isEqualToString: @"inbox5" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYINT(TEXTROW_FULL),@"mode",
                   MYINT(100),@"lineHeight",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   MYRECTI(0, -44, 0, 44), @"bottomRect",
                   MYRECTI(-40, 33, 32, 20),@"editRect",
                   MYRECTI( 5, 28, 77, 30),@"mailboxRect",
                   MYRECTI( -46, -40, 36, 36),@"composeRect",
                   @"new-mail",@"icon",
                   MYFONT(14),@"font",
                   MYINT(0x0),@"textColor",
                   MYINT(0x0),@"bottomTextColor",
                   MYINT(0x808080),@"timeColor",
                   MYINT(0x0),@"titleColor",
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme5", @"theme",
                   @"Email Info",@"insertModeTitle",
                   nil];
        }else if ( [ templateId isEqualToString: @"inbox6" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYINT(TEXTROW_FULL),@"mode",
                   MYINT(100),@"lineHeight",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   MYRECTI(0, -44, 0, 44), @"bottomRect",
                   MYRECTI(-40, 33, 32, 20),@"editRect",
                   MYRECTI( 5, 28, 77, 30),@"mailboxRect",
                   MYRECTI( -46, -40, 36, 36),@"composeRect",
                   @"new-mail",@"icon",
                   MYFONT(14),@"font",
                   MYINT(0x0),@"textColor",
                   MYINT(0x0),@"bottomTextColor",
                   MYINT(0x808080),@"timeColor",
                   MYINT(0x0),@"titleColor",
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme6", @"theme",
                   @"Email Info",@"insertModeTitle",
                   nil];
        }else if ( [ templateId isEqualToString: @"inbox7" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYINT(TEXTROW_FULL),@"mode",
                   MYINT(100),@"lineHeight",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   CENTER_RECTX(0, -38, 200, 35), @"bottomRect",
                   MYRECTI(-40, 33, 34, 22),@"editRect",
                   MYRECTI( 5, 30, 100, 28),@"mailboxRect",
                   MYRECTI( -46, -40, 36, 36),@"composeRect",
                   MYRECTI( 0, 0, 0.1, 0.1),@"refreshRect",
                   @"new-mail",@"icon",
                   MYFONT(14),@"font",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"bottomTextColor",
                   MYINT(0x808080),@"timeColor",
                   MYINT(0xffffff),@"titleColor",
                   [UIColor blackColor],@"backgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme7", @"theme",
                   @"Email Info",@"insertModeTitle",
                   nil];
        }else if ( [ templateId isEqualToString: @"inbox8" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYINT(TEXTROW_FULL),@"mode",
                   MYINT(100),@"lineHeight",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   CENTER_RECTX(0, -38, 200, 35), @"bottomRect",
                   MYRECTI(-40, 33, 34, 22),@"editRect",
                   MYRECTI( 5, 30, 100, 28),@"mailboxRect",
                   MYRECTI( -37, -36, 30, 30),@"composeRect",
                   MYRECTI( 0, 0, 0.1, 0.1),@"refreshRect",
                   @"new-mail",@"icon",
                   MYFONT(14),@"font",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"bottomTextColor",
                   MYINT(0x808080),@"timeColor",
                   MYINT(0xffffff),@"titleColor",
                   [UIColor blackColor],@"backgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme8", @"theme",
                   @"Email Info",@"insertModeTitle",
                   nil];
        }else if ( [ templateId isEqualToString: @"inbox9" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYINT(TEXTROW_FULL),@"mode",
                   MYINT(100),@"lineHeight",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   MYRECTI(0, -44, 0, 44), @"bottomRect",
                   MYRECTI(-40, 33, 32, 20),@"editRect",
                   MYRECTI( 5, 28, 77, 30),@"mailboxRect",
                   MYRECTI( -46, -40, 36, 36),@"composeRect",
                   @"new-mail",@"icon",
                   MYFONT(14),@"font",
                   MYFONT(16),@"font2",
                   MYINT(0x0),@"textColor",
                   MYINT(0x0),@"bottomTextColor",
                   MYINT(0x808080),@"timeColor",
                   MYINT(0x0),@"titleColor",
                   MYINT(0x7aff),@"topButtonColor",
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme6", @"theme",
                   @"Email Info",@"insertModeTitle",
                   nil];
        }else if ( [ templateId isEqualToString: @"inbox10" ] )
        {
        }
        page = [[ CPageIncomingMail alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }else if( [ templateId hasPrefix: @"compose_email" ] )
    {
        if ( [ templateId isEqualToString: @"compose_email1" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(14),@"font",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"btnFontColor",
                   [UIColor whiteColor], @"titleColor",
                   COLOR(0xc0, 0xc0, 0xc0), @"captionColor",
                   MYRECTI(-37, 70, 32, 32),@"addRect",
                   MYRECTI(-60, 25, 57, 34.5),@"sendRect",
                   MYRECTI( 5, 25, 57, 34.5),@"cancelRect",
                   [UIColor grayColor],@"backgroundColor",
                   @"theme1", @"theme",
                   nil];
        }else
        if ( [ templateId isEqualToString: @"compose_email2" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(14),@"font",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"btnFontColor",
                   [UIColor whiteColor], @"titleColor",
                   [UIColor whiteColor], @"captionColor",
                   MYRECTI(-37, 70, 32, 32),@"addRect",
                   MYRECTI(-60, 25, 57, 34.5),@"sendRect",
                   MYRECTI( 5, 25, 57, 34.5),@"cancelRect",
                   [UIColor grayColor],@"backgroundColor",
                   @"theme2", @"theme",
                   nil];
        }else
        if ( [ templateId isEqualToString: @"compose_email3" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(14),@"font",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"btnFontColor",
                   [UIColor whiteColor], @"titleColor",
                   [UIColor whiteColor], @"captionColor",
                   MYRECTI(-37, 70, 32, 32),@"addRect",
                   MYRECTI(-60, 25, 57, 34.5),@"sendRect",
                   MYRECTI( 5, 25, 57, 34.5),@"cancelRect",
                   [UIColor grayColor],@"backgroundColor",
                   @"theme3", @"theme",
                   nil];
        }else
        if ( [ templateId isEqualToString: @"compose_email4" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(14),@"font",
                   MYINT(0x0),@"textColor",
                   MYINT(0xffffff),@"btnFontColor",
                   MYINT(1), @"isImageTopBarButton",
                   [UIColor whiteColor], @"titleColor",
                   [UIColor grayColor], @"captionColor",
                   MYRECTI(-37, 70, 32, 32),@"addRect",
                   MYRECTI(-60, 25, 57, 34.5),@"sendRect",
                   MYRECTI( 5, 25, 57, 34.5),@"cancelRect",
                   [UIColor grayColor],@"backgroundColor",
                   @"theme4", @"theme",
                   nil];
        }else
        if ( [ templateId isEqualToString: @"compose_email5" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(14),@"font",
                   MYINT(0x0),@"textColor",
                   MYINT(0x0),@"btnFontColor",
                   [UIColor blackColor], @"titleColor",
                   [UIColor blackColor], @"captionColor",
                   MYRECTI(-37, 75, 32, 32),@"addRect",
                   MYRECTI(-60, 25, 57, 34.5),@"sendRect",
                   [UIColor grayColor],@"backgroundColor",
                   @"theme5", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"compose_email6" ] )
            {
                dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                       MYFONT(14),@"font",
                       MYINT(0x0),@"textColor",
                       MYINT(0x0),@"btnFontColor",
                       [UIColor blackColor], @"titleColor",
                       [UIColor blackColor], @"captionColor",
                       MYRECTI(-37, 75, 32, 32),@"addRect",
                       MYRECTI(-60, 25, 57, 34.5),@"sendRect",
                       [UIColor grayColor],@"backgroundColor",
                       @"theme5", @"theme",
                       nil];
            } else if ( [ templateId isEqualToString: @"compose_email7" ] )
                {
                    dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                           MYFONT(14),@"font",
                           MYINT(0xffffff),@"textColor",
                           MYINT(0xff0000),@"btnFontColor",
                           [UIColor whiteColor], @"titleColor",
                           [UIColor lightGrayColor], @"captionColor",
                           MYRECTI(2, 25, 57, 32),@"cancelRect",
                           MYRECTI(-60, 25, 57, 34.5),@"sendRect",
                           [UIColor grayColor],@"backgroundColor",
                           @"theme7", @"theme",
                           nil];
                }else if ( [ templateId isEqualToString: @"compose_email8" ] )
                {
                    dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                           MYFONT(14),@"font",
                           MYINT(0xffffff),@"textColor",
                           MYINT(0xf2fcbd),@"btnFontColor",
                           [UIColor whiteColor], @"titleColor",
                           [UIColor lightGrayColor], @"captionColor",
                           MYRECTI(2, 25, 57, 32),@"cancelRect",
                           MYRECTI(-60, 25, 57, 34.5),@"sendRect",
                           [UIColor grayColor],@"backgroundColor",
                           @"theme8", @"theme",
                           nil];
                }else if ( [ templateId isEqualToString: @"compose_email9" ] )
                {
                    dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                           MYFONT(14),@"font",
                           MYINT(0x0),@"textColor",
                           MYINT(0x0),@"btnFontColor",
                           MYINT(0x7aff),@"topButtonColor",
                           [UIColor blackColor], @"titleColor",
                           [UIColor blackColor], @"captionColor",
                           MYRECTI(-37, 75, 32, 32),@"addRect",
                           MYRECTI(-60, 25, 57, 34.5),@"sendRect",
                           [UIColor grayColor],@"backgroundColor",
                           @"theme6", @"theme",
                           nil];
                }else if ( [ templateId isEqualToString: @"compose_email10" ] )
                {
                }
        page = [[ CPageComposeEMail alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }
    else if( [ templateId hasPrefix: @"all_contacts" ] )
    {
        if ( [ templateId isEqualToString: @"all_contacts1" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYINT(84), @"topHeight",
                   MYINT(0x0ffffff),@"textColor",
                   [UIColor whiteColor],@"titleColor",
                   [UIColor blackColor],@"backgroundColor",
                   COLOR(147,42,39),@"sectionColor",
                   [UIColor whiteColor],@"sectionTextColor",
                   [UIColor redColor],@"dividerColor",
                   MYRECTI(5,70,-10,30),@"searchRect",
                   CENTER_RECTX(-20,76,20,20),@"searchIconRect",
                   MYRECTI(-44, 28, 34, 30),@"addRect",
                   MYRECTI( 5, 28, 63, 30.5),@"groupsRect",
                   MYINT(true), @"hasOptions",
                   @"Contact Info",@"insertModeTitle",
                   @"theme1", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"all_contacts2" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYINT(84), @"topHeight",
                   MYINT(0x0ffffff),@"textColor",
                   [UIColor whiteColor],@"titleColor",
                   [UIColor blackColor],@"backgroundColor",
                   COLOR(28,28,40),@"sectionColor",
                   [UIColor whiteColor],@"sectionTextColor",
                   MYRECTI(5,70,-10,30),@"searchRect",
                   CENTER_RECTX(-20,76,20,20),@"searchIconRect",
                   MYRECTI(-44, 28, 34, 30),@"addRect",
                   MYRECTI( 5, 28, 63, 30.5),@"groupsRect",
                   MYINT(true), @"hasOptions",
                   @"Contact Info",@"insertModeTitle",
                   @"theme2", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"all_contacts3" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYINT(84), @"topHeight",
                   MYINT(0x0ffffff),@"textColor",
                   [UIColor whiteColor],@"titleColor",
                   [UIColor blackColor],@"backgroundColor",
                   COLOR(32,32,32),@"sectionColor",
                   [UIColor whiteColor],@"sectionTextColor",
                   MYRECTI(10,70,-20,30),@"searchRect",
                   CENTER_RECTX(-20,76,20,20),@"searchIconRect",
                   MYRECTI(-44, 28, 34, 30),@"addRect",
                   MYRECTI( 5, 28, 63, 30.5),@"groupsRect",
                   MYINT(true), @"hasOptions",
                   @"Contact Info",@"insertModeTitle",
                   @"theme3", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"all_contacts4" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYINT(84), @"topHeight",
                   MYINT(0x0),@"textColor",
                   [UIColor whiteColor],@"titleColor",
                   [UIColor whiteColor],@"backgroundColor",
                   COLOR(171,181,190),@"sectionColor",
                   [UIColor whiteColor],@"sectionTextColor",
                   MYRECTI(5,70,-10,30),@"searchRect",
                   CENTER_RECTX(-80,76,20,20),@"searchIconRect",
                   MYRECTI(-44, 28, 34, 30),@"addRect",
                   MYRECTI( 5, 28, 63, 30.5),@"groupsRect",
                   MYINT(true), @"hasOptions",
                   @"Contact Info",@"insertModeTitle",
                   @"theme4", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"all_contacts5" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYINT(84), @"topHeight",
                   MYINT(0x0),@"textColor",
                   [UIColor blackColor],@"titleColor",
                   [UIColor whiteColor],@"backgroundColor",
                   COLOR(240,240,240),@"sectionColor",
                   [UIColor blackColor],@"sectionTextColor",
                   MYRECTI(8,75,-16,23),@"searchRect",
                   CENTER_RECTX(-20,76,20,20),@"searchIconRect",
                   MYRECTI(-44, 28, 34, 30),@"addRect",
                   MYRECTI( 5, 28, 63, 30.5),@"groupsRect",
                   MYINT(true), @"hasOptions",
                   @"Contact Info",@"insertModeTitle",
                   @"theme4", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"all_contacts6" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYINT(84), @"topHeight",
                   MYINT(0x0),@"textColor",
                   [UIColor blackColor],@"titleColor",
                   [UIColor whiteColor],@"backgroundColor",
                   COLOR(240,240,240),@"sectionColor",
                   [UIColor blackColor],@"sectionTextColor",
                   MYRECTI(8,75,-16,23),@"searchRect",
                   CENTER_RECTX(-20,76,20,20),@"searchIconRect",
                   MYRECTI(-44, 28, 34, 30),@"addRect",
                   MYRECTI( 5, 28, 63, 30.5),@"groupsRect",
                   MYINT(true), @"hasOptions",
                   @"Contact Info",@"insertModeTitle",
                   @"theme6", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"all_contacts7" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYINT(84), @"topHeight",
                   MYINT(0xffffff),@"textColor",
                   [UIColor whiteColor],@"titleColor",
                   [UIColor blackColor],@"backgroundColor",
                   COLOR(200,200,200),@"sectionColor",
                   [UIColor redColor],@"sectionTextColor",
                   MYRECT(0,60,320,24),@"searchIconRect",
                   MYRECTI(-34, 28, 30, 30),@"addRect",
                   MYRECTI( 5, 28, 63, 30.5),@"groupsRect",
                   MYINT(true), @"hasOptions",
                   @"Contact Info",@"insertModeTitle",
                   @"theme7", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"all_contacts8" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYINT(84), @"topHeight",
                   MYINT(0xffffff),@"textColor",
                   [UIColor whiteColor],@"titleColor",
                   [UIColor blackColor],@"backgroundColor",
                   COLOR(0x16,0x1d,0x23),@"sectionColor",
                   COLOR(0x8c,0xd0,0xdd),@"sectionTextColor",
                   MYRECT(0,60,320,24),@"searchIconRect",
                   MYRECTI(-34, 28, 30, 30),@"addRect",
                   MYRECTI( 5, 28, 30, 30),@"groupsRect",
                   MYINT(true), @"hasOptions",
                   @"Contact Info",@"insertModeTitle",
                   @"theme8", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"all_contacts9" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYINT(84), @"topHeight",
                   MYINT(0x0),@"textColor",
                   MYINT(0x7aff),@"topButtonColor",
                   [UIColor blackColor],@"titleColor",
                   [UIColor whiteColor],@"backgroundColor",
                   COLOR(240,240,240),@"sectionColor",
                   [UIColor blackColor],@"sectionTextColor",
                   MYRECTI(8,75,-16,23),@"searchRect",
                   CENTER_RECTX(-20,76,20,20),@"searchIconRect",
                   MYRECTI(-44, 28, 34, 30),@"addRect",
                   MYRECTI( 5, 28, 63, 30.5),@"groupsRect",
                   MYINT(true), @"hasOptions",
                   @"Contact Info",@"insertModeTitle",
                   @"theme6", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"all_contacts10" ] )
        {
        }
        page = [[ CPageContacts alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }
    else if( [ templateId hasPrefix: @"contact_detail" ] )
    {
        if ( [ templateId isEqualToString: @"contact_detail1" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYRECTI(20,80,-80,80),@"nameRect",
                   @"Phone", @"caption1",
                   COLOR_INT(0xd24848),@"captionColor",
                   MYINT(0xd24848),@"captionColorInt",
                   MYRECTI(20,165,-110,22),@"caption_mobileRect",
                   MYRECTI(20,187,-110,22),@"mobileRect",
                   MYRECTI(20,209,-110,44),@"addressRect",
                   MYRECTI(-60, 27, 51.5, 30.5),@"editRect",
                   MYRECTI( 1, 29, 106.5, 23.5),@"all-contactsRect",
                   MYRECTI( 20, 264, -40, 20.5),@"info1Rect",
                   MYRECTI( 20, 334, -40, 1),@"divider1Rect",
                   MYRECTI( 20, 376, -40, 1),@"divider2Rect",
                   MYRECTI( 20, 416, -40, 1),@"divider3Rect",
                   MYRECTI( 20, 342, -40, 23.5),@"info2Rect",
                   MYRECTI( 20, 386, -40, 23),@"info3Rect",
                   MYRECTI( 20, 430, -40, 26),@"info4Rect",
                   MYRECTI( -88, 187, 32, 32),@"mobileIcon0Rect",
                   MYRECTI( -52, 187, 32, 32),@"mobileIcon1Rect",
                   MYRECTI( -88, 220, 32, 32),@"mobileIcon2Rect",
                   MYRECTI( -52, 220, 32, 32),@"mobileIcon3Rect",
                   MYINT(true), @"hasOptions",
                   MYINT(20), @"topHeight",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0), @"bottomBarHeight",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme1", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"contact_detail2" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYRECTI(20,80,-80,80),@"nameRect",
                   @"Other", @"caption1",
                   COLOR_INT(0xffffff),@"captionColor",
                   MYINT(0xffffff),@"captionColorInt",
                   MYRECTI(20,165,-110,22),@"caption_mobileRect",
                   MYRECTI(20,187,-110,22),@"mobileRect",
                   MYRECTI(20,209,-110,44),@"addressRect",
                   MYRECTI(-60, 27, 51.5, 30.5),@"editRect",
                   MYRECTI( 1, 27, 124.5, 27),@"all-contactsRect",
                   MYRECTI( 20, 264, -40, 20.5),@"info1Rect",
                   MYRECTI( 20, 334, -40, 1),@"divider1Rect",
                   MYRECTI( 20, 376, -40, 1),@"divider2Rect",
                   MYRECTI( 20, 416, -40, 1),@"divider3Rect",
                   MYRECTI( 20, 342, -40, 27.5),@"info2Rect",
                   MYRECTI( 20, 386, -40, 23.5),@"info3Rect",
                   MYRECTI( 20, 430, -40, 22.5),@"info4Rect",
                   MYRECTI( -88, 187, 32, 32),@"mobileIcon0Rect",
                   MYRECTI( -52, 187, 32, 32),@"mobileIcon1Rect",
                   MYRECTI( -88, 220, 32, 32),@"mobileIcon2Rect",
                   MYRECTI( -52, 220, 32, 32),@"mobileIcon3Rect",
                   MYINT(true), @"hasOptions",
                   MYINT(20), @"topHeight",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0), @"bottomBarHeight",
                   [UIColor whiteColor],@"backgroundColor",
                   @"theme2", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"contact_detail3" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYRECTI(20,80,-80,80),@"nameRect",
                   @"Other", @"caption1",
                   COLOR_INT(0x39af5b),@"captionColor",
                   MYINT(0x39af5b),@"captionColorInt",
                   MYRECTI(20,165,-110,22),@"caption_mobileRect",
                   MYRECTI(20,187,-110,22),@"mobileRect",
                   MYRECTI(20,209,-110,44),@"addressRect",
                   MYRECTI(-60, 27, 51.5, 30.5),@"editRect",
                   MYRECTI( 5, 27, 106.5, 30.5),@"all-contactsRect",
                   MYRECTI( 20, 250, -40, 43),@"info1Rect",
                   MYRECTI( 20, 334, -40, 1),@"divider1Rect",
                   MYRECTI( 20, 376, -40, 1),@"divider2Rect",
                   MYRECTI( 20, 416, -40, 1),@"divider3Rect",
                   MYRECTI( 20, 338, -40, 32),@"info2Rect",
                   MYRECTI( 20, 382, -40, 32),@"info3Rect",
                   MYRECTI( 20, 426, -40, 32),@"info4Rect",
                   MYRECTI( -88, 187, 32, 32),@"mobileIcon0Rect",
                   MYRECTI( -52, 187, 32, 32),@"mobileIcon1Rect",
                   MYRECTI( -88, 220, 32, 32),@"mobileIcon2Rect",
                   MYRECTI( -52, 220, 32, 32),@"mobileIcon3Rect",
                   MYINT(true), @"hasOptions",
                   MYINT(20), @"topHeight",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0), @"bottomBarHeight",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme3", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"contact_detail4" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYRECTI(20,82.5,56,56),@"iconRect",
                   MYRECTI(94,98.5,180,40),@"nameRect",
                   MYRECTI(94,170,200,30),@"mobileRect",
                   MYRECTI(20,170,60,30),@"caption_mobileRect",
                   MYRECTI(94,230,200,30),@"addressRect",
                   MYRECTI(20,230,60,30),@"caption_addressRect",
                   MYRECTI(-60, 27, 51.5, 30.5),@"editRect",
                   MYRECTI( 5, 27, 91, 30.5),@"all-contactsRect",
                   @"mobile", @"caption1",
                   @"home", @"caption2",
                   MYRECT( 20, 290, 140, 43.5),@"info1Rect",
                   MYRECT( 165,290, 140, 43.5),@"info2Rect",
                   MYRECT( 20, 350, 140, 43.5),@"info3Rect",
                   MYRECT( 165,350, 140, 43.5),@"info4Rect",
                   MYINT(true), @"hasOptions",
                   MYINT(20), @"topHeight",
                   MYINT(0x0),@"textColor",
                   MYINT(44), @"bottomBarHeight",
                   COLOR(214,218,227),@"backgroundColor",
                   @"theme4", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"contact_detail5" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYRECTI(20,80,-40,80),@"nameRect",
                   @"other", @"caption1",
                   COLOR_INT(0x2b84fc),@"captionColor",
                   MYINT(0x2b84fc),@"captionColorInt",
                   MYINT(0x2b84fc),@"topButtonColor",
                   MYRECTI(20,165,-110,22),@"caption_mobileRect",
                   MYRECTI(20,187,-110,22),@"mobileRect",
                   MYRECTI(20,209,-110,44),@"addressRect",
                   MYRECTI(-60, 27, 51.5, 30.5),@"editRect",
                   MYRECTI( 1, 27, 104, 26.5),@"all-contactsRect",
                   MYRECTI( 20, 250, -40, 19.5),@"info1Rect",
                   MYRECTI( 20, 338, -40, 22),@"info2Rect",
                   MYRECTI( 20, 382, -40, 23),@"info3Rect",
                   MYRECTI( 20, 426, -40, 21.5),@"info4Rect",
                   MYRECTI( 20, 326, -40, 0.5),@"divider1Rect",
                   MYRECTI( 20, 370, -40, 0.5),@"divider2Rect",
                   MYRECTI( 20, 414, -40, 0.5),@"divider3Rect",
                   MYRECTI( -88, 187, 32, 32),@"mobileIcon0Rect",
                   MYRECTI( -52, 187, 32, 32),@"mobileIcon1Rect",
                   MYRECTI( -88, 220, 32, 32),@"mobileIcon2Rect",
                   MYRECTI( -52, 220, 32, 32),@"mobileIcon3Rect",
                   MYINT(true), @"hasOptions",
                   MYINT(20), @"topHeight",
                   MYINT(0x0),@"textColor",
                   MYINT(0x0),@"titleColor",
                   MYINT(0), @"bottomBarHeight",
                   [UIColor whiteColor],@"backgroundColor",
                   @"theme5", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"contact_detail6" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYRECTI(20,82.5,56,56),@"iconRect",
                   MYRECTI(90,80,-100,36),@"nameRect",
                   MYRECTI(90,116,-100,24),@"secondNameRect",
                   @"work", @"caption1",
                   COLOR_INT(0x2b84fc),@"captionColor",
                   MYINT(0x2b84fc),@"captionColorInt",
                   MYINT(0x2b84fc),@"topButtonColor",
                   MYRECTI(20,165,-110,22),@"caption_mobileRect",
                   MYRECTI(20,187,-110,22),@"mobileRect",
                   MYRECTI(20,209,-110,44),@"addressRect",
                   MYRECTI(-60, 27, 51.5, 30.5),@"editRect",
                   MYRECTI( 1, 27, 104, 26.5),@"all-contactsRect",
                   MYRECTI( 20, 338, -40, 22),@"info2Rect",
                   MYRECTI( 20, 382, -40, 23),@"info3Rect",
                   MYRECTI( 20, 426, -40, 21.5),@"info4Rect",
                   MYRECTI( 20, 326, -40, 0.5),@"divider1Rect",
                   MYRECTI( 20, 370, -40, 0.5),@"divider2Rect",
                   MYRECTI( 20, 414, -40, 0.5),@"divider3Rect",
                   MYRECTI( -88, 187, 32, 32),@"mobileIcon0Rect",
                   MYRECTI( -52, 187, 32, 32),@"mobileIcon1Rect",
                   MYRECTI( -88, 220, 32, 32),@"mobileIcon2Rect",
                   MYRECTI( -52, 220, 32, 32),@"mobileIcon3Rect",
                   MYINT(true), @"hasOptions",
                   MYINT(20), @"topHeight",
                   MYINT(0x0),@"textColor",
                   MYINT(0x0),@"titleColor",
                   MYINT(0), @"bottomBarHeight",
                   [UIColor whiteColor],@"backgroundColor",
                   @"theme6", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"contact_detail7" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYRECTI(20,82.5,56,56),@"iconRect",
                   MYRECTI(90,80,-100,36),@"nameRect",
                   MYRECTI(90,116,-100,24),@"secondNameRect",
                   @"Home", @"caption1",
                   MYINT(0xf23a36),@"topButtonColor",
                   COLOR_INT(0xf23a36),@"captionColor",
                   MYINT(0xf23a36),@"captionColorInt",
                   MYRECTI(20,165,-110,22),@"caption_mobileRect",
                   MYRECTI(20,187,-110,22),@"mobileRect",
                   MYRECTI(20,209,-110,44),@"addressRect",
                   MYRECTI(-60, 27, 51.5, 30.5),@"editRect",
                   MYRECTI( 1, 27, 110, 26.5),@"all-contactsRect",
                   MYRECTI( 20, 338, -40, 22),@"info2Rect",
                   MYRECTI( 20, 382, -40, 23),@"info3Rect",
                   MYRECTI( 20, 426, -40, 23),@"info4Rect",
                   MYRECTI( 20, 326, -40, 0.5),@"divider1Rect",
                   MYRECTI( 20, 370, -40, 0.5),@"divider2Rect",
                   MYRECTI( 20, 414, -40, 0.5),@"divider3Rect",
                   MYRECTI( -88, 187, 32, 32),@"mobileIcon0Rect",
                   MYRECTI( -52, 187, 32, 32),@"mobileIcon1Rect",
                   MYRECTI( -88, 220, 32, 32),@"mobileIcon2Rect",
                   MYRECTI( -52, 220, 32, 32),@"mobileIcon3Rect",
                   MYINT(true), @"hasOptions",
                   MYINT(20), @"topHeight",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0), @"bottomBarHeight",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme7", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"contact_detail8" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYRECTI(20,82.5,56,56),@"iconRect",
                   MYRECTI(90,80,-100,36),@"nameRect",
                   MYRECTI(90,116,-100,24),@"secondNameRect",
                   @"Home", @"caption1",
                   MYINT(0x86d0db),@"topButtonColor",
                   COLOR_INT(0x86d0db),@"captionColor",
                   MYINT(0x86d0db),@"captionColorInt",
                   MYRECTI(20,165,-110,22),@"caption_mobileRect",
                   MYRECTI(20,187,-110,22),@"mobileRect",
                   MYRECTI(20,209,-110,44),@"addressRect",
                   MYRECTI(-60, 27, 51.5, 30.5),@"editRect",
                   MYRECTI( 1, 27, 110, 26.5),@"all-contactsRect",
                   MYRECTI( 20, 338, -40, 22),@"info2Rect",
                   MYRECTI( 20, 382, -40, 23),@"info3Rect",
                   MYRECTI( 20, 426, -40, 23),@"info4Rect",
                   MYRECTI( 20, 326, -40, 0.5),@"divider1Rect",
                   MYRECTI( 20, 370, -40, 0.5),@"divider2Rect",
                   MYRECTI( 20, 414, -40, 0.5),@"divider3Rect",
                   MYRECTI( -88, 187, 32, 32),@"mobileIcon0Rect",
                   MYRECTI( -52, 187, 32, 32),@"mobileIcon1Rect",
                   MYRECTI( -88, 220, 32, 32),@"mobileIcon2Rect",
                   MYRECTI( -52, 220, 32, 32),@"mobileIcon3Rect",
                   MYINT(true), @"hasOptions",
                   MYINT(20), @"topHeight",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0), @"bottomBarHeight",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme8", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"contact_detail9" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_NAME),@"mode",
                   MYRECTI(20,82.5,56,56),@"iconRect",
                   MYRECTI(90,80,-100,36),@"nameRect",
                   MYRECTI(90,116,-100,24),@"secondNameRect",
                   @"work", @"caption1",
                   COLOR_INT(0x2b84fc),@"captionColor",
                   MYINT(0x2b84fc),@"captionColorInt",
                   MYINT(0x2b84fc),@"topButtonColor",
                   MYRECTI(20,165,-110,22),@"caption_mobileRect",
                   MYRECTI(20,187,-110,22),@"mobileRect",
                   MYRECTI(20,209,-110,44),@"addressRect",
                   MYRECTI(-60, 27, 51.5, 30.5),@"editRect",
                   MYRECTI( 1, 27, 104, 30.5),@"all-contactsRect",
                   MYRECTI( 20, 338, -40, 22),@"info2Rect",
                   MYRECTI( 20, 382, -40, 23),@"info3Rect",
                   MYRECTI( 20, 426, -40, 21.5),@"info4Rect",
                   MYRECTI( 20, 326, -40, 0.5),@"divider1Rect",
                   MYRECTI( 20, 370, -40, 0.5),@"divider2Rect",
                   MYRECTI( 20, 414, -40, 0.5),@"divider3Rect",
                   MYRECTI( -88, 187, 32, 32),@"mobileIcon0Rect",
                   MYRECTI( -52, 187, 32, 32),@"mobileIcon1Rect",
                   MYRECTI( -88, 220, 32, 32),@"mobileIcon2Rect",
                   MYRECTI( -52, 220, 32, 32),@"mobileIcon3Rect",
                   MYINT(true), @"hasOptions",
                   MYINT(20), @"topHeight",
                   MYINT(0x0),@"textColor",
                   MYINT(0x0),@"titleColor",
                   MYINT(0), @"bottomBarHeight",
                   [UIColor whiteColor],@"backgroundColor",
                   @"theme6", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"contact_detail10" ] )
        {
        }
        page = [[ CPageContactDetail alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }
    else if( [ templateId hasPrefix: @"text_message" ] )
    {
        if ( [ templateId isEqualToString: @"text_message1" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_TEXTING),@"mode",
                   MYINT(25), @"lineHeight",
                   MYINT(44), @"topHeight",
                   MYINT(44), @"bottomHeight",
                   MYINT(0x0),@"inputTextColor",
                   MYINT(0x0ffffff),@"titleColor",
                   BOLDFONT(20),@"titleFont",
                   MYFONT(15),@"font",
                   MYINT(0x0ffffff),@"myTextColor",
                   MYINT(0x0),@"otherTextColor",
                   MYINT(0x808080),@"timeTextColor",
                   MYRECTI(7,-30,25,18.5), @"cameraRect",
                   MYRECTI(-50,-36,40,28.5), @"sendRect",
                   MYRECTI( 6,10,80,25), @"messagesRect",
                   MYRECTI(-58,10,52,25), @"editRect",
                   MYFONT(17),@"messagesFont",
                   MYRECTI(42, 8, -100, 28 ),@"inputRect",
                   [UIColor blackColor],@"backgroundColor",
                   COLOR(73,73,73),@"inputbox_borderColor",
                   MYINT(true), @"hasOptions",
                   @"Message Info",@"insertModeTitle",
                   @"theme1", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"text_message2" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_TEXTING),@"mode",
                   MYINT(25), @"lineHeight",
                   MYINT(44), @"topHeight",
                   MYINT(44), @"bottomHeight",
                   MYINT(0x0),@"inputTextColor",
                   BOLDFONT(20),@"titleFont",
                   MYFONT(15),@"font",
                   MYINT(0x0ffffff),@"titleColor",
                   MYINT(0x0ffffff),@"myTextColor",
                   MYINT(0x0),@"otherTextColor",
                   MYINT(0x808080),@"timeTextColor",
                   MYRECTI(7,-30,25,18.5), @"cameraRect",
                   MYRECTI(-50,-36,40,28.5), @"sendRect",
                   MYRECTI( 6,10,80,25), @"messagesRect",
                   MYRECTI(-58,10,52,25), @"editRect",
                   MYFONT(17),@"messagesFont",
                   MYRECTI(42, 8, -100, 28 ),@"inputRect",
                   [UIColor blackColor],@"backgroundColor",
                   COLOR(73,73,73),@"inputbox_borderColor",
                   MYINT(true), @"hasOptions",
                   @"Message Info",@"insertModeTitle",
                   @"theme2", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"text_message3" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYINT(TEXTROW_TEXTING),@"mode",
                   MYINT(25), @"lineHeight",
                   MYINT(44), @"topHeight",
                   MYINT(44), @"bottomHeight",
                   MYINT(0xffffff),@"inputTextColor",
                   MYINT(0x0ffffff),@"titleColor",
                   BOLDFONT(18),@"titleFont",
                   MYFONT(15),@"font",
                   MYINT(0x0ffffff),@"myTextColor",
                   MYINT(0x0),@"otherTextColor",
                   MYINT(0x808080),@"timeTextColor",
                   MYRECTI(7,-30,25,18.5), @"cameraRect",
                   MYRECTI(-50,-36,40,28.5), @"sendRect",
                   MYRECTI( 6,10,80,25), @"messagesRect",
                   MYRECTI(-58,10,52,25), @"editRect",
                   MYFONT(16),@"messagesFont",
                   MYRECTI(42, 8, -100, 28 ),@"inputRect",
                   [UIColor blackColor],@"backgroundColor",
                   COLOR(73,73,73),@"inputbox_borderColor",
                   MYINT(true), @"hasOptions",
                   @"Message Info",@"insertModeTitle",
                   @"theme3", @"theme",
                   nil];
        }else
        if ( [ templateId isEqualToString: @"text_message4" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYINT(TEXTROW_TEXTING),@"mode",
                   MYINT(25), @"lineHeight",
                   MYINT(44), @"topHeight",
                   MYINT(44), @"bottomHeight",
                   MYINT(0x0),@"inputTextColor",
                   MYINT(0x0ffffff),@"titleColor",
                   BOLDFONT(20),@"titleFont",
                   MYFONT(15),@"font",
                   MYINT(0x0),@"myTextColor",
                   MYINT(0x0),@"otherTextColor",
                   MYINT(0x808080),@"timeTextColor",
                   MYRECTI(7,-32,26,26), @"cameraRect",
                   MYRECTI(-65,-32,58,25), @"sendRect",
                   MYRECTI( 0,7,91,30.5), @"messagesRect",
                   MYRECTI(-58,7,51.5,30), @"editRect",
                   MYINT(1), @"isImageTopBarButton",
                   MYRECTI(42, 8, -114, 28 ),@"inputRect",
                   COLOR(215,218,227),@"backgroundColor",
                   COLOR(73,73,73),@"inputbox_borderColor",
                   MYINT(true), @"hasOptions",
                   @"Message Info",@"insertModeTitle",
                   @"theme4", @"theme",
                   nil];
        }else
        if ( [ templateId isEqualToString: @"text_message5" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYINT(TEXTROW_TEXTING),@"mode",
                   MYINT(25), @"lineHeight",
                   MYINT(44), @"topHeight",
                   MYINT(0),  @"topbar_textcolor",
                   MYINT(44), @"bottomHeight",
                   MYINT(0x0),@"inputTextColor",
                   MYINT(0x0),@"titleColor",
                   BOLDFONT(20),@"titleFont",
                   MYFONT(15),@"font",
                   MYINT(0x0ffffff),@"myTextColor",
                   MYINT(0x0),@"otherTextColor",
                   MYINT(0x808080),@"timeTextColor",
                   MYRECTI(7,-32,26,26), @"cameraRect",
                   MYRECTI(-65,-32,47.5,22), @"sendRect",
                   MYRECTI( 0,7,85.5,25), @"messagesRect",
                   MYRECTI(-58,7,55.5,25), @"editRect",
                   MYINT(0x007aff),@"messagesBtnColor",
                   MYFONT(17),@"messagesFont",
                   MYRECTI(42, 8, -114, 28 ),@"inputRect",
                   [UIColor whiteColor],@"backgroundColor",
                   COLOR(0xdd,0xdd,0xdd),@"inputbox_borderColor",
                   MYINT(true), @"hasOptions",
                   @"Message Info",@"insertModeTitle",
                   @"theme5", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"text_message6" ] )
         {
                dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                       MYINT(TEXTROW_TEXTING),@"mode",
                       MYINT(25), @"lineHeight",
                       MYINT(44), @"topHeight",
                       MYINT(0),  @"topbar_textcolor",
                       MYINT(44), @"bottomHeight",
                       MYINT(0x0),@"inputTextColor",
                       MYINT(0x0),@"titleColor",
                       BOLDFONT(20),@"titleFont",
                       MYFONT(15),@"font",
                       MYINT(0x0ffffff),@"myTextColor",
                       MYINT(0x0),@"otherTextColor",
                       MYINT(0x808080),@"timeTextColor",
                       MYRECTI(7,-32,26,26), @"cameraRect",
                       MYRECTI(-65,-32,47.5,22), @"sendRect",
                       MYRECTI( 0,7,85.5,25), @"messagesRect",
                       MYRECTI(-58,7,55.5,25), @"editRect",
                       MYINT(0x007aff),@"messagesBtnColor",
                       MYFONT(17),@"messagesFont",
                       MYRECTI(42, 8, -114, 28 ),@"inputRect",
                       [UIColor whiteColor],@"backgroundColor",
                       COLOR(0xdd,0xdd,0xdd),@"inputbox_borderColor",
                       MYINT(true), @"hasOptions",
                       @"Message Info",@"insertModeTitle",
                       @"theme6", @"theme",
                       nil];
         } if ( [ templateId isEqualToString: @"text_message7" ] )
         {
             dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                    MYINT(TEXTROW_TEXTING),@"mode",
                    MYINT(25), @"lineHeight",
                    MYINT(44), @"topHeight",
                    MYINT(44), @"bottomHeight",
                    MYINT(0xffffff),@"inputTextColor",
                    MYINT(0xffffff),@"titleColor",
                    BOLDFONT(20),@"titleFont",
                    MYFONT(15),@"font",
                    MYINT(0xffffff),@"myTextColor",
                    MYINT(0x0),@"otherTextColor",
                    MYINT(0x808080),@"timeTextColor",
                    MYRECTI(7,-36,26,26), @"cameraRect",
                    MYRECTI(-32,-36,26,26), @"sendRect",
                    MYRECTI( 0,8,100,30), @"messagesRect",
                    MYRECTI(-65,10,60,23), @"editRect",
                    MYFONT(17),@"messagesFont",
                    MYRECTI(42, 8, -81, 26 ),@"inputRect",
                    [UIColor blackColor],@"backgroundColor",
                    COLOR(0xdd,0xdd,0xdd),@"inputbox_borderColor",
                    COLOR(0xc0,0xc0,0xc0),@"inputbox_backColor",
                    MYINT(0),@"inputbox_borderCorner",
                    MYINT(true), @"hasOptions",
                    @"Message Info",@"insertModeTitle",
                    @"theme7", @"theme",
                    nil];
         }if ( [ templateId isEqualToString: @"text_message8" ] )
         {
             dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                    MYINT(TEXTROW_TEXTING),@"mode",
                    MYINT(25), @"lineHeight",
                    MYINT(44), @"topHeight",
                    MYINT(44), @"bottomHeight",
                    MYINT(0xffffff),@"inputTextColor",
                    MYINT(0xffffff),@"titleColor",
                    BOLDFONT(20),@"titleFont",
                    MYFONT(15),@"font",
                    MYINT(0xffffff),@"myTextColor",
                    MYINT(0x0),@"otherTextColor",
                    MYINT(0x808080),@"timeTextColor",
                    MYRECTI(14,-36,26,26), @"cameraRect",
                    MYRECTI(-39,-36,26,26), @"sendRect",
                    MYRECTI( 0,8,100,30), @"messagesRect",
                    MYRECTI(-65,10,60,23), @"editRect",
                    MYFONT(17),@"messagesFont",
                    MYRECTI(56, 8, -112, 27 ),@"inputRect",
                    [UIColor blackColor],@"backgroundColor",
                    COLOR(0xdd,0xdd,0xdd),@"inputbox_borderColor",
                    [UIColor clearColor],@"inputbox_backColor",
                    MYINT(0),@"inputbox_borderCorner",
                    MYINT(true), @"hasOptions",
                    @"Message Info",@"insertModeTitle",
                    @"theme8", @"theme",
                    nil];
         }else if ( [ templateId isEqualToString: @"text_message9" ] )
         {
             dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                    MYINT(TEXTROW_TEXTING),@"mode",
                    MYINT(25), @"lineHeight",
                    MYINT(44), @"topHeight",
                    MYINT(0),  @"topbar_textcolor",
                    MYINT(46), @"bottomHeight",
                    MYINT(0x0),@"inputTextColor",
                    MYINT(0x0),@"titleColor",
                    BOLDFONT(20),@"titleFont",
                    MYFONT(15),@"font",
                    MYINT(0x0ffffff),@"myTextColor",
                    MYINT(0x0),@"otherTextColor",
                    MYINT(0x808080),@"timeTextColor",
                    MYRECTI(7,-32,26,26), @"cameraRect",
                    MYRECTI(-54,-28,41,19), @"sendRect",
                    MYRECTI( 0,7,85.5,25), @"messagesRect",
                    MYRECTI(-58,7,55.5,25), @"editRect",
                    MYINT(0x007aff),@"messagesBtnColor",
                    MYFONT(17),@"messagesFont",
                    @"Text Message", @"inputbox_hintMessage",
                    MYRECTI(42, 7, -106, 32 ),@"inputRect",
                    [UIColor whiteColor],@"backgroundColor",
                    COLOR(0xf8,0xf8,0xf8),@"inputbox_backColor",
                    COLOR(0xcd,0xcd,0xcd),@"inputbox_borderColor",
                    MYINT(3),@"inputbox_borderCorner",
                    MYINT(true), @"hasOptions",
                    @"Message Info",@"insertModeTitle",
                    @"theme9", @"theme",
                    nil];
         }else if ( [ templateId isEqualToString: @"text_message10" ] )
         {
         }
        page = [[ CPageTexting alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }
    else if( [ templateId hasPrefix: @"mailboxes" ] )
    {
        if ( [ templateId isEqualToString: @"mailboxes1" ] )
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
               MYFONT(20),@"font",
               MYINT(TEXTROW_MAILBOX),@"mode",
               @"account",@"icon",
               MYRECTI(55, -38, -110, 36), @"bottomRect",
               MYRECTI(-58, 33,  52, 22),  @"editRect",
               MYRECTI(6, 33,  70, 22),  @"leftBtnRect",
               MYRECTI(-40, -38, 36, 36), @"updateRect",
               MYRECTI( 10, 66, 200, 44 ), @"subTitleRect",
               MYRECTI(0,65,0,22), @"subTitleBarRect",
               COLOR(0x93,0x2a,0x27), @"subTitleBarColor",
               @"", @"subTitle",
               @"New MailBox",@"insertModeTitle",
               MYINT(0xffffff),@"subTitleColor",
               MYINT(100), @"lineHeight",
               MYINT(66), @"topHeight",
               MYINT(44), @"bottomHeight",
               MYINT(0xffffff),@"textColor",
               MYINT(0xffffff),@"titleColor",
               MYINT(0xffffff),@"bottomTextColor",
               MYFONT(20),@"font2",
               MYINT(0x808080),@"textColor2",
               [UIColor blackColor],@"backgroundColor",
               [UIColor clearColor],@"textBackgroundColor",
               MYINT(true), @"hasOptions",
               @"theme1", @"theme",
               nil];
        else if ( [ templateId isEqualToString: @"mailboxes2" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   MYINT(TEXTROW_MAILBOX),@"mode",
                   @"account",@"icon",
                   MYRECTI(55, -38, -110, 35), @"bottomRect",
                   MYRECTI(-58, 33,  52, 22),  @"editRect",
                   MYRECTI(6, 33,  70, 22),  @"leftBtnRect",
                   MYRECTI(-30, -36, 23, 26), @"updateRect",
                   MYRECTI( 10, 66, 200, 44 ), @"subTitleRect",
                   MYRECTI(0,65,0,22), @"subTitleBarRect",
                   MYINT(1), @"hideBottomBar",
                   COLOR(0x24,0x26,0x32), @"subTitleBarColor",
                   @"", @"subTitle",
                   @"New MailBox",@"insertModeTitle",
                   MYINT(0xffffff),@"subTitleColor",
                   MYINT(100), @"lineHeight",
                   MYINT(66), @"topHeight",
                   MYINT(44), @"bottomHeight",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0xffffff),@"textColor2",
                   MYINT(0xffffff),@"bottomTextColor",
                   MYFONT(18),@"font2",
                   [UIColor blackColor],@"backgroundColor",
                   COLOR(135,149,176),@"textBackgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme2", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"mailboxes3" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   MYINT(TEXTROW_MAILBOX),@"mode",
                   @"account",@"icon",
                   MYRECTI(55, -38, -110, 35), @"bottomRect",
                   MYRECTI(6, 33,  70, 21),  @"leftBtnRect",
                   MYRECTI(-56, 33,  50, 21),  @"editRect",
                   MYRECTI(-30, -36, 23, 26), @"updateRect",
                   MYRECTI( 10, 66, 200, 22 ), @"subTitleRect",
                   @"", @"subTitle",
                   @"New MailBox",@"insertModeTitle",
                   MYINT(0xffffff),@"subTitleColor",
                   MYINT(1), @"hideBottomBar",
                   MYINT(100), @"lineHeight",
                   MYINT(66), @"topHeight",
                   MYINT(44), @"bottomHeight",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0xffffff),@"textColor2",
                   MYINT(0xffffff),@"bottomTextColor",
                   MYFONT(18),@"font2",
                   [UIColor blackColor],@"backgroundColor",
                   COLOR(135,149,176),@"textBackgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme3", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"mailboxes4" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
               BOLDFONT(24),@"font",
               MYINT(TEXTROW_MAILBOX),@"mode",
               @"account",@"icon",
               CENTER_RECTX(0, -38, 200, 35), @"bottomRect",
               MYRECTI(-60, 28, 51.5, 30),  @"editRect",
               MYINT(0xffffff),@"topButtonColor",
               MYINT(1), @"isImageTopBarButton",
               MYRECTI(-43, -35, 32, 32), @"updateRect",
               MYRECTI(10, -35, 32, 32),  @"refreshRect",
               MYRECTI( 10, 66, -120, 44 ), @"subTitleRect",
               @"", @"subTitle",
               @"New MailBox",@"insertModeTitle",
               MYRECTI(0,65,0,22), @"subTitleBarRect",
               COLOR(0xe0,0xe0,0xe0), @"subTitleBarColor",
               MYINT(0),@"subTitleColor",
               MYINT(100), @"lineHeight",
               MYINT(66), @"topHeight",
               MYINT(44), @"bottomHeight",
               MYINT(0x0),@"textColor",
               MYINT(0xffffff),@"titleColor",
               MYINT(0xffffff),@"textColor2",
               MYINT(0xffffff),@"bottomTextColor",
               MYFONT(14),@"font2",
               COLOR(135,149,176),@"textBackgroundColor",
               [UIColor whiteColor],@"backgroundColor",
               MYINT(true), @"hasOptions",
               @"theme4", @"theme",
               nil];
        }else if ( [ templateId isEqualToString: @"mailboxes5" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
               MYFONT(18),@"font",
               MYINT(TEXTROW_MAILBOX),@"mode",
               @"account",@"icon",
               @"New MailBox",@"insertModeTitle",
               MYRECTI(55, -38, -110, 35), @"bottomRect",
               MYRECTI(-58, 33,  52, 20),  @"editRect",
               MYRECTI(-40, -38, 36, 36), @"updateRect",
               MYRECTI( 10, 65, 200, 22 ), @"subTitleRect",
               MYRECTI(0,66,0,22), @"subTitleBarRect",
               COLOR(0xe0,0xe0,0xe0), @"subTitleBarColor",
               MYINT(100), @"lineHeight",
               MYINT(66), @"topHeight",
               MYINT(44), @"bottomHeight",
               MYINT(0x0),@"textColor",
               MYINT(0x0),@"titleColor",
               MYINT(0xa0a0a0),@"textColor2",
               MYINT(0x0),@"bottomTextColor",
               MYFONT(23),@"font2",
               [UIColor clearColor],@"textBackgroundColor",
               COLOR(248,248,248),@"backgroundColor",
               MYINT(true), @"hasOptions",
               @"theme5", @"theme",
               nil];
        }
        else if ( [ templateId isEqualToString: @"mailboxes6" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(18),@"font",
                   MYINT(TEXTROW_MAILBOX),@"mode",
                   @"account",@"icon",
                   @"New MailBox",@"insertModeTitle",
                   MYRECTI(55, -38, -110, 35), @"bottomRect",
                   MYRECTI(-58, 33,  52, 20),  @"editRect",
                   MYRECTI(-40, -38, 36, 36), @"updateRect",
                   MYRECTI( 10, 65, 200, 22 ), @"subTitleRect",
                   MYRECTI(0,66,0,22), @"subTitleBarRect",
                   COLOR(0xe0,0xe0,0xe0), @"subTitleBarColor",
                   MYINT(100), @"lineHeight",
                   MYINT(66), @"topHeight",
                   MYINT(44), @"bottomHeight",
                   MYINT(0x0),@"textColor",
                   MYINT(0x0),@"titleColor",
                   MYINT(0xa0a0a0),@"textColor2",
                   MYINT(0x0),@"bottomTextColor",
                   MYFONT(23),@"font2",
                   [UIColor clearColor],@"textBackgroundColor",
                   COLOR(248,248,248),@"backgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme6", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"mailboxes7" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(18),@"font",
                   MYINT(TEXTROW_MAILBOX),@"mode",
                   @"account",@"icon",
                   @"New MailBox",@"insertModeTitle",
                   MYRECTI(55, -38, -110, 35), @"bottomRect",
                   MYRECTI(-58, 28,  52, 28),  @"editRect",
                   MYRECTI(-40, -36, 30, 30), @"updateRect",
                   MYRECTI( 10, 65, 200, 44 ), @"subTitleRect",
                   MYRECTI(0,65,0,22), @"subTitleBarRect",
                   COLOR(0x0,0x0,0x0), @"subTitleBarColor",
                   MYINT(0xff0000),@"topButtonColor",
                   MYINT(100), @"lineHeight",
                   MYINT(66), @"topHeight",
                   MYINT(44), @"bottomHeight",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0xa0a0a0),@"textColor2",
                   MYINT(0xffffff),@"bottomTextColor",
                   MYFONT(23),@"font2",
                   [UIColor clearColor],@"textBackgroundColor",
                   COLOR(0,0,0),@"backgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme7", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"mailboxes8" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(18),@"font",
                   MYINT(TEXTROW_MAILBOX),@"mode",
                   @"account",@"icon",
                   @"New MailBox",@"insertModeTitle",
                   MYRECTI(55, -38, -110, 35), @"bottomRect",
                   MYRECTI(-45, 28,  40, 28),  @"editRect",
                   MYRECTI(-40, -36, 30, 30), @"updateRect",
                   MYRECTI( 10, 65, 200, 44 ), @"subTitleRect",
                   MYRECTI(0,65,0,22), @"subTitleBarRect",
                   COLOR(0x0,0x0,0x0), @"subTitleBarColor",
                   MYINT(100), @"lineHeight",
                   MYINT(66), @"topHeight",
                   MYINT(44), @"bottomHeight",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0xa0a0a0),@"textColor2",
                   MYINT(0xffffff),@"bottomTextColor",
                   MYFONT(23),@"font2",
                   [UIColor clearColor],@"textBackgroundColor",
                   COLOR(0,0,0),@"backgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme8", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"mailboxes9" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(18),@"font",
                   MYINT(TEXTROW_MAILBOX),@"mode",
                   @"account",@"icon",
                   @"New MailBox",@"insertModeTitle",
                   MYRECTI(55, -38, -110, 35), @"bottomRect",
                   MYRECTI(-58, 33,  52, 20),  @"editRect",
                   MYRECTI(-40, -38, 36, 36), @"updateRect",
                   MYRECTI( 10, 65, 200, 22 ), @"subTitleRect",
                   MYRECTI(0,66,0,22), @"subTitleBarRect",
                   COLOR(0xe0,0xe0,0xe0), @"subTitleBarColor",
                   MYINT(100), @"lineHeight",
                   MYINT(66), @"topHeight",
                   MYINT(44), @"bottomHeight",
                   MYINT(0x0),@"textColor",
                   MYINT(0x0),@"titleColor",
                   MYINT(0x7aff),@"topButtonColor",
                   MYINT(0xa0a0a0),@"textColor2",
                   MYINT(0x0),@"bottomTextColor",
                   MYFONT(17),@"font2",
                   [UIColor clearColor],@"textBackgroundColor",
                   COLOR(248,248,248),@"backgroundColor",
                   MYINT(true), @"hasOptions",
                   @"theme6", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"mailboxes10" ] )
        {
        }
        page = [[ CPageMailBox alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }
    else if( [ templateId hasPrefix: @"keypad" ] )
    {
        if ( [ templateId isEqualToString: @"keypad1" ] )
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   @"theme1", @"theme",
                   MYINT(0xffffff),@"textColor",
                   MYINT(68.5),@"bottomButtonSize",
                   MYINT(5),@"intervalH",
                   MYINT(12),@"keyNumb",
                   MYINT(80),@"ButtonSizeW",
                   MYINT(80),@"ButtonSizeH",
                   MYRECTI(20, -125, -40, 60 ), @"callRect",
                   [UIColor blackColor],@"backgroundColor",
                   nil];
        else if ( [ templateId isEqualToString: @"keypad2" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   MYINT(0xffffff),@"textColor",
                   MYINT(50),@"bottomButtonSize",
                   MYINT(5),@"intervalH",
                   MYINT(12),@"keyNumb",
                   MYINT(80),@"ButtonSizeW",
                   MYINT(80),@"ButtonSizeH",
                   MYRECT(130, -125, 60, 60 ), @"callRect",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme2", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"keypad3" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   MYINT(0xffffff),@"textColor",
                   MYINT(50),@"bottomButtonSize",
                   MYINT(5),@"intervalH",
                   MYINT(12),@"keyNumb",
                   MYINT(80),@"ButtonSizeW",
                   MYINT(80),@"ButtonSizeH",
                   MYRECT(20, -125, -40, 60 ), @"callRect",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme3", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"keypad4" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   MYINT(0xf4f4f4),@"textColor",
                   MYINT(60),@"bottomButtonSize",
                   MYINT(0),@"intervalH",
                   MYINT(15),@"keyNumb",
                   MYINT(106),@"ButtonSizeW",
                   MYINT(67),@"ButtonSizeH",
                   [UIColor whiteColor],@"backgroundColor",
                   COLOR(57,57,57),@"phoneShownBackground",
                   @"theme4", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"keypad5" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   MYINT(0x555555),@"textColor",
                   MYINT(50),@"bottomButtonSize",
                   MYINT(5),@"intervalH",
                   MYINT(12),@"keyNumb",
                   MYINT(68),@"ButtonSizeW",
                   MYINT(68),@"ButtonSizeH",
                   MYRECT(126, -150, 68, 68 ), @"callRect",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme5", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"keypad6" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   MYINT(0x555555),@"textColor",
                   MYINT(50),@"bottomButtonSize",
                   MYINT(5),@"intervalH",
                   MYINT(12),@"keyNumb",
                   MYINT(68),@"ButtonSizeW",
                   MYINT(68),@"ButtonSizeH",
                   MYRECT(126, -150, 68, 68 ), @"callRect",
                   MYRECTI(-31,50,21,17), @"backArrowRect",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme6", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"keypad7" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   MYINT(0xffffff),@"textColor",
                   MYINT(50),@"bottomButtonSize",
                   MYINT(70),@"bottomButtonSizeH",
                   MYINT(5),@"intervalH",
                   MYINT(12),@"keyNumb",
                   MYINT(6),@"bottomMarginH",
                   MYINT(55),@"ButtonSizeW",
                   MYINT(80),@"ButtonSizeH",
                   MYRECT(126, -165, 68, 68 ), @"callRect",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme7", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"keypad8" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   MYINT(0xffffff),@"textColor",
                   MYINT(50),@"bottomButtonSize",
                   MYINT(70),@"bottomButtonSizeH",
                   MYINT(5),@"intervalH",
                   MYINT(12),@"keyNumb",
                   MYINT(6),@"bottomMarginH",
                   MYINT(55),@"ButtonSizeW",
                   MYINT(80),@"ButtonSizeH",
                   MYRECT(126, -160, 62, 62 ), @"callRect",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme8", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"keypad9" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   MYINT(0x555555),@"textColor",
                   MYINT(50),@"bottomButtonSize",
                   MYINT(5),@"intervalH",
                   MYINT(12),@"keyNumb",
                   MYINT(68),@"ButtonSizeW",
                   MYINT(68),@"ButtonSizeH",
                   MYRECT(126, -150, 68, 68 ), @"callRect",
                   MYRECTI(-31,50,21,17), @"backArrowRect",
                   [UIColor blackColor],@"backgroundColor",
                   @"theme6", @"theme",
                   nil];
        }else if ( [ templateId isEqualToString: @"keypad10" ] )
        {
        }
        page = [[ CPageKeypad alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }
    else if( [ templateId hasPrefix: @"favorites" ] )
    {
        if ( [ templateId isEqualToString: @"favorites1" ] )
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   @"theme1", @"theme",
                   @"Edit", @"leftButtonText",
                   @"New Contact", @"insertModeTitle",
                   MYRECTI(10,26,80,34), @"leftButtonRect",
                   MYINT(59.5),@"bottomButtonSize",
                   COLOR(0xd2, 0x48, 0x48), @"bottomBarColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0xffffff),@"textColor",
                   [UIColor blackColor],@"backgroundColor",
                   COLOR(51, 51, 51), @"dividerColor",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   MYRECTI(-37, 27, 28, 28),@"addRect",
                   MYINT(TEXTROW_FAVORITES),@"mode",
                   MYINT(true), @"hasOptions",
                   nil];
        else if ( [ templateId isEqualToString: @"favorites2" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   @"theme2", @"theme",
                   @"Edit", @"leftButtonText",
                   @"New Contact", @"insertModeTitle",
                   MYRECTI(10,26,80,34), @"leftButtonRect",
                   @"background",@"tableBackground",
                   MYINT(50),@"bottomButtonSize",
                   COLOR(31, 28, 39), @"bottomBarColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0xffffff),@"textColor",
                   [UIColor blackColor],@"backgroundColor",
                   COLOR(51, 51, 51), @"dividerColor",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   MYRECTI(-37, 27, 28, 28),@"addRect",
                   MYINT(TEXTROW_FAVORITES),@"mode",
                   MYINT(true), @"hasOptions",
                   nil];
        }else if ( [ templateId isEqualToString: @"favorites3" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   @"theme3", @"theme",
                   @"Edit", @"leftButtonText",
                   @"New Contact", @"insertModeTitle",
                   MYRECTI(10,26,80,34), @"leftButtonRect",
                   MYINT(50),@"bottomButtonSize",
                   COLOR(31, 28, 39), @"bottomBarColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0xffffff),@"textColor",
                   [UIColor blackColor],@"backgroundColor",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   MYRECTI(-37, 27, 28, 28),@"addRect",
                   MYINT(TEXTROW_FAVORITES),@"mode",
                   MYINT(true), @"hasOptions",
                   nil];
        }else if ( [ templateId isEqualToString: @"favorites4" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   @"theme4", @"theme",
                   @"edit", @"leftButtonImage",
                   @"New Contact", @"insertModeTitle",
                   MYRECTI(5,26,60,34), @"leftButtonRect",
                   MYINT(60),@"bottomButtonSize",
                   COLOR(31, 28, 39), @"bottomBarColor",
                   COLOR(224, 224, 224), @"dividerColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0),@"textColor",
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   MYRECTI(-38, 28, 30, 30),@"addRect",
                   MYINT(TEXTROW_FAVORITES),@"mode",
                   MYINT(true), @"hasOptions",
                   nil];
        }else if ( [ templateId isEqualToString: @"favorites5" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   @"theme5", @"theme",
                   @"Edit", @"leftButtonText",
                   @"New Contact", @"insertModeTitle",
                   COLOR(12, 117, 234), @"leftButtonColor",
                   MYRECTI(10,26,80,34), @"leftButtonRect",
                   MYINT(50),@"bottomButtonSize",
                   COLOR(200, 200, 200), @"dividerColor",
                   MYINT(0),@"titleColor",
                   MYINT(0),@"textColor",
                   MYINT(1),@"roundIcon",
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   MYRECTI(-38, 28, 28, 28),@"addRect",
                   MYINT(TEXTROW_FAVORITES),@"mode",
                   MYINT(true), @"hasOptions",
                   nil];
        }
        else if ( [ templateId isEqualToString: @"favorites6" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   @"theme6", @"theme",
                   @"Edit", @"leftButtonText",
                   @"New Contact", @"insertModeTitle",
                   COLOR(12, 117, 234), @"leftButtonColor",
                   MYRECTI(10,26,80,34), @"leftButtonRect",
                   MYINT(50),@"bottomButtonSize",
                   COLOR(200, 200, 200), @"dividerColor",
                   MYINT(0),@"titleColor",
                   MYINT(0),@"textColor",
                   MYINT(1),@"roundIcon",
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   MYRECTI(-38, 28, 28, 28),@"addRect",
                   MYINT(TEXTROW_FAVORITES),@"mode",
                   MYINT(true), @"hasOptions",
                   nil];
        }
        else if ( [ templateId isEqualToString: @"favorites7" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   @"theme7", @"theme",
                   @"Edit", @"leftButtonText",
                   @"New Contact", @"insertModeTitle",
                   COLOR(0xff, 0, 0), @"leftButtonColor",
                   MYRECTI(10,26,80,34), @"leftButtonRect",
                   MYINT(50),@"bottomButtonSize",
                   MYINT(70),@"bottomButtonSizeH",
                   MYINT(6),@"bottomMarginH",
                   COLOR(50, 50, 50), @"dividerColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0xffffff),@"textColor",
                   [UIColor blackColor],@"backgroundColor",
                   MYINT(44), @"topHeight",
                   MYINT(76), @"bottomHeight",
                   MYRECTI(-38, 28, 28, 28),@"addRect",
                   MYINT(TEXTROW_FAVORITES),@"mode",
                   MYINT(true), @"hasOptions",
                   nil];
        }else if ( [ templateId isEqualToString: @"favorites8" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   @"theme8", @"theme",
                   @"Edit", @"leftButtonText",
                   @"New Contact", @"insertModeTitle",
                   COLOR(0xf3, 0xfd, 0xbe), @"leftButtonColor",
                   MYRECTI(10,26,80,34), @"leftButtonRect",
                   MYINT(50),@"bottomButtonSize",
                   MYINT(70),@"bottomButtonSizeH",
                   MYINT(6),@"bottomMarginH",
                   COLOR(50, 50, 50), @"dividerColor",
                   MYINT(0xffffff),@"titleColor",
                   MYINT(0xffffff),@"textColor",
                   [UIColor blackColor],@"backgroundColor",
                   MYINT(44), @"topHeight",
                   MYINT(76), @"bottomHeight",
                   MYRECTI(-34, 28, 28, 28),@"addRect",
                   MYINT(TEXTROW_FAVORITES),@"mode",
                   MYINT(true), @"hasOptions",
                   nil];
        }else if ( [ templateId isEqualToString: @"favorites9" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(22),@"font",
                   @"theme6", @"theme",
                   @"Edit", @"leftButtonText",
                   @"New Contact", @"insertModeTitle",
                   COLOR(12, 117, 234), @"leftButtonColor",
                   MYRECTI(10,26,80,34), @"leftButtonRect",
                   MYINT(50),@"bottomButtonSize",
                   COLOR(200, 200, 200), @"dividerColor",
                   MYINT(0),@"titleColor",
                   MYINT(0),@"textColor",
                   MYINT(1),@"roundIcon",
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(44), @"topHeight",
                   MYINT(40), @"bottomHeight",
                   MYRECTI(-32, 31, 22, 22),@"addRect",
                   MYINT(TEXTROW_FAVORITES),@"mode",
                   MYINT(true), @"hasOptions",
                   nil];
        }else if ( [ templateId isEqualToString: @"favorites10" ] )
        {
        }
        page = [[ CPageFavorites alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }
    else if( [ templateId hasPrefix: @"home" ] )
    {
       if( [ templateId isEqualToString: @"home1" ] )
       {
           dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                  MYFONT(14),@"font",
                  [UIColor whiteColor],@"backgroundColor",
                  COLOR(0x93,0x2a,0x27), @"bottomBarColor",
                  MYINT(62),@"bottomButtonSizeW",
                  MYINT(62),@"bottomButtonSizeH",
                  MYINT(40),@"intervalH",
                  MYINT(62),@"ButtonSizeW",
                  MYINT(61),@"ButtonSizeH",
                  @"theme1", @"theme",
                  MYINT(true), @"hasOptions",
                  nil];
       }else if( [ templateId isEqualToString: @"home2" ] )
       {
           dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                  MYFONT(14),@"font",
                  [UIColor whiteColor],@"backgroundColor",
                  COLOR(0x28,0x23,0x2a), @"bottomBarColor",
                  MYINT(62),@"bottomButtonSizeW",
                  MYINT(54),@"bottomButtonSizeH",
                  MYINT(40),@"intervalH",
                  MYINT(62),@"ButtonSizeW",
                  MYINT(54),@"ButtonSizeH",
                  @"theme2", @"theme",
                  MYINT(true), @"hasOptions",
                  nil];
       }else if( [ templateId isEqualToString: @"home3" ] )
       {
           dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                  MYFONT(14),@"font",
                  [UIColor whiteColor],@"backgroundColor",
                  COLOR(0x29,0x29,0x29), @"bottomBarColor",
                  MYINT(62),@"bottomButtonSizeW",
                  MYINT(62),@"bottomButtonSizeH",
                  MYINT(40),@"intervalH",
                  MYINT(62),@"ButtonSizeW",
                  MYINT(61),@"ButtonSizeH",
                  MYINT(true), @"hasOptions",
                  @"theme3", @"theme",
                  nil];
       }else if( [ templateId isEqualToString: @"home4" ] )
       {
           dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                  MYFONT(14),@"font",
                  [UIColor whiteColor],@"backgroundColor",
                  MYINT(62),@"bottomButtonSizeW",
                  MYINT(62),@"bottomButtonSizeH",
                  MYINT(40),@"intervalH",
                  MYINT(62),@"ButtonSizeW",
                  MYINT(61),@"ButtonSizeH",
                  MYINT(true), @"hasOptions",
                  @"theme4", @"theme",
                  nil];
       }else if( [ templateId isEqualToString: @"home5" ] )
       {
           dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                  MYFONT(14),@"font",
                  [UIColor whiteColor],@"backgroundColor",
                  MYINT(62),@"bottomButtonSizeW",
                  MYINT(62),@"bottomButtonSizeH",
                  MYINT(40),@"intervalH",
                  MYINT(62),@"ButtonSizeW",
                  MYINT(61),@"ButtonSizeH",
                  MYINT(true), @"hasOptions",
                  @"theme5", @"theme",
                  nil];
        }else if( [ templateId isEqualToString: @"home6" ] )
        {
           dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
               MYFONT(14),@"font",
               [UIColor whiteColor],@"backgroundColor",
               MYINT(62),@"bottomButtonSizeW",
               MYINT(62),@"bottomButtonSizeH",
               MYINT(40),@"intervalH",
               MYINT(62),@"ButtonSizeW",
               MYINT(62),@"ButtonSizeH",
               MYINT(true), @"hasOptions",
               @"theme6", @"theme",
               nil];
        }else if( [ templateId isEqualToString: @"home7" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(14),@"font",
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(62),@"bottomButtonSizeW",
                   MYINT(62),@"bottomButtonSizeH",
                   MYINT(40),@"intervalH",
                   MYINT(60),@"ButtonSizeW",
                   MYINT(76),@"ButtonSizeH",
                   MYINT(true), @"hasOptions",
                   @"theme7", @"theme",
                   nil];
        }else if( [ templateId isEqualToString: @"home8" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(14),@"font",
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(62),@"bottomButtonSizeW",
                   MYINT(62),@"bottomButtonSizeH",
                   MYINT(40),@"intervalH",
                   MYINT(60),@"ButtonSizeW",
                   MYINT(71),@"ButtonSizeH",
                   MYINT(true), @"hasOptions",
                   @"theme8", @"theme",
                   nil];
        }else if( [ templateId isEqualToString: @"home9" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(14),@"font",
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(62),@"bottomButtonSizeW",
                   MYINT(62),@"bottomButtonSizeH",
                   MYINT(40),@"intervalH",
                   MYINT(48),@"ButtonSizeW",
                   MYINT(48),@"ButtonSizeH",
                   MYINT(true), @"hasOptions",
                   @"theme9", @"theme",
                   nil];
        }else if( [ templateId isEqualToString: @"home10" ] )
        {
        }
        page = [[ CPageHome alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }
    else if( [ templateId hasPrefix: @"alert" ] )
    {
        if( [ templateId isEqualToString: @"alert1" ] )
        {
            CRect * mainRect = CENTER_RECTI(0, 0, 300, 260);
            CRect * btn1Rect = MYRECTI( 10, -65, 135,  50 );
            CRect * btn2Rect = MYRECTI( 155, -65, 135, 50 );
        
            if ( [ Utils isIPad ] )
            {
                mainRect = CENTER_RECTI(0, 0, 380, 280);
                btn1Rect = MYRECTI( 20, -65, 135,  50 );
                btn2Rect = MYRECTI( 225, -65, 135, 50 );
            }
                
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   MYFONT(20),@"btnTextFont",
                   BOLDFONT(20),@"titleFont",
                   [UIColor clearColor],@"backgroundColor",
                   MYINT(0),@"textColor",
                   MYINT(0xffffff),@"buttonTextColor",
                   mainRect,@"rect",
                   @"My title", @"title",
                   @"Tap here to edit text.", @"body",
                   @"Cancel", @"btnText1",
                   @"OK", @"btnText2",
                   MYRECTI( 0, 0, 0, 44), @"titleRect",
                   btn1Rect,@"btnRect1",
                   btn2Rect,@"btnRect2",
                   @"theme1", @"theme",
                   nil];
            
        }else if( [ templateId isEqualToString: @"alert2" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(17),@"font",
                   MYFONT(17),@"btnTextFont",
                   BOLDFONT(17),@"titleFont",
                   [UIColor clearColor],@"backgroundColor",
                   MYINT(0),@"textColor",
                   MYINT(0),@"buttonTextColor",
                   MYRECTI( 30, 40, 30, 55 ), @"backgroundInsets",
                   MYRECTI( 30, 32, -60, 70 ), @"bodyRect",
                   CENTER_RECTI(0, 0, 280, 148), @"rect",
                   @"My title", @"title",
                   @"Tap here to edit text.", @"body",
                   @"OK", @"btnText1",
                   @"Cancel", @"btnText2",
                   MYRECTI( 0, 0, 0, 36),  @"titleRect",
                   MYRECTI( 30, -42, 100, 40 ), @"btnRect1",
                   MYRECTI( 150, -42, 100, 40 ), @"btnRect2",
                   @"theme2", @"theme",
                   nil];
        }else if( [ templateId isEqualToString: @"alert3" ] )
        {
            CRect * mainRect = CENTER_RECTI(0, 0, 235, 162.5);
            CRect * btn1Rect = MYRECTI( 10, -35, 117,  34 );
            CRect * btn2Rect = MYRECTI( -127, -35, 117,  34 );
            
            if ( [ Utils isIPad ] )
            {
                mainRect = CENTER_RECTI(0, 0, 360, 250);
                btn1Rect = MYRECTI( 10, -35, 160,  34 );
                btn2Rect = MYRECTI( -170, -35, 160,  34 );
            }
            
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYFONT(17),@"btnTextFont",
                   BOLDFONT(16),@"titleFont",
                   [UIColor clearColor],@"backgroundColor",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"buttonTextColor",
                   //[UIColor whiteColor],@"screenBackgroundColor",
                   mainRect, @"rect",
                   MYRECTI( 0, 0, 0, 44), @"titleRect",
                   MYRECTI( 5, 5, 5, 45 ), @"backgroundInsets",
                   @"My title", @"title",
                   @"Tap here to edit text.", @"body",
                   @"OK", @"btnText1",
                   @"Cancel", @"btnText2",
                   btn1Rect, @"btnRect1",
                   btn2Rect, @"btnRect2",
                   @"theme3", @"theme",
                   nil];
        }else if( [ templateId isEqualToString: @"alert4" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(20),@"font",
                   MYFONT(20),@"btnTextFont",
                   BOLDFONT(20),@"titleFont",
                   [UIColor clearColor],@"backgroundColor",
                   MYINT(0xffffff),@"textColor",
                   MYINT(0xffffff),@"buttonTextColor",
                   CENTER_RECTI(0, 0, 300, 240), @"rect",
                   MYRECTI( 0, 0, 0, 44), @"titleRect",
                   @"My title", @"title",
                   @"Tap here to edit text.", @"body",
                   @"OK", @"btnText1",
                   @"Cancel", @"btnText2",
                   MYRECTI( 15, -58, 130,  42.5 ), @"btnRect1",
                   MYRECTI( 155, -58, 130,  42.5 ), @"btnRect2",
                   @"theme4", @"theme",
                   nil];
        }else if( [ templateId isEqualToString: @"alert5" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYFONT(20),@"btnTextFont",
                   BOLDFONT(20),@"titleFont",
                   [UIColor clearColor],@"backgroundColor",
                   MYINT(0),@"textColor",
                   MYINT(0x0079ff),@"buttonTextColor",
                   CENTER_RECTI(0, 0, 280, 130), @"rect",
                   MYRECTI( 0, 0, 0, 44), @"titleRect",
                   MYRECTI( 5, 50, 5, 48 ), @"backgroundInsets",
                   @"My title", @"title",
                   @"Tap here to edit text.", @"body",
                   @"Cancel", @"btnText1",
                   @"OK", @"btnText2",
                   MYRECTI( 15, -45, 120,  44 ), @"btnRect1",
                   MYRECTI( 145, -45, 120,  44 ), @"btnRect2",
                   @"theme5", @"theme",
                   nil];
        }else if( [ templateId isEqualToString: @"alert6" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYFONT(20),@"btnTextFont",
                   BOLDFONT(20),@"titleFont",
                   [UIColor clearColor],@"backgroundColor",
                   MYINT(0),@"textColor",
                   MYINT(0x0079ff),@"buttonTextColor",
                   CENTER_RECTI(0, 0, 280, 140), @"rect",
                   MYRECTI( 0, 0, 0, 44), @"titleRect",
                   MYRECTI( 5, 50, 5, 48 ), @"backgroundInsets",
                   @"My title", @"title",
                   @"Tap here to edit text.", @"body",
                   @"Cancel", @"btnText1",
                   @"OK", @"btnText2",
                   MYRECTI( 15, -45, 120,  44 ), @"btnRect1",
                   MYRECTI( 145, -45, 120,  44 ), @"btnRect2",
                   @"theme6", @"theme",
                   nil];
        }else if( [ templateId isEqualToString: @"alert7" ] )
        {
            int offIcon = ( [ Utils getScreenSize ].width > 320 )? -20: -12;
            int rectW =  ( [ Utils getScreenSize ].width > 320 )? 320: 280;
            
            CRect * iconRect = MYRECTI( offIcon, 24, 24, 24);
            iconRect._bMinusPos = true;
            
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYFONT(20),@"btnTextFont",
                   BOLDFONT(20),@"titleFont",
                   [UIColor clearColor],@"backgroundColor",
                   MYINT(0xffffff),@"textColor",
                   CENTER_RECTI(0, 0, rectW, 88), @"rect",
                   iconRect, @"iconRect",
                   @"My title", @"title",
                   @"Tap here to edit text.", @"body",
                   @"theme7", @"theme",
                   nil];
        }else if( [ templateId isEqualToString: @"alert8" ] )
        {
            int offIcon = ( [ Utils getScreenSize ].width > 320 )? -20: -12;
            int rectW =  ( [ Utils getScreenSize ].width > 320 )? 320: 280;
            
            CRect * iconRect = MYRECTI( offIcon, 24, 24, 24);
            iconRect._bMinusPos = true;
            
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYFONT(20),@"btnTextFont",
                   BOLDFONT(20),@"titleFont",
                   [UIColor clearColor],@"backgroundColor",
                   MYINT(0xffffff),@"textColor",
                   CENTER_RECTI(0, 0, rectW, 88), @"rect",
                   iconRect, @"iconRect",
                   @"My title", @"title",
                   @"Tap here to edit text.", @"body",
                   @"theme8", @"theme",
                   nil];
        }else if( [ templateId isEqualToString: @"alert9" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   MYFONT(15),@"font",
                   MYFONT(20),@"btnTextFont",
                   BOLDFONT(20),@"titleFont",
                   [UIColor clearColor],@"backgroundColor",
                   MYINT(0),@"textColor",
                   MYINT(0x0079ff),@"buttonTextColor",
                   CENTER_RECTI(0, 0, 280, 140), @"rect",
                   MYRECTI( 0, 0, 0, 44), @"titleRect",
                   MYRECTI( 5, 50, 5, 48 ), @"backgroundInsets",
                   @"My title", @"title",
                   @"Tap here to edit text.", @"body",
                   @"Cancel", @"btnText1",
                   @"OK", @"btnText2",
                   MYRECTI( 15, -45, 120,  44 ), @"btnRect1",
                   MYRECTI( 145, -45, 120,  44 ), @"btnRect2",
                   @"theme9", @"theme",
                   nil];
        }else if( [ templateId isEqualToString: @"alert10" ] )
        {
        }
        CDialog * dialog = [[ CDialog alloc ] initWithTemplate: templateId container:nil params: dic ];
        page = [[ CPageAlert alloc ] initWithTemplate:templateId delegate:delegate alert:dialog flashFreq: 0.0 params: dic ];
        page._topBar._hidden = true;
    }
    else if( [ templateId hasPrefix:@"camera" ] )
    {
        CRect * iconRect = MYRECTI( 0, 0, 45, 45);
        
        if( [ templateId isEqualToString: @"camera2" ] )
        {
            iconRect = MYRECTI( 0, 0, 66, 40 );
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
               @"theme3", @"theme",
               iconRect, @"iconRect",
               nil];
        }else if( [ templateId isEqualToString: @"camera8" ] )
        {
            iconRect = MYRECTI( 0, 0, 56, 33 );
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   @"theme3", @"theme",
                   iconRect, @"iconRect",
                   nil];
        }else {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   @"theme3", @"theme",
                   iconRect, @"iconRect",
                   nil];
        }
        page = [[ CPageCamera alloc ] initWithTemplate:templateId delegate:delegate params:dic ];
    }
    else if( [ templateId isEqualToString: @"access_deny1" ] )
    {
        dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
               MYFONT(14),@"font",
               [UIColor whiteColor],@"backgroundColor",
               MYINT(0xffffff),@"textColor",
               CENTER_RECT(0, 0, 200, 100), @"rect",
               @"Access Deny", @"body",
               nil];
        
        CDialog * dialog = [[ CDialog alloc ] initWithTemplate: templateId container:nil params: dic ];
        dialog._flashFreq = 0.5;
        
        CPageAlert * mpage = [[ CPageAlert alloc ] initWithTemplate:@"popup_effect1" delegate:delegate alert:dialog flashFreq: 0.5 params: nil ];
        page = mpage;
    }
    else if( [ templateId hasPrefix: @"chrome_key" ] )
    {
        int color = 0x00ff00;
        
        if( [ templateId isEqualToString: @"chrome_key1" ] )
            color = 0x00ff00;
        else if( [ templateId isEqualToString: @"chrome_key2" ] )
            color = 0x000000;
        else if( [ templateId isEqualToString: @"chrome_key3" ] )
            color = 0xff0000;
        
        dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
               MYINT(color), @"backgroundColor",
               nil];
        page = [[ CPageChromeKey alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }
    else if( [ templateId isEqualToString: @"video_player1" ] )
    {
        dic = [ [ NSDictionary alloc ] init ];
        page = [[ CPageVideoPlayer alloc ] initWithTemplate:templateId delegate:delegate params:dic ];
    }
    else if( [ templateId isEqualToString: @"scrolling" ] )
    {
        dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
               MYFONT(14),@"font",
               MYINT(true), @"hasOptions",
               @"theme3", @"theme",
               nil];
        page = [[ CPageScrolling alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }
    else if( [ templateId isEqualToString: @"social" ] )
    {
        dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
               MYFONT(14),@"font",
               MYINT(true), @"hasOptions",
               @"theme4", @"theme",
               nil];
        page = [[ CPageSocialMedia alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }
    else if( [ templateId isEqualToString: @"gallery" ] )
    {
        dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
               MYFONT(14),@"font",
               MYINT(true), @"hasOptions",
               @"theme4", @"theme",
               nil];
        page = [[ CPageGallery alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }
    else if( [ templateId isEqualToString: @"custom" ] )
    {
        dic = [[ NSDictionary alloc ] init];
        page = [[ CPageCustom alloc ] initWithTemplate:templateId delegate:delegate params:dic ];
    }
    else if( [ templateId hasPrefix: @"face_time" ] )
    {
        if( [ templateId isEqualToString: @"face_time1" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(50),@"ButtonSizeW",
                   MYINT(50),@"ButtonSizeH",
                   @"theme1", @"theme",
                   nil];
        } else if( [ templateId isEqualToString: @"face_time2" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(60),@"ButtonSizeW",
                   MYINT(38),@"ButtonSizeH",
                   @"theme2", @"theme",
                   nil];
        } else if( [ templateId isEqualToString: @"face_time3" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(50),@"ButtonSizeW",
                   MYINT(50),@"ButtonSizeH",
                   @"theme3", @"theme",
                   nil];
        } else if( [ templateId isEqualToString: @"face_time7" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(50),@"ButtonSizeW",
                   MYINT(50),@"ButtonSizeH",
                   @"theme7", @"theme",
                   nil];
        }else if( [ templateId isEqualToString: @"face_time8" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(60),@"ButtonSizeW",
                   MYINT(36),@"ButtonSizeH",
                   @"theme8", @"theme",
                   nil];
        }else if( [ templateId isEqualToString: @"face_time9" ] )
        {
            dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
                   [UIColor whiteColor],@"backgroundColor",
                   MYINT(50),@"ButtonSizeW",
                   MYINT(50),@"ButtonSizeH",
                   @"theme9", @"theme",
                   nil];
        }
        page = [[ CPageFaceTime alloc ] initWithTemplate:templateId delegate: delegate params:dic ];
    }
    else if( [ templateId hasPrefix: @"scanner" ] )
    {
        dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
               MYFONT(15),@"font",
               MYFONT(20),@"btnTextFont",
               BOLDFONT(20),@"titleFont",
               [UIColor clearColor],@"backgroundColor",
               MYINT(0xffffff),@"textColor",
               MYRECTI( 0, 300, 0, -300), @"bottomRect",
               MYRECTI( 0, 22, 0, 50), @"titleRect",
               @"theme8", @"theme",
               @"My title", @"title",
               nil];
        page = [[ CPageScanner alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }else if( [ templateId hasPrefix: @"unlock" ] )
    {
        dic = [[ NSDictionary alloc ] initWithObjectsAndKeys:
               MYFONT(15),@"sliderFont",
               BOLDFONT(36),@"timerFont",
               [UIColor clearColor],@"backgroundColor",
               MYINT(0xffffff),@"textColor",
               MYRECTI( 0, 100, 0, 100), @"timerRect",
               MYRECTI( 0, -100, 0, 50), @"sliderRect",
               @"theme9", @"theme",
               @"My title", @"title",
               nil];
        page = [[ CPageLocker alloc ] initWithTemplate:templateId delegate:delegate params: dic ];
    }
    return page;
}

/*
static NSString * s_pageNames[][7] = {
    { @"scanner", @"scanner", @"access_deny" },
    { @"incoming_call", @"incoming_call", @"outgoing_call", @"home" },
    { @"outgoing_call", @"all_contacts", @"outgoing_call" },
    { @"alert", @"home", @"alert" },
    { @"compose_email", @"all_contacts", @"compose_email", @"home" },
    nil,
}; */

/*-(bool) isTemplateMatched: (NSString *) template1 template2: (NSString *) template2
{
    NSString * sLast = [ template2 substringFromIndex: template2.length - 1 ];
    if ([[NSScanner scannerWithString: sLast] scanInt:nil])
    {
        return [ template1 isEqualToString: template2 ];
    }
    
    NSString * s2 = [ template2 substringToIndex: template2.length - 1 ];
    NSString * s1 = [ template1 substringToIndex: template1.length - 1 ];
    
    return [ s1 isEqualToString: s2 ];
}*/

-(CScene *) createSceneByTemplate: (NSString *) templateId delegate:(id) delegate
{
 /*   NSString * sOrder = [ templateId substringFromIndex: templateId.length - 1 ];
    
    int theme = sOrder.intValue;
    NSString * template = [ templateId substringToIndex: templateId.length - 1 ];
    
    for( int s = 0; ; s++ )
    {
        NSString * pageName = s_pageNames[s][0];
        if( pageName == nil )
            break;
        
        if( [ pageName isEqualToString: template ] )
        {
            NSMutableArray * arr = [[ NSMutableArray alloc ] init ];
            bool keyPageAtBeginning = [ pageName isEqualToString: s_pageNames[s][1] ];
            
            for( int j=1; ;j++ )
            {
                if( s_pageNames[s][j] == nil )
                    break;
                
                [ arr addObject: s_pageNames[s][j] ];
            }
            return [[ CScene alloc ] initWithPages: arr delegate: delegate theme: theme keyPageAtBeginning:keyPageAtBeginning ];
        }
    } */
    
    CPage * page = [ self createPageByTemplate: templateId delegate:delegate ];
    CScene * scene = [[ CScene alloc ] initWithPage:page ];
    
    if ( [ templateId hasPrefix:@"outgoing_call" ] )
        scene._keyPageAtBeginning = false;
    
    return scene;
}

-(NSMutableArray *) addGroup: (NSString *) name
{
    NSMutableArray * group = [[ NSMutableArray alloc ] init ];
    
    [ _groupNames addObject: name ];
    [ _groups addObject: group ];
    
    return group;
}

-(CSceneTemplate * )getTemplateByGroupIndex: (NSArray *) group index: (int) index
{
    for( CSceneTemplate * tmp in group )
    {
        NSString * sOrder = [ tmp._ID substringFromIndex: tmp._ID.length - 1 ];
        if( sOrder.intValue == index )
            return tmp;
    }
    return group[0];
}

-(NSArray *) getRelativeTemplate: (NSString *) templateName themeId: (int) themeId before: (BOOL) before
{
    NSMutableArray * relatives = [[ NSMutableArray alloc ] init ];
    
    if ( [ templateName hasPrefix: @"scanner"  ] )
    {
        CSceneTemplate * st = [[ CSceneTemplate alloc ] initWithNameIndex: @"Scanner Granted" ID: @"scanner_granted" index: themeId ];
        
        [ relatives addObject: st ];
        st = [[ CSceneTemplate alloc ] initWithNameIndex: @"Scanner Denied" ID: @"scanner_denied" index: themeId ];
        [ relatives addObject: st ];
    } else if ( [ templateName isEqualToString:@"social" ] ) {
        themeId = 3;
    }
    
    [ self addRelativeTemplates: themeId relatives: relatives ];
    
    CSceneTemplate * st;
    
    st = [[ CSceneTemplate alloc ] initWithName: @"Chroma Key" ID: @"chrome_key1" ];
    [ relatives addObject: st ];

    st = [[ CSceneTemplate alloc ] initWithName: @"Chroma Key" ID: @"chrome_key2" ];
    [ relatives addObject: st ];
    
    st = [[ CSceneTemplate alloc ] initWithName: @"Chroma Key" ID: @"chrome_key3" ];
    [ relatives addObject: st ];
    
    [self reOrderRelativeTemplates:templateName before:before relatives:relatives ];

    //[ self addNoneRelativeTemplates:ord relatives:relatives ];
    
    return relatives;
}

-(void) addRelativeTemplates: (int) ord relatives: (NSMutableArray *) relatives
{
    CSceneTemplate * st = [[ CSceneTemplate alloc ] initWithNameIndex: @"Home" ID: @"home" index: ord];
    [ relatives addObject: st ];
    
    st = [[ CSceneTemplate alloc ] initWithNameIndex: @"All Contacts" ID: @"all_contacts" index: ord];
    [ relatives addObject: st ];
    
    st = [[ CSceneTemplate alloc ] initWithNameIndex: @"Keypad" ID: @"keypad" index: ord ];
    [ relatives addObject: st ];
    
    st = [[ CSceneTemplate alloc ] initWithNameIndex: @"Favorites" ID: @"favorites" index: ord ];
    [ relatives addObject: st ];
    
    st = [[ CSceneTemplate alloc ] initWithNameIndex: @"MailBox" ID: @"mailboxes" index: ord ];
    [ relatives addObject: st ];
    
    for( NSArray * ts in _groups )
    {
        CSceneTemplate * tmp = [ self getTemplateByGroupIndex: ts index: ord ];
        if( [ tmp._name isEqualToString: @"Video Player" ] || [ tmp._name isEqualToString: @"Scanner" ] || [ tmp._ID hasPrefix:@"chrome_key" ]  )
            continue;
        
        [ relatives addObject: tmp ];
    }
}

-(void) addNoneRelativeTemplates: (int) ord relatives: (NSMutableArray *) relatives
{
    [ self addGroupNoneRelativeTemplate: ord relatives:relatives templateName:@"Home" templateId:@"home" ];

    [ self addGroupNoneRelativeTemplate: ord relatives:relatives templateName:@"All Contacts" templateId:@"all_contacts" ];
    
    [ self addGroupNoneRelativeTemplate: ord relatives:relatives templateName:@"Keypad" templateId:@"keypad" ];

    [ self addGroupNoneRelativeTemplate: ord relatives:relatives templateName:@"Favorites" templateId:@"favorites" ];
    
    [ self addGroupNoneRelativeTemplate: ord relatives:relatives templateName:@"MailBox" templateId:@"mailboxes" ];

    for( NSArray * ts in _groups )
    {
        for(int i=1; i <= THEME_NUMB; i++ )
        {
            if( i == ord )
                continue;
            
            CSceneTemplate * tmp = [ self getTemplateByGroupIndex: ts index: i ];
            if( [ tmp._name isEqualToString: @"Video Player" ] || [ tmp._name isEqualToString: @"Scanner" ] || [ tmp._ID hasPrefix:@"chrome_key" ]
                             || [ tmp._ID hasPrefix:@"camera" ]
                             || [ tmp._ID hasPrefix:@"social" ]
                             || [ tmp._ID hasPrefix:@"custom" ]
               )
                continue;
            
            [ relatives addObject: tmp ];
        }
    }
}

-(void) addGroupNoneRelativeTemplate: (int) ord relatives: (NSMutableArray *) relatives templateName: (NSString *) templateName templateId: (NSString *) templateId
{
    int themeNumb = THEME_NUMB;
    
    for(int i=1; i <= themeNumb; i++ )
    {
        if( i != ord ) {
            CSceneTemplate * st = [[ CSceneTemplate alloc ] initWithNameIndex: templateName ID: templateId index: i ];
            [ relatives addObject: st ];
        }
    }
}

-(NSArray *) reOrderRelativeTemplates: (NSString *)template before: (bool) before  relatives: (NSMutableArray *)relatives
{
    if( [ template hasPrefix: @"incoming_call"  ] && !before )
    {
        [ self moveTemplate: relatives tempNames:@[ @"outgoing_call" ]  ];
    }
    if( [ template hasPrefix: @"outgoing_call"  ] )
    {
        if( before )
            [ self moveTemplate: relatives tempNames:@[ @"contact_detail", @"all_contacts", @"keypad", @"favorites" ]  ];
        else
            [ self moveTemplate: relatives tempNames:@[ @"chrome_key2" ]  ];
    }
    if( [ template hasPrefix: @"compose_email"  ] && !before )
    {
        [ self moveTemplate: relatives tempNames:@[ @"all_contacts" ]  ];
    }
    if( [ template hasPrefix: @"mailboxes"  ] && !before )
    {
        [ self moveTemplate: relatives tempNames:@[ @"inbox" ]  ];
    }
    if( [ template hasPrefix: @"all_contacts"  ] && !before )
    {
        [ self moveTemplate: relatives tempNames:@[ @"contact_detail" ]  ];
    }
    if( [ template hasPrefix: @"custom"  ] && !before )
    {
        [ self moveTemplate: relatives tempNames:@[ @"custom" ]  ];
    }
    return relatives;
}

-(void) moveTemplate: (NSMutableArray *) arr tempNames:(NSArray *)tempNames
{
    for( NSString * tempName in tempNames )
    {
        for( int index = 0; index < arr.count; index++ )
        {
            CSceneTemplate * temp = arr[index];
            if( [ temp._ID hasPrefix: tempName ] )
            {
                [ arr removeObjectAtIndex: index ];
                [ arr insertObject: temp atIndex: 0 ];
                break;
            }
        }
    }
}

-(void) initTemplates
{
    CSceneTemplate * st;
    NSMutableArray * group;
    
 /*   group = [ self addGroup: @"Unlock Home Screen" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Unlock Screen" ID: @"unlock" ];
    [ group addObject: st ]; */

    group = [ self addGroup: @"Incoming Call" ];

    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"incoming_call3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"incoming_call2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"incoming_call1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"incoming_call7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"incoming_call8" ];
    [ group addObject: st ];
    
#ifdef CUSTOM_VERSION
#define ADMIN_VERSION 1
#endif
    
#ifdef ADMIN_VERSION
    //st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"incoming_call10" ];
    //[ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"incoming_call9" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS10 alt" ID: @"unlock9" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS8/9" ID: @"incoming_call6" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS7" ID: @"incoming_call5" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS6" ID: @"incoming_call4" ];
    [ group addObject: st ];
#endif
    
    group = [ self addGroup: @"Outgoing Call" ];
    
    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"outgoing_call3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"outgoing_call2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"outgoing_call1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"outgoing_call7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"outgoing_call8" ];
    [ group addObject: st ];

#ifdef ADMIN_VERSION
    //st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"outgoing_call10" ];
    //[ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"outgoing_call9" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS8/9" ID: @"outgoing_call6" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS7" ID: @"outgoing_call5" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS6" ID: @"outgoing_call4" ];
    [ group addObject: st ];
#endif
    
    group = [ self addGroup: @"Mail Boxes" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"mailboxes3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"mailboxes2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"mailboxes1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"mailboxes7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"mailboxes8" ];
    [ group addObject: st ];
#ifdef ADMIN_VERSION
    //st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"mailboxes10" ];
    //[ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"mailboxes9" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS8/9" ID: @"mailboxes6" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS7" ID: @"mailboxes5" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS6" ID: @"mailboxes4" ];
    [ group addObject: st ];
#endif
    
    group = [ self addGroup: @"All Contacts" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"all_contacts3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"all_contacts2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"all_contacts1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"all_contacts7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"all_contacts8" ];
    [ group addObject: st ];
#ifdef ADMIN_VERSION
    //st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"all_contacts10" ];
    //[ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"all_contacts9" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS8/9" ID: @"all_contacts6" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS7" ID: @"all_contacts5" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS6" ID: @"all_contacts4" ];
    [ group addObject: st ];
#endif
    group = [ self addGroup: @"Contact Detail" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"contact_detail3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"contact_detail2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"contact_detail1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"contact_detail7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"contact_detail8" ];
    [ group addObject: st ];
#ifdef ADMIN_VERSION
    //st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"contact_detail10" ];
    //[ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"contact_detail9" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS8/9" ID: @"contact_detail6" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS7" ID: @"contact_detail5" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS6" ID: @"contact_detail4" ];
    [ group addObject: st ];
#endif
    
    group = [ self addGroup: @"Inbox" ];

    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"inbox3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"inbox2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"inbox1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"inbox7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"inbox8" ];
    [ group addObject: st ];
#ifdef ADMIN_VERSION
    //st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"inbox10" ];
    //[ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"inbox9" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS8/9" ID: @"inbox6" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS7" ID: @"inbox5" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS6" ID: @"inbox4" ];
    [ group addObject: st ];
#endif
    
    group = [ self addGroup: @"Home" ];
    
    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"home3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"home2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"home1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"home7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"home8" ];
    [ group addObject: st ];
#ifdef ADMIN_VERSION
    //st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"home10" ];
    //[ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"home9" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS8/9" ID: @"home6" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS7" ID: @"home5" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS6" ID: @"home4" ];
    [ group addObject: st ];
#endif
    
    group = [ self addGroup: @"Compose Email" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"compose_email3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"compose_email2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"compose_email1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"compose_email7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"compose_email8" ];
    [ group addObject: st ];
#ifdef ADMIN_VERSION
    //st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"compose_email10" ];
    //[ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"compose_email9" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS8/9" ID: @"compose_email6" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS7" ID: @"compose_email5" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS6" ID: @"compose_email4" ];
    [ group addObject: st ];
#endif
    
    group = [ self addGroup: @"Text Message" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"text_message3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"text_message2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"text_message1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"text_message7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"text_message8" ];
    [ group addObject: st ];
#ifdef ADMIN_VERSION
    //st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"text_message10" ];
    //[ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"text_message9" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS8/9" ID: @"text_message6" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS7" ID: @"text_message5" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS6" ID: @"text_message4" ];
    [ group addObject: st ];
#endif

    group = [ self addGroup: @"Key Pad" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"keypad3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"keypad2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"keypad1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"keypad7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"keypad8" ];
    [ group addObject: st ];
#ifdef ADMIN_VERSION
    //st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"keypad10" ];
    //[ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"keypad9" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS8/9" ID: @"keypad6" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS7" ID: @"keypad5" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS6" ID: @"keypad4" ];
    [ group addObject: st ];
#endif

    group = [ self addGroup: @"Favorites" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"favorites3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"favorites2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"favorites1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"favorites7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"favorites8" ];
    [ group addObject: st ];
#ifdef ADMIN_VERSION
    //st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"favorites10" ];
    //[ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"favorites9" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS8/9" ID: @"favorites6" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS7" ID: @"favorites5" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS6" ID: @"favorites4" ];
    [ group addObject: st ];
#endif
    
    group = [ self addGroup: @"Alert" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"alert3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"alert2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"alert1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"alert7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"alert8" ];
    [ group addObject: st ];
#ifdef ADMIN_VERSION
    //st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"alert10" ];
    //[ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS10" ID: @"alert9" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS8/9" ID: @"alert6" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS7" ID: @"alert5" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"IOS6" ID: @"alert4" ];
    [ group addObject: st ];
#endif

//    group = [ self addGroup: @"Unlock Home Screen" ];
//    st = [[ CSceneTemplate alloc ] initWithName: @"Unlock Screen" ID: @"unlock" ];
//    [ group addObject: st ];
    
    group = [ self addGroup: @"Camera" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"camera3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"camera2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"camera1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"camera7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"camera8" ];
    [ group addObject: st ];
    
    group = [ self addGroup: @"Video Call" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Posterus" ID: @"face_time3" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Rokkakkei" ID: @"face_time2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Lignum" ID: @"face_time1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Simplex" ID: @"face_time7" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Genus" ID: @"face_time8" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Generic" ID: @"face_time9" ];
    [ group addObject: st ];
    
    group = [ self addGroup: @"Solid Colors" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Chroma Key" ID: @"chrome_key1" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Black Screen" ID: @"chrome_key2" ];
    [ group addObject: st ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Color Palette" ID: @"chrome_key3" ];
    [ group addObject: st ];
    
  /*  group = [ self addGroup: @"Scrolling" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Scrolling" ID: @"scrolling" ];
    [ group addObject: st ]; */

     group = [ self addGroup: @"Social Media" ];
     st = [[ CSceneTemplate alloc ] initWithName: @"Social Media" ID: @"social" ];
     [ group addObject: st ];

    group = [ self addGroup: @"Photo Gallery" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Photo Gallery" ID: @"gallery" ];
    [ group addObject: st ];
    
    group = [ self addGroup: @"Video Player" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Video Player" ID: @"video_player1" ];
    [ group addObject: st ];

 /*   group = [ self addGroup: @"Scanner" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Scanner" ID: @"scanner1" ];
    [ group addObject: st ]; */

    group = [ self addGroup: @"Custom" ];
    st = [[ CSceneTemplate alloc ] initWithName: @"Custom" ID: @"custom" ];
    [ group addObject: st ];
}

+(NSArray *) getThemeNames
{
    return [ NSArray arrayWithObjects:@"Posterus", @"Rokkakkei", @"Lignum", @"Simplex", @"Genus", @"IOS10", @"IOS8/9", @"IOS7", @"IOS6", nil ];
}

#define MYNUMB(a)  [ NSNumber numberWithInt: (int)a ]

+(NSArray *) getThemeIDs
{
    return [ NSArray arrayWithObjects: MYNUMB(3), MYNUMB(2), MYNUMB(1), MYNUMB(7), MYNUMB(8), MYNUMB(9), MYNUMB(6), MYNUMB(5), MYNUMB(4), nil ];
}

+(NSString *) getThemeNameByID: (int) themeId
{
    NSArray * arr = [ self getThemeIDs ];
    
    int index = 0;
    for( NSNumber * tId in arr ) {
        
        if ( tId.intValue == themeId )
            return [self getThemeNames][index];
        
        index++;
    }
    return nil;
}

@end
