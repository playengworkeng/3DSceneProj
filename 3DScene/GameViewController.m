//
//  GameViewController.m
//  3DScene
//
//  Created by J on 9/10/16.
//  Copyright (c) 2016 playengworkeng. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create a new scene
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* directory = [paths objectAtIndex:0];
//    
//    
//    NSFileManager* fileManager = [NSFileManager defaultManager];
//   
//    
//    NSURL* directoryURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//
//    
//    NSString* newURL = [directoryURL.absoluteString stringByAppendingString:@"Test.scn"];
//    NSURL* url = [[NSURL alloc]initWithString:newURL relativeToURL:nil];
//    
//    NSLog(@"%@",url);
//    SCNScene *scene =[SCNScene sceneWithURL:url options:nil error:nil];

    
    //SCNScene *scene = [SCNScene sceneNamed:self.loadPath];
    
   
    
    SCNView* scnView=  [self createScene:scene];
    
    self.scnView = scnView;
    
    [self.view addSubview:self.scnView];

}

-(SCNView*)createScene:(SCNScene*) scene
{
    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scene.rootNode addChildNode:cameraNode];
    
    // place the camera
    cameraNode.position = SCNVector3Make(0, 0, 15);
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    

    
    // retrieve the ship node
    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];
    
    // animate the 3d object
    [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    
    // retrieve the SCNView
    SCNView *scnView =  [[SCNView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    //           (SCNView *)self.view;
    
    
    
    // set the scene to the view
    scnView.scene = scene;
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = YES;
    
    // show statistics such as fps and timing information
    scnView.showsStatistics = YES;
    
    // configure the view
    scnView.backgroundColor = [UIColor blackColor];
    
    // add a tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
    scnView.gestureRecognizers = gestureRecognizers;
  
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* directory = [paths objectAtIndex:0];
    
    self.directory = directory;
    //self.scnView = scnView;
    
    return scnView;

    
}


- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
    // retrieve the SCNView
    SCNView *scnView = self.scnView;
    
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:scnView];
    NSArray *hitResults = [scnView hitTest:p options:nil];
    
    // check that we clicked on at least one object
    if([hitResults count] > 0){
        // retrieved the first clicked object
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        
        // get its material
        SCNMaterial *material = result.node.geometry.firstMaterial;
        
        // highlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        
        // on completion - unhighlight
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            
            material.emission.contents = [UIColor blackColor];
            
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [UIColor redColor];
        
        [SCNTransaction commit];
    }
    
    
    //This is a test to add new geometry to exisitng scene
    SCNSphere* sphere  = [[SCNSphere alloc]init];
    
    sphere.radius = 2.0;
    
    
    SCNNode* sphereNode = [SCNNode node];
    sphereNode.geometry = sphere;
    
    [self.scnView.scene.rootNode  addChildNode:sphereNode];
    
    
    SCNPyramid* pyramid =[[SCNPyramid alloc]init];
    pyramid.height = 5.0;
    pyramid.width = 10;
    
    
    
    SCNNode* pyramidNode = [SCNNode node];
    pyramidNode.geometry = pyramid;
    
    SCNMaterial* material = [[SCNMaterial alloc]init];
    
    material.diffuse.contents = [UIColor blueColor];
    
    pyramidNode.geometry.materials = @[material];

    [self.scnView.scene.rootNode addChildNode:pyramidNode];
  
    
    
    
    //Save the newly added node to a test scenekit file
    
    BOOL success = [NSKeyedArchiver archiveRootObject:[self.scnView scene] toFile:[self.directory stringByAppendingString:@"/Test.scn"]];
    
    
    
    NSLog(@"%i\n", success);
    
    self.loadPath = [self.directory stringByAppendingString:@"/Test.scn"];

    
    
    //load the new scne and display
    SCNScene* scene = [SCNScene sceneNamed:self.loadPath];
    
    SCNView* newView =  [self createScene:scene];
    
    
    
    NSLog(@"%@\n", self.loadPath);
    
    
    
    self.scnView2 = newView;
    
    [self.view insertSubview:self.scnView2 atIndex:0];

}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
