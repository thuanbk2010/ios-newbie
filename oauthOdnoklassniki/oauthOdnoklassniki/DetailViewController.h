#import <UIKit/UIKit.h>
#import "User.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
