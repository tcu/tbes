/*
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
*/

/* ---------------------------------------------------------------------------
 ** Texas Christian University
 **
 ** TBehavioralEvaluationViewController.mm
 ** TBES
 **
 ** Created on 12/4/12
 ** Kenneth Leising
 ** Catherine Urbano
 ** Danny Westfall
 ** 
 ** -------------------------------------------------------------------------*/

#import "TBehavioralEvaluationViewController.h"
#import "TConnectionController.h"
#import "TConnectionDetailsController.h"

@interface TBehavioralEvaluationViewController(){
    UIViewController* activeViewController;
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    BOOL inputStreamConnected;
    BOOL outputStreamConnected;
    BOOL isConnecting;
    BOOL isLocked;
    BOOL isRegistered;
    NSDate* lastMessageRecieved;
    NSDate* connectedTime;
    UITapGestureRecognizer *connectionInfoGesture;
    
    IBOutlet UITextField* serverHostAddress;
    IBOutlet UITextField* serverPort;
    IBOutlet UILabel* serverHostErrorLabel;
    IBOutlet UILabel* serverPortErrorLabel;
    IBOutlet TConnectionController* connectionController;
    IBOutlet TConnectionDetailsController* connectionDetailsController;
    IBOutlet UINavigationController* connectionDetailsNavigationController;
    IBOutlet UIView* toolTipView;
    IBOutlet UIButton* disconnectButton;
    IBOutlet UIButton* demoServerButton;
    IBOutlet UIButton* connectButton;
}

@property(nonatomic, strong) NSTimer* connectionTimer;
@property(nonatomic, strong) IBOutlet UINavigationController* helpController;
@property(nonatomic, strong) IBOutlet UINavigationController* connectController;

@property(readonly) BOOL isConnected;


@end

@implementation TBehavioralEvaluationViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.wantsFullScreenLayout = YES;
        CGRect bounds = [UIScreen mainScreen].bounds;
        self.view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
        [self.view setBackgroundColor: [UIColor whiteColor] ];
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated{
    TLog(@"Eval View Controller Will Appear");
    TBES_FIRST_RUN firstRun = [self.userDefaults integerForKey: TBES_FIRST_RUN_KEY ];
    
    if(isRegistered == NO){
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(OnEnterBackground:) name: TBES_ENTER_BACKGROUND object: nil];
        isRegistered = YES;
    }
    
    if(connectionInfoGesture == nil){
        connectionInfoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnShowConnectionDetails:)];
        connectionInfoGesture.numberOfTapsRequired = 2;
        connectionInfoGesture.numberOfTouchesRequired = 3;
        [self.view addGestureRecognizer: connectionInfoGesture];
    }
    
    
    if( firstRun == TBES_FIRST_RUN_YES ){
        [self OnShowHelp: nil];
    }
    else{
        [self OnShowConnect: nil];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [self OnCloseConnection: self];
}

-(void) OnEnterBackground: (id) sender{
    [self OnCloseConnection: sender];
}

-(IBAction) OnCloseConnectionDetails: (id)sender{
    [connectionDetailsController dismissModalViewControllerAnimated: YES];
}


-(IBAction) OnCloseConnection: (id)sender{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [toolTipView removeFromSuperview];
    [connectionDetailsController dismissModalViewControllerAnimated: NO];
    [inputStream close];
    [outputStream close];
    inputStreamConnected = NO;
    outputStreamConnected = NO;
    
    for(UIButton* btn in self.view.subviews){
        [btn removeFromSuperview];
    }
    
    [UIView beginAnimations: @"" context: nil];
    [UIView setAnimationDuration: 1.0];
    [self.view setBackgroundColor: [UIColor whiteColor] ];
    [UIView commitAnimations];
    
    [connectionDetailsController dismissModalViewControllerAnimated: NO];
    
    [self OnShowConnect: nil];
}

