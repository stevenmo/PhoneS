#import "CPage.h"
#import "CImage.h"
#import "CText.h"
#import "CTextRow.h"

@interface CPageTextRows : CPage < UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate >
{
    bool _insertFromTop;
    int _bottomHeight,_topHeight,_leftMargin,_rightMargin;
    NSTimer * _timer;
    int  _mode;
    id _delegate;
    NSString * _icon;
    CElement * _linkElement;
    int _lastAnimatedRow;
}

@property (nonatomic, strong) NSMutableArray *_textRows;
@property (nonatomic, strong) UITableView * _tableView;
@property (nonatomic) BOOL _hideBottomBar;

-(void)onOptionClicked: (int) optionID;
-(int) getRenderedRows: (int) section;
-(CTextRow *) getDefaultRow;
-(CTextRow *) getRowAtIndex:(int) section  index: (int) index;
-(void)renderRow: (CTextRow *) row;
-(void) checkNextRow: (BOOL) bFirstTime;
-(void) rollbackRows;
-(void) setBackgroundImage:(UIImage *)backgroundImage;
@end
