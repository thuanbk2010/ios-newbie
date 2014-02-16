#import <GameKit/GameKit.h>
#import "GameCenterViewController.h"
#import "SocialNetwork.h"

static NSString* const kAvatar = @"http://afarber.de/gc/%@.png";

@implementation GameCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchUser];
}

- (void)fetchUser
{
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            [self presentViewController:viewController
                               animated:YES
                             completion:nil];
            
        } else if (localPlayer.isAuthenticated) {
            NSLog(@"%s: displayName=%@ playerID=%@", __PRETTY_FUNCTION__,
                  [localPlayer alias],
                  [localPlayer playerID]);
            
            User *user = [[User alloc] init];
            user.key       = kGC;
            user.userId    = [localPlayer playerID];
            user.firstName = [localPlayer alias];
            user.avatar    = nil;
            [user save];

            [self loadAvatar:localPlayer];
            // [NSData base64EncodedDataWithOptions:]
            
            double delayInSeconds = 1;
            dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                [self performSegueWithIdentifier: @"replaceGameCenter" sender: self];
            });
        } else {
            [self showAlert:@"Game Center has been disabled."];
        }
        
        NSLog(@"%s: error=%@", __PRETTY_FUNCTION__, error);
    };
}

- (void)loadAvatar:(GKPlayer*)player
{
    [player loadPhotoForSize:GKPhotoSizeNormal withCompletionHandler:^(UIImage *photo, NSError *error) {
        if (error != nil) {
            NSLog(@"%s: error=%@", __PRETTY_FUNCTION__, error);
            return;
        }
        
        if (photo != nil) {
            NSData* data = UIImageJPEGRepresentation(photo, .75);
            NSLog(@"%s: photo=%@ data=%@", __PRETTY_FUNCTION__, photo, data);
        }
    }];
}

-(void)showAlert:(NSString*)msg
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"WARNING"
                                  message:msg
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end