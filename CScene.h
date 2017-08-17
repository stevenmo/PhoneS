#import "CTopBar.h"
#import "CPage.h"
#import "CSceneTemplate.h"
#import "CExternalKeyboardScene.h"

#define ICLOUD_OFF       1
//#define ADMIN_VERSION   1
//#define CUSTOM_VERSION   1

#define PAGE_NEXT   -1
#define PAGE_PREV   -2
#define PAGE_END    -3
#define PAGE_DEAD   -4

#define PAGE_NEXT_LINK   [ NSNumber numberWithInt: PAGE_NEXT ]
#define PAGE_END_LINK   [ NSNumber numberWithInt: PAGE_END ]
#define PAGE_DEAD_LINK   [ NSNumber numberWithInt: PAGE_DEAD ]

enum{
    TransitionTYPE_None            = 0,
    TransitionTYPE_FlipFromLeft,
    TransitionTYPE_FlipFromRight,
    TransitionTYPE_CurlUp,
    TransitionTYPE_CurlDown,
    TransitionTYPE_CrossDissolve,
    TransitionTYPE_FlipFromTop,
    TransitionTYPE_FlipFromBottom
};

@class CProject;

@interface CScene : CExternalKeyboardScene
{
}

@property (nonatomic, strong) NSMutableArray * _pages;
@property (nonatomic, strong) NSString * _mainTemplate;
@property (nonatomic, strong) CProject * _project;
@property (nonatomic) bool _keyPageAtBeginning;
@property (nonatomic) int _currentPage;
@property (nonatomic, strong) CHotKey * _exitArea;
@property (nonatomic) bool _skipWatermark;

-(CPage *) getCurrentPage;
-(CPage *) addPage: (CSceneTemplate *) temp;
-(CPage *) insertPage: (int) index template: (CSceneTemplate *) temp transition: (int) transition time:(float) time;

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay;

+(id) initWithProject: (CProject *) project delegate:(id) delegate;
-(void) playInit: (UIView *) parentView bPlay: (BOOL) bPlay startPage: (int) startPage;
-(void) playEnd;

-(void)save: (NSString *) fileName;
-(bool) isFree;

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

-(id) initWithPage: (CPage *) page;
-(id) initWithPage1: (CPage *) page1 page2: (CPage *) page2;
-(id) initWithPages: (NSArray *) pages delegate: (id) delegate theme: (int) theme keyPageAtBeginning: (bool) keyPageAtBeginning;

-(CGPoint) getExitPos;

-(void) refresh;
-(int) findPageId: (NSNumber *) pageId;
-(void) switchToPage: (NSNumber *) pageId;
-(void) changePage: (int) page bRefresh: (BOOL) bRefresh;
-(void) removePage: (int) index;
-(void) movePage: (int) index toIndex: (int) toIndex;
-(void) onOptionClicked: (int) optionID;

-(void) setBrightness: (float) brightness;
-(void) setProximitySensor: (bool) bOn;

-(void)onSetExitArea: (bool) bOn;
-(void) saveScreenshotsToFolder: (NSString *) szFolder mainView: (UIView *) mainView;
-(NSArray *) getCrossPlatformInfo;
-(bool) onlyTapHoldToExit;

@end
