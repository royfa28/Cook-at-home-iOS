//
//  RegisterLoginViewController.m
//  Cook@Home
//
//  Created by Roy felix Adekie on 7/6/20.
//  Copyright © 2020 Roy felix Adekie. All rights reserved.
//

#import "RegisterLoginViewController.h"

@interface RegisterLoginViewController ()

@end

@implementation RegisterLoginViewController

@synthesize loginPassText, loginEmailText, registerPassText, registerEmailText, registerRepeatPassText, firAuth;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Check if the user is logged in or not
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *auth, FIRUser *user) {
        if (user!= nil) {
            [self goToHomeScreen];
        }else{
            
        }
    }];
    
}

- (IBAction)registerBtn:(id)sender {
    
    // Validation is for checking email and password correctness
    if([self validation]){
        [[FIRAuth auth] createUserWithEmail:registerEmailText.text password:registerPassText.text
                                 completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if (error) {
                [self displayAlertView:error.localizedDescription];
                NSLog(@"Error in FIRAuth := %@",error.localizedDescription);
            }
            else{
                NSLog(@"user Id : %@", authResult.user.uid);
                [self writetoDB];
                
            }
        }];
    }
    
}

- (IBAction)loginBtn:(id)sender {
    
    // Check with firebase database for user email and password
    
    if ([self validationLogin]){

        [[FIRAuth auth] signInWithEmail:loginEmailText.text password:loginPassText.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            
            // If error == true then display error message
            if (error) {
                [self displayAlertView:@"Wrong password / email"];
                NSLog(@"Error in FIRAuth := %@",error.localizedDescription);
            }
            
            // Else go to homepage
            else{
                self.loginEmailText.text = @"";
                self.loginPassText.text = @"";
                NSLog(@"user Id : %@", authResult.user.uid);

                [self success:@"Successfully login with Firebase."];
            }
        }];
    }
}

-(void)goToHomeScreen{
    UIViewController *uvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Homepage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController pushViewController:uvc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - All Validation methods
- (BOOL)validation{
    
    NSString *strEmailID = [registerEmailText.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    NSString *strPassword = [registerPassText.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    NSString *strConfirmPassword = [registerRepeatPassText.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    
    // Checking all 3 input fields does for input
    if (strEmailID.length <= 0){
        [self displayAlertView:@"Please enter email Id"];
        return NO;
    }
    else if ([self validateEmailAddress:strEmailID] == NO){
        [self displayAlertView:@"Please enter valid email Id"];
        return NO;
    }
    else if (strPassword.length <= 0){
        [self displayAlertView:@"Please enter password"];
        return NO;
    }
    else if (strConfirmPassword.length <= 0){
        [self displayAlertView:@"Please enter confirm password"];
        return NO;
    }
    else if (![strPassword isEqualToString:strConfirmPassword]){
        [self displayAlertView:@"Password and confirm password does not match"];
        return NO;
    }
    
    return YES;
}

-(BOOL)validationLogin{
    NSString *strEmailID = [loginEmailText.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    NSString *strPassword = [loginPassText.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    
    // Checking both text field in login screen
    if (strEmailID.length <= 0){
        [self displayAlertView:@"Please enter email Id"];
        return NO;
    }
    else if (strPassword.length <= 0){
        [self displayAlertView:@"Password cannot be empty"];
        return NO;
    }
    else if ([self validateEmailAddress:strEmailID] == NO){
        [self displayAlertView:@"Please enter valid email Id"];
        return NO;
    }
    return YES;
}

-(BOOL)validateEmailAddress:(NSString *)checkString{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    
    // Parameter for checking email address
    
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - UIAlertView  methods
-(void)displayAlertView:(NSString *)strMessage{
    
    
    // Making own alert box
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
        message:strMessage
        preferredStyle:UIAlertControllerStyleAlert];
     
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {}];
     
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)success:(NSString *)strMessage{
    
    // Custom message for different alert
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Welcome"
        message:strMessage
        preferredStyle:UIAlertControllerStyleAlert];
     
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
//        [self goToHomeScreen];
    }];
     
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)writetoDB{
    
    NSString *uid;
    NSString *email;
    
    // Getting the unique key value generated from Firebase Auth and storing it.
    FIRUser *user = [FIRAuth auth].currentUser;
    if(user){
        uid = user.uid;
        email = user.email;
    }
    FIRFirestore *db = FIRFirestore.firestore;
    
    NSLog(@"user is %@", uid);
    
    [[[db collectionWithPath:@"Users"] documentWithPath:uid] setData:@{
        @"fullName": @"",
        @"email": email
    } completion:^(NSError * _Nullable error) {
      if (error != nil) {
        NSLog(@"Error writing document: %@", error);
      } else {
        NSLog(@"Document successfully written!");
      }
    }];
    [self success:@"Successfully signup with Firebase."];
}


@end