-(void) OnShowConnectionDetails: (id) sender{
    if(self.isConnected){
        TLog(@"Show Connection Details");
        [[NSBundle mainBundle] loadNibNamed: @"ConnectionDetails" owner:self options:nil];
        connectionDetailsController.modalPresentationStyle = UIModalPresentationFormSheet;
        connectionDetailsNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        [connectionDetailsController showConnectionDetails: connectedTime: serverHostAddress.text];
        
        [disconnectButton setTitle: @"Disconnect" forState: UIControlStateNormal];
        [disconnectButton setTitle: @"Disconnect" forState: UIControlStateHighlighted];
        [disconnectButton setTitleColor: [UIColor whiteColor]  forState: UIControlStateNormal];
        UIImage *buttonImagePressed = [UIImage imageNamed: @"redButton.png"];
        UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth: 12 topCapHeight: 0];
        [disconnectButton setBackgroundImage: stretchableButtonImagePressed forState: UIControlStateNormal];
        
        [self presentModalViewController: connectionDetailsNavigationController animated: YES];
    }
}

-(IBAction) OnConnect: (id) sender{
    
    if([serverHostAddress.text isEqualToString: @""]){
        [serverHostErrorLabel setHidden: NO];
        return;
    }
    
    if( [serverPort.text isEqualToString: @""] ){
        [serverPortErrorLabel setHidden: NO];
        return;
    }
    
    if( ![serverPort.text intValue] ){
        [serverPortErrorLabel setHidden: NO];
        return;
    }
    
    [self.userDefaults setValue: serverHostAddress.text forKey: TBES_LAST_CONNECTED_HOST];
    [self.userDefaults setValue: serverPort.text forKey: TBES_LAST_CONNECTED_PORT];
    [self.userDefaults synchronize];
    
    [self openConnection];
    [connectionController showConnecting];
}

-(IBAction) OnConnectToDemoServer: (id)sender{
    serverHostAddress.text = TBES_DEMO_SERVER_ADDRESS;
    serverPort.text = TBES_DEMO_SERVER_PORT;
    [self OnConnect: sender];
}

