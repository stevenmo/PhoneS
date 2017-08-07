#import "CPage.h"
#import "CImage.h"
#import "CText.h"
#import "CTextRow.h"

#define BottomIconsNUMB   5

@interface CPageSocialMedia : CPage < UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate >
{
    id _delegate;
    CImage *_bottomIcons[BottomIconsNUMB];
    NSMutableArray * _cells;
}

@property (nonatomic, strong) CImage *_titleBar;
@property (nonatomic, strong) CText *_titler;
@property (nonatomic, strong) CImage *_bottomBar;

@property (nonatomic, strong) NSMutableArray *_postObjects;
@property (nonatomic, strong) UITableView * _tableView;

@end
