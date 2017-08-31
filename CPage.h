#import "CTopBar.h"
#import "CRect.h"
#import "CText.h"
#import "CHotKey.h"

@class CScene;

@protocol SceneDelegate <NSObject>
-(void) onPlayExit;
-(void) onPlayStartOver;
-(CHotKey *) getExitArea;
-(void) onPageChanged;
-(float) getEnvBrightness;
-(CScene *) getScene;
-(void) onPageInserted: (int) index page: (CPage *)page;
@end

@interface CPage : NSObject<ContainerDelegate>
{
    CText * _previousBtn, *_nextBtn;
    BOOL _bTopBarInverted;
    NSMutableArray * _elements;
}

@property (nonatomic, strong) CRect *_frame;
@property (nonatomic, strong) CTopBar *_topBar;
@property (nonatomic, strong) NSString *_templateName;
@property (nonatomic, strong) NSString *_theme;
@property (nonatomic, strong) NSDictionary *_params;
@property (nonatomic, strong) UIImage * _backgroundImg;
@property (nonatomic, strong) UIImage * _thumbnail;
@property (nonatomic, weak) UIView * _view;
@property (nonatomic) CGPoint _exitPos;
@property (nonatomic) bool _hasExtendedOptions;
@property (nonatomic) bool _partScreen;
@property (nonatomic) bool _proximitySensorEanbled;
@property (nonatomic) float _alpha;
@property (nonatomic) bool _backgroundKeepAspect;

@property (nonatomic, strong) NSNumber * _incomingPage;
@property (nonatomic, strong) NSNumber * _pageID;

@property (nonatomic) int _transitionType;
@property (nonatomic) float _transitionTime;

@property (nonatomic) int _vibrateMode;

@property (nonatomic, strong) NSTimer * _triggerTimer;
@property (nonatomic) int _triggerMode;
@property (nonatomic) float _triggerTime;

@property (nonatomic, strong) CHotKey * _hotkey;

@property (nonatomic, weak) id<SceneDelegate,ElementDelegate> _delegate;

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay;
-(void) onRenderCompleted:(UIView *) parentView bPlay:(bool)bPlay;
- (id)initWithTemplate: (NSString *) templateName delegate:(id) delegate params: (NSDictionary * )params;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;
- (NSString *)getThemeName;
- (NSString *)getImageName: (NSString *) name;
- (NSString *)getImageNameWithThemem: (NSString *) name;
-(void) playEnd;
-(void) playInit: (UIView *) parentView bPlay: (BOOL) bPlay;

-(NSArray *) getExitItems;
-(void) setExitPage: (CPage *) page;
-(UIImage *) captureScreenshot: ( UIView *) mainView fileName: (NSString *) fileName;

- (bool) ifImageExists: (NSString *) name;
-(CImage *) findElementByImageName: (NSString *) imageName;

-(UIButton *)createImageButtonInView: (UIView *) view imageName: (NSString *) imageName  rectName: (NSString *) rectName highlightColor: (UIColor *) highlightColor;

-(UIButton *)createImageButtonInView: (UIView *) view imageName: (NSString *) imageName  rect: (CRect *) rect target:(id) target sel:(SEL)sel highlightColor: (UIColor *) highlightColor;

-(UIButton *)createImageButtonInView: (UIView *) view imageName: (NSString *) imageName  rectName: (NSString *) rectName;

-(UIButton *)createImageButtonInView: (UIView *) view imageName: (NSString *) imageName  rect: (CRect *) rect target:(id) target sel:(SEL)sel;

-(UIView *) createBarInView:(UIView *)view rectName: (NSString *)rectName colorName: (NSString *) colorName;

-(UILabel *) createCaption: (NSString *) sText rectName:(NSString *) rectName;
-(void) createLeftButton;
-(void) createBottomButtons: (UIView *)parentView;

-(void) updateThumbnail;
-(UIImage *) getThumbnail;
-(void)onOptionClicked: (int) optionID;
-(void) changeBrightness: (float) brightness;

-(void) setupNavigationButtons: (NSString *)prevPageBtn nextPageBtn: (NSString *) nextPageBtn bTextMode:(bool)bTextMode;
-(CText *) setupNonEditableButton: (NSString *) btnName bTextMode:(bool)bTextMode destPage: (int) destPage;
-(void) setupNonEditableTitle: (NSString *) sTitle;

-(void) setupBackgroundClickHandler: (UIView *)view bPlay: (bool) bPlay;

-(UIImageView *) loadBackgroundImage;
-(void) applyProximity: (bool) bEnable;

-(void) showHotkey: (bool) bShow;
-(void) onHotkeyAction: (id) sender;

-(void) onPageRemoved: ( NSNumber * ) pageId;
-(void) copyFrom: (CPage *) page;

-(NSDictionary *) getCrossPlatformInfo;

-(BOOL) onKeyAction: (bool) bBackword;
-(id) getTransitionParam;
-(void) setTransitionParam: (id) param;

-(void) initView: (UIView *) parentView bPlay:(bool)bPlay;
-(UIView *) setupViews: (UIView *) parentView bPlay:(bool)bPlay bResetView: (BOOL) bResetView;
-(UIView *) getBackgroundView;

-(void) invertTopBar;
-(void) setBackgroundImage: (UIImage*) backgroundImage;

@end