-(IBAction) OnShowConnect :(id) sender{
    if(activeViewController != nil){
        [activeViewController dismissModalViewControllerAnimated: NO];
        activeViewController = nil;
    }
    
    if(self.connectController == nil){
        [[NSBundle mainBundle] loadNibNamed: TBES_CONNECT_XIB owner: self options: nil];
        self.connectController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [serverHostErrorLabel setHidden: YES];
    [serverPortErrorLabel setHidden: YES];
    
    if(self.connectController == nil){
        [self showErrorMessage: @"Unable to Load Connection Controller"];
        return;
    }
    
    [demoServerButton setTitle: @"Connect to Demo Server" forState: UIControlStateNormal];
    [demoServerButton setTitle: @"Connect to Demo Server" forState: UIControlStateHighlighted];
    [demoServerButton setTitleColor: [UIColor whiteColor]  forState: UIControlStateNormal];
    UIImage *buttonImagePressed = [UIImage imageNamed: @"blueButton.png"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth: 12 topCapHeight: 0];
    [demoServerButton setBackgroundImage: stretchableButtonImagePressed forState: UIControlStateNormal];
    
    [connectButton setTitle: @"Connect" forState: UIControlStateNormal];
    [connectButton setTitle: @"Connect" forState: UIControlStateHighlighted];
    [connectButton setTitleColor: [UIColor whiteColor]  forState: UIControlStateNormal];
    [connectButton setBackgroundImage: stretchableButtonImagePressed forState: UIControlStateNormal];
    
    if([self.userDefaults objectForKey: TBES_LAST_CONNECTED_HOST] != nil){
        serverHostAddress.text = [self.userDefaults objectForKey: TBES_LAST_CONNECTED_HOST];
    }
    else{
        serverHostAddress.text = TBES_DEMO_SERVER_ADDRESS;
    }
    
    if([self.userDefaults objectForKey: TBES_LAST_CONNECTED_PORT] != nil){
        serverPort.text = [self.userDefaults objectForKey: TBES_LAST_CONNECTED_PORT];
    }
    else{
        serverPort.text = TBES_DEMO_SERVER_PORT;
    }

    
    activeViewController = self.connectController;
    [self presentModalViewController: self.connectController animated: YES];
}

-(IBAction) OnShowHelp: (id) sender{
    if(activeViewController != nil){
        [activeViewController dismissModalViewControllerAnimated: NO];
        activeViewController = nil;
    }
    
    if(self.helpController == nil){
        [[NSBundle mainBundle] loadNibNamed: TBES_HELP_XIB owner: self options: nil];
        self.helpController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    if(self.helpController == nil){
        [self showErrorMessage: @"Unable to Load Help Controller"];
        return;
    }
    
    activeViewController = self.helpController;
    [self presentModalViewController:self.helpController animated: YES];
}

-(IBAction) OnCompleteTouchTip: (id)sender{
    
    [UIView beginAnimations: @"View Flip" context: nil ];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView: self.view cache: YES];
	[toolTipView removeFromSuperview];
	[UIView	 commitAnimations];
    
    [toolTipView removeFromSuperview];
    isLocked = NO;
}

-(IBAction) OnCloseHelp: (id) sender{
    [self.userDefaults setObject: [NSNumber numberWithInt: TBES_FIRST_RUN_NO] forKey: TBES_FIRST_RUN_KEY];
    [self.userDefaults synchronize];
    [self.helpController dismissViewControllerAnimated: YES completion:^{
        if(!self.isConnected){
            [self OnShowConnect: nil];
        }
    }];
    activeViewController = nil;
}

-(BOOL) isConnected{
    return inputStreamConnected && outputStreamConnected;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void) OnConnectError: (id) sender{
    TLog(@"Connection Timeout");
    if(isConnecting){
        isConnecting = NO;
        [connectionController showConnectionError];
        [inputStream close];
        [outputStream close];
        inputStreamConnected = NO;
        outputStreamConnected = NO;
    }
}

-(void) openConnection{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    isConnecting = YES;
    self.connectionTimer = [NSTimer scheduledTimerWithTimeInterval:TBES_CONNECTION_TIMEOUT target:self selector:@selector(OnConnectError:) userInfo:nil repeats: YES];
    TLog(@"Connecting to %@:%@", serverHostAddress.text, serverPort.text);
    CFStreamCreatePairWithSocketToHost (NULL, (__bridge CFStringRef) serverHostAddress.text, [serverPort.text intValue], &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
    
}

-(void) stream:(NSStream *)currentStream handleEvent:(NSStreamEvent)eventCode{
    
    if(eventCode == NSStreamEventOpenCompleted){
        TLog(@"Connection: Open Complete");
        if(currentStream == inputStream){
            inputStreamConnected = YES;
        }
        else if(currentStream == outputStream){
            outputStreamConnected = YES;
        }
        
        if(self.isConnected){
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            TLog(@"Connected to Server");
            isConnecting = NO;
            connectedTime = [NSDate date];
            [self.connectionTimer invalidate];
            self.connectionTimer = nil;
            [self.view setBackgroundColor: TBES_EVAL_BACKGROUND_COLOR ];
            [connectionController showConnected];
        }
        
    }
    else if(eventCode == NSStreamEventHasBytesAvailable){
        TLog(@"Connection: Has Bytes");
        if (currentStream == inputStream) {
            int BUFFER_LENGTH = 1024;
            uint8_t buffer[BUFFER_LENGTH];
            int iAmountRead;
            NSMutableString* message = [NSMutableString new];
            BOOL bBytesAvailable = [inputStream hasBytesAvailable];
            while( bBytesAvailable ){
                iAmountRead = [inputStream read: buffer maxLength: BUFFER_LENGTH];
            
                if(iAmountRead){
                    [message appendString: [[NSString alloc] initWithBytes:buffer length:iAmountRead encoding:NSASCIIStringEncoding] ];
                }
                bBytesAvailable = [inputStream hasBytesAvailable];
            }
            [self messageReceived: message];
            
            if(activeViewController){
                
                int64_t delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.connectController dismissModalViewControllerAnimated: YES];
                    activeViewController = nil;
                    

                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        
                        if(toolTipView == nil){
                            [[NSBundle mainBundle] loadNibNamed: @"TouchTip" owner:self options:nil];
                        }
                        
                        [UIView beginAnimations: @"View Flip" context: nil ];
                        [UIView setAnimationDuration: 0.5];
                        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                        [UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView: self.view cache: YES];
                        [self.view addSubview: toolTipView];
                        [UIView	 commitAnimations];
                        
                        isLocked = YES;
                    
                    });
                });
                [connectionController showConnectionComplete];
            }
            
            
            
        }
    }
    else if(eventCode == NSStreamEventHasSpaceAvailable){
        TLog(@"Connection: Has Space");
    }
    else if(eventCode == NSStreamEventErrorOccurred){
        TLog(@"Connection: Error");
        [self OnConnectError: self];
    }
    else if(eventCode == NSStreamEventEndEncountered){
        TLog(@"Connection: End Found");
        if(currentStream == inputStream){
            inputStreamConnected = NO;
        }
        else if(currentStream == outputStream){
            outputStreamConnected = NO;
        }
        
        if(!self.isConnected){
            [self OnCloseConnection: self];
        }
        
    }
}

