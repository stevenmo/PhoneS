#import "CElement.h"
#import "utils.h"
#import "Preference.h"
#import "CScene.h"
#import "CSettings.h"

@implementation CElement

@synthesize _view,_rect,_editable,_edited,_container,_removeable,_hidden;

-(id) initWithTarget: (id) target sel: (SEL) sel container:(id<ContainerDelegate>)container
{
    self = [super init ];
    
    _clicked = false;
    _edited = false;
    _editable = true;
    
    [ self setTarget:target sel:sel container:container ];
    
    return self;
}

-(void) setTarget: (id) target sel: (SEL) sel container:(id<ContainerDelegate>) container;
{
    _target = target;
    _sel = sel;
    _container = container;
}

-(id<ElementDelegate>) getDelegate
{
    return [ _container getDelegate ];
}

-(void) setupClickHandler
{
    if( !_editable && __linkPage == nil )
        return;
    
    if(  [ _view isKindOfClass: UIButton.class ] )
    {
        [ (UIButton *)_view removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside ];
        [ (UIButton *)_view addTarget: self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside ];
    }
    if( [ [ self getDelegate ] isHotkeyShowing ] && ![ self isKindOfClass: CHotKey.class ] )
        return;
    
    if( !_clicked && _editable )
    {
        [ Utils borderAnimation: _view ];
    }
}

-(UIView *) render: (UIView *) parentView bPlay:(bool)bPlay
{
    [ parentView addSubview: _view ];
    if( !bPlay )
        [ self setupClickHandler ];
    
    return _view;
}

-(void) flash
{
//    if( [ _view isKindOfClass: [ UIButton class ] ] )
//        ((UIButton *)_view).highlighted = !((UIButton *)_view).highlighted;

    if( _view.alpha >= 1.0 )
        _view.alpha = 0.5;
    else
        _view.alpha = 1.0;
}

-(void) remove
{
    if( !_removeable )
        return;
    
    [ self._view removeFromSuperview ];
    if( [ self._container respondsToSelector:@selector(onMemberRemoved:) ] )
    {
        if( [ self._container onMemberRemoved: self ] )
            [ [ self getDelegate ] onContentRefresh ];
    }
}

-(void) setLinkToEnd
{
    __linkPage = PAGE_END_LINK;
    _editable = true;
}

-(void) setLinkToNextPage
{
    __linkPage = PAGE_NEXT_LINK;
}

-(void) setLinkToPageIndex: (int) index
{
    __linkPage = [ NSNumber numberWithInt: index ];
}

-(void) setLinkToPage: (CPage *) page
{
    __linkPage = [ NSNumber numberWithInt: page._pageID.intValue ];
    NSLog(@"link: %@,pageId: %@",__linkPage, page._pageID );
}

-(void) onClicked: (id) sender
{
    NSLog(@"onClicked:");
    
    _clicked = true;

    [ Utils removeSubLayers: _view ];
    [ [ self getDelegate ] onElementClicked: self param: nil ];
}

+(id) decodeObject: (NSCoder *) decoder key: (NSString *) key container: (id<ContainerDelegate>) container
{
    CElement * el = [ decoder decodeObjectForKey: key ];
    el._container = container;
    
    return el;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [ encoder encodeBool:_editable forKey: @"editable" ];
    [ encoder encodeBool:_edited forKey: @"edited" ];
    [ encoder encodeBool:_hidden forKey: @"hidden" ];
    [ encoder encodeObject: _rect forKey: @"rect" ];
    [ encoder encodeObject: __linkPage forKey: @"linkPage" ];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [super init] )
	{
		_rect = [ decoder decodeObjectForKey: @"rect" ];
		_editable = [ decoder decodeBoolForKey: @"editable" ];
        _edited = [ decoder decodeBoolForKey: @"edited" ];
        _hidden = [ decoder decodeBoolForKey: @"hidden" ];
		__linkPage = [ decoder decodeObjectForKey: @"linkPage" ];
	}
    return self;
}

-(void) copyFrom:(CElement *)element
{
    _editable = element._editable;
    _hidden = element._hidden;
    [ _rect copyFrom: element._rect ];
    if ( element._linkPage != nil  )
        __linkPage = [ NSNumber numberWithInt: element._linkPage.intValue ];
}

@end
