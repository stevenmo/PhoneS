@import UIKit;

@protocol AAPLCameraViewControllerDelegate <NSObject>
@required

-(void) onPlayEnd;

@end


@interface AAPLCameraViewController : UIViewController
{
    int _flashMode;
};

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *library_leading_constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *record_leading_constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *still_leading_constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *camera_leading_constraint;

@property (nonatomic, weak) IBOutlet UIButton *resumeButton;
@property (nonatomic, weak) IBOutlet UIButton *recordButton;
@property (nonatomic, weak) IBOutlet UIButton *cameraButton;
@property (nonatomic, weak) IBOutlet UIButton *stillButton;
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button_width_constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button_height_constraint;


@property (nonatomic,strong) id<AAPLCameraViewControllerDelegate> _delegate;
@property (nonatomic) BOOL _setFrontCamera;

-(void) stop;
-(void) setFlashMode: (int) flashMode;
-(IBAction)changeCamera:(id)sender;
-(BOOL) isCurrentFrontCamera;

@end