- (void) messageReceived: (NSString *)message{
    if(isLocked)
        return;
    
    NSLog(@"Message: %@", message);
    if(lastMessageRecieved != nil){
        NSTimeInterval i = [[NSDate date] timeIntervalSinceDate: lastMessageRecieved];
        TLog(@"%f", i);
    }
    lastMessageRecieved = [NSDate date];
    NSArray* vbInstructions = [message componentsSeparatedByString:@","];
    if( [vbInstructions count] != 6 ){
        TLog(@"Unknown Message Format");
        return;
    }
    
    int imageOne = [[vbInstructions objectAtIndex:0] intValue];
    int imageTwo = [[vbInstructions objectAtIndex:1] intValue];
    int imageThree = [[vbInstructions objectAtIndex:2] intValue];
    int imageFour = [[vbInstructions objectAtIndex:3] intValue];
    int imageFive = [[vbInstructions objectAtIndex:4] intValue];
    int imageSix = [[vbInstructions objectAtIndex:5] intValue];
    
    TLog(@"Image1 = %d", imageOne);
    TLog(@"Image2 = %d", imageTwo);
    TLog(@"Image3 = %d", imageThree);
    TLog(@"Image4 = %d", imageFour);
    TLog(@"Image5 = %d", imageFive);
    TLog(@"Image6 = %d", imageSix);
    
    [self SquareOne: imageOne];
    [self SquareTwo: imageTwo];
    [self SquareThree: imageThree];
    [self SquareFour: imageFour];
    [self SquareFive: imageFive];
    [self SquareSix: imageSix];
}

- (UIImage *) shape: (int) shapeImage{
    UIImage* stimulus = nil;
    switch (shapeImage) {
        case 1:
            stimulus = [UIImage imageNamed:@"1.bmp"];
            break;
        case 2:
            stimulus = [UIImage imageNamed:@"2.bmp"];
            break;
        case 3:
            stimulus = [UIImage imageNamed:@"3.bmp"];
            break;
        case 4:
            stimulus = [UIImage imageNamed:@"4.bmp"];
            break;
        case 5:
            stimulus = [UIImage imageNamed:@"5.bmp"];
            break;
        case 6:
            stimulus = [UIImage imageNamed:@"6.bmp"];
            break;
        case 7:
            stimulus = [UIImage imageNamed:@"7.bmp"];
            break;
    }
    return stimulus;
}

-(void) sendMessage: (NSString*) message{
    if(self.isConnected == NO){
        return;
    }
    NSString *response  = [NSString stringWithFormat:@"%@",message];
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write: (const unsigned char*) [data bytes] maxLength:[data length]];
}

- (IBAction) onPressButton: (id) sender{
    [self sendMessage: [NSString stringWithFormat: @"%i", [sender tag]]];
}

