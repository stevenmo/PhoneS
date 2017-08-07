#import "VideoPicker.h"
#import "CElement.h"
#import "CText.h"
#import "CImage.h"
#import "CMediaArea.h"
#import "PhoneSimulator-swift.h"
#import "ColorPickerViewController.h"

#define RatingIconsNUMB   3

@interface CSocialMediaPost : CElement<VideoPickerDelegate,ContainerDelegate,ColorPickerDelegate>
{
    VideoPicker * _videoPicker;
    VideoPlayer * _videoPlayer;
    UIView * _headerView;
    int _headerColor;
    Boolean _hasHeader;
    CImage * _headerImage;
    CImage * _userLink;
    CImage *_ratingIcons[RatingIconsNUMB];
    NSArray * _comments;
    CGFloat _commentPosY;
}

@property (nonatomic, strong) CText *_title;
@property (nonatomic, strong) CText *_subTitle;
@property (nonatomic, strong) CText *_likeLabel;
@property (nonatomic, strong) CImage *_icon;
@property (nonatomic, strong) CMediaArea *_image;

@property (nonatomic, weak) UIViewController * _parentVC;

-(UITableViewCell *) render: (UIView *) parentView bPlay: (bool) bPlay;

-(CGFloat) getContentHeight: (UITableView *) tableView;
-(UIView *) getSectionHeaderView: (UITableView *) tableView;
-(CGFloat) getSectionHeaderHeight: (UITableView *) tableView;

+(CSocialMediaPost *) copyFrom:(CSocialMediaPost *)post;

@end
