//
//  GameViewController.h
//  3DScene
//

//  Copyright (c) 2016 playengworkeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@interface GameViewController : UIViewController
@property(strong, nonatomic)SCNView* scnView;
@property(strong, nonatomic)SCNView* scnView2;
@property(strong, nonatomic)NSString* directory;
@property(strong, nonatomic)NSString* loadPath;
- (void) handleTap:(UIGestureRecognizer*)gestureRecognize;
-(SCNView*)createScene:(SCNScene*)scene;

@end