- (void) SquareOne: (int) shapevalue{
    UIButton *View1 = [UIButton buttonWithType:UIButtonTypeCustom];
    View1.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, 300, 300);
    View1.tag = 1;
    if (shapevalue != 0)
    {
        
        [View1 setBackgroundImage:[self shape: shapevalue] forState:(UIControlStateNormal)];
        
    }
    else {
        View1.backgroundColor = [UIColor blackColor];
    }
    [self.view addSubview:View1];
    TLog(@"Image 1 picture: %@", View1.currentBackgroundImage);
    [View1 addTarget:self action:@selector(onPressButton: ) forControlEvents:UIControlEventTouchDown];
}

- (void) SquareTwo: (int) shapevalue{
    UIButton *View2 = [UIButton buttonWithType:UIButtonTypeCustom];
    View2.frame = CGRectMake(self.view.bounds.size.height/2 - 25, self.view.bounds.origin.y, 300, 300);
    View2.tag = 2;
    if (shapevalue != 0)
    {
        
        [View2 setBackgroundImage:[self shape: shapevalue] forState:(UIControlStateNormal)];
        
    }
    else {
        View2.backgroundColor = [UIColor blackColor];
        
    }
    [self.view addSubview:View2];
    TLog(@"Image 2 picture: %@", View2.currentBackgroundImage);
    [View2 addTarget:self action:@selector(onPressButton: )  forControlEvents:UIControlEventTouchDown];
}

- (void) SquareThree: (int) shapevalue{
    UIButton *View3 = [UIButton buttonWithType:UIButtonTypeCustom];
    View3.frame = CGRectMake(self.view.bounds.size.height - 40, self.view.bounds.origin.y, 300, 300);
    View3.tag = 3;
    if (shapevalue != 0)
    {
        [View3 setBackgroundImage:[self shape: shapevalue] forState:(UIControlStateNormal)];
    }
    else {
        View3.backgroundColor = [UIColor blackColor];
    }
    [self.view addSubview:View3];
    TLog(@"Image 3 picture: %@", View3.currentBackgroundImage);
    [View3 addTarget:self action:@selector(onPressButton:)  forControlEvents:UIControlEventTouchDown];
}

- (void) SquareFour: (int) shapevalue{
    UIButton *View4 = [UIButton buttonWithType:UIButtonTypeCustom];
    View4.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.width/2 - 50, 300, 300);
    View4.tag = 4;
    if (shapevalue != 0)
    {
        [View4 setBackgroundImage:[self shape: shapevalue] forState:(UIControlStateNormal)];
    }
    else {
        View4.backgroundColor = [UIColor blackColor];
    }
    [self.view addSubview:View4];
    [View4 addTarget:self action:@selector(onPressButton:)  forControlEvents:UIControlEventTouchDown];
}

- (void) SquareFive: (int) shapevalue{
    UIButton *View5 = [UIButton buttonWithType:UIButtonTypeCustom];
    View5.frame = CGRectMake(self.view.bounds.size.height/2-25, self.view.bounds.size.width/2 - 50, 300, 300);
    View5.tag = 5;
    if (shapevalue != 0)
    {
        [View5 setBackgroundImage:[self shape: shapevalue] forState:(UIControlStateNormal)];
    }
    else {
        View5.backgroundColor = [UIColor blackColor];
    }
    [self.view addSubview:View5];
    [View5 addTarget:self action:@selector(onPressButton: )  forControlEvents:UIControlEventTouchDown];
}

- (void) SquareSix: (int) shapevalue{
    UIButton *View6 = [UIButton buttonWithType:UIButtonTypeCustom];
    View6.frame = CGRectMake(self.view.bounds.size.height-40, self.view.bounds.size.width/2 - 50, 300, 300);
    View6.tag = 6;
    if (shapevalue != 0)
    {
        [View6 setBackgroundImage:[self shape: shapevalue] forState:(UIControlStateNormal)];
    }
    else {
        View6.backgroundColor = [UIColor blackColor];
    }
    [self.view addSubview:View6];
    [View6 addTarget:self action:@selector(onPressButton: )  forControlEvents:UIControlEventTouchDown];
}

@end
