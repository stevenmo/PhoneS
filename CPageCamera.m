#import <AudioToolbox/AudioToolbox.h> 
#import "CPageCamera.h"
#import "Preference.h"
#import "MACaptureSession.h"
#import "CRect.h"
#import "AAPLCameraViewController.h"
#import "Utils.h"

@implementation CPageCamera

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    UIView * mainV = [ super render: parentView bPlay: bPlay ];
    
    Boolean bCameraUpMode = false;
    NSString * name =  @"AAPLCameraViewController";
    
    if ( [ self._templateName isEqualToString:@"camera2" ] || [ self._templateName isEqualToString:@"camera3" ] || [ self._templateName isEqualToString:@"camera8" ] )
    {
        bCameraUpMode = true;
        name =  @"AAPLCameraViewController2";
    }
    
    [ _subVc stop ];
    _subVc = (AAPLCameraViewController *)[ Utils initViewController: name ];
    _subVc._delegate = self;
    [ _subVc setFlashMode: __nFlashMode ];
    
    [ mainV addSubview: _subVc.view ];
    [ (UIViewController *)[ self getDelegate ] addChildViewController: _subVc ];
    
    [ self setupButtons: bCameraUpMode ];

    return mainV;
}

-(void) setFlashMode: (int) nFlashMode
{
    __nFlashMode = nFlashMode;
    [ _subVc setFlashMode: nFlashMode ];
}

-(void) setupCamera: (UIView *) parentView
{
    _captureManager = [[MACaptureSession alloc] init];
    [_captureManager addVideoInputFromCamera];
    [_captureManager addStillImageOutput];
    [_captureManager addVideoPreviewLayer];
    
    CGRect layerRect = CGRectMake(0, 0, parentView.bounds.size.width, parentView.bounds.size.height - 200 );
    [[_captureManager previewLayer] setBounds:layerRect];
    [[_captureManager previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
    [[ parentView layer] addSublayer:[ _captureManager previewLayer ] ];
    
    [[_captureManager captureSession] startRunning];
}

-(void) setupButtons: (BOOL) bCameraUp {
    
    UIImage * img = [ Utils loadImage: @"photo" templateName: self._templateName ];
    [_subVc.stillButton setBackgroundImage: img forState: UIControlStateNormal ];
    [ _subVc.stillButton setTitle:nil forState: UIControlStateNormal ];
    
    img = [ Utils loadImage: @"recording1" templateName: self._templateName ];
    [_subVc.recordButton setBackgroundImage: img forState: UIControlStateNormal ];
    [ _subVc.recordButton setTitle:nil forState: UIControlStateNormal ];
    [ _subVc.recordButton setTitle:nil forState: UIControlStateSelected ];
    
    img = [ Utils loadImage: @"recording2" templateName: self._templateName ];
    [_subVc.recordButton setImage: img forState: UIControlStateSelected ];
    
    [ _subVc.libraryButton setTitle:nil forState: UIControlStateNormal ];
    
    img = [ Utils loadImage: @"camera" templateName: self._templateName ];
    [_subVc.cameraButton setBackgroundImage: img forState: UIControlStateNormal ];
    [ _subVc.cameraButton setTitle:nil forState: UIControlStateNormal ];

    CRect * r = [ self._params objectForKey:@"iconRect" ];
    _subVc.button_width_constraint.constant = r._width;
    _subVc.button_height_constraint.constant = r._height;

    int posAdjustment = [[ self._params objectForKey:@"posAdjustment" ] intValue];
    if(posAdjustment == 0)
        posAdjustment = 16;
    [ self createImageButtonInView: _subVc.libraryButton imageName:@"library" rect:r target:nil sel:nil ];

    if( bCameraUp ) {
        
        float w = (self._view.frame.size.width - 3 * r._width)/4;

        _subVc.library_leading_constraint.constant = w-posAdjustment;
        _subVc.record_leading_constraint.constant = w*2+r._width-posAdjustment;
        _subVc.still_leading_constraint.constant = w*3+r._width*2-posAdjustment;
        _subVc.camera_leading_constraint.constant = w*3+r._width*2-posAdjustment;
    } else {

        float w = (self._view.frame.size.width - 4 * r._width)/5;
        
        _subVc.library_leading_constraint.constant = w-posAdjustment;
        _subVc.record_leading_constraint.constant = w*2+r._width-posAdjustment;
        _subVc.still_leading_constraint.constant = w*3+r._width*2-posAdjustment;
        _subVc.camera_leading_constraint.constant = w*4+r._width*3-posAdjustment;
    }
}

-(void) playEnd
{
    //[[_captureManager captureSession] stopRunning];
    //_captureManager = nil;
}

-(void) onPlayEnd
{
    [ _subVc stop ];
    [ _subVc.view removeFromSuperview ];
    [ _subVc removeFromParentViewController ];
    [ self._delegate onPlayExit ];
}

-(void) dealloc
{
    [ self playEnd ];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ super encodeWithCoder: encoder ];
    
    [ encoder encodeInt: __nFlashMode forKey: @"_nFlashMode" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super initWithCoder: decoder ] )
    {
        __nFlashMode = [ decoder decodeIntForKey: @"_nFlashMode" ];
    }
    return self;
}

@end
