//
//  LoginViewController.m
//  
//
//  Created by Natalie Ghidali on 7/9/18.
//

#import "LoginViewController.h"
#import "Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onLogin:(id)sender {
    [self loginUser];
}
- (IBAction)onSignUp:(id)sender {
    [self registerUser];
}
-(UIAlertController *)generateAlert:(NSString *) title message:(NSString *) message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                         }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    return alert;
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    if(newUser.username.length == 0 || newUser.password.length == 0){
        UIAlertController *alert = [self generateAlert:@"Registration Failed" message:@"Information is incomplete"];
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens a;fter the alert controller has finished presenting
        }];
    }
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
        }
    }];
    [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    if(username.length == 0 || password.length == 0){
        UIAlertController *alert = [self generateAlert:@"Registration Failed" message:@"Information is incomplete"];
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens a;fter the alert controller has finished presenting
        }];
    }
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
        }
    }];
    [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
