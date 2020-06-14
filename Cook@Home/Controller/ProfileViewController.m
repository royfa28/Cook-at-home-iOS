//
//  ProfileViewController.m
//  Cook@Home
//
//  Created by Roy felix Adekie on 14/6/20.
//  Copyright © 2020 Roy felix Adekie. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize userDocRef, firestore;
@synthesize fullNameTxt, emailTxt;

NSString *userID;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    if(user){
        userID = user.uid;
        emailTxt.text = user.email;
    }

    firestore = FIRFirestore.firestore;
    userDocRef = [[firestore collectionWithPath:@"Users"]documentWithPath:userID];

    [userDocRef getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if(snapshot.exists){
            self->fullNameTxt.text = snapshot.data[@"fullName"];
            NSLog(@"Full Name is: %@", snapshot.data[@"fullName"]);
        }else{
            NSLog(@"Document does not exist");
        }
    }];
}

- (IBAction)editNameBtn:(id)sender {
    [self editName];
}

- (IBAction)editPassBtn:(id)sender {
    [self editPassword];
}

#pragma mark - UIAlertView  methods
- (void)editName{
    
    UIAlertController* dialogBox = [UIAlertController alertControllerWithTitle:@"Insert new full name"
        message:@""
        preferredStyle:UIAlertControllerStyleAlert];
     
    UIAlertAction *submitButton = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
        [self changeName:(dialogBox.textFields[0].text)];
        NSLog(@"Full name: %@", dialogBox.textFields[0].text);
    }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive
        handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [dialogBox addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Full name";
        textField.textColor = [UIColor blueColor];
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
     
    [dialogBox addAction:submitButton];
    [dialogBox addAction:cancelButton];
    [self presentViewController:dialogBox animated:YES completion:nil];
}

- (void)editPassword{
    UIAlertController* dialogBox = [UIAlertController alertControllerWithTitle:@"Insert new password"
        message:@""
        preferredStyle:UIAlertControllerStyleAlert];
     
    UIAlertAction *submitButton = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
        [self newPass:(dialogBox.textFields[0].text) repeatPass:(dialogBox.textFields[1].text)];
    }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive
        handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [dialogBox addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"New password";
        textField.textColor = [UIColor blueColor];
        textField.secureTextEntry = true;
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    
    [dialogBox addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Repeat new password";
        textField.textColor = [UIColor blueColor];
        textField.secureTextEntry = true;
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
     
    [dialogBox addAction:submitButton];
    [dialogBox addAction:cancelButton];
    [self presentViewController:dialogBox animated:YES completion:nil];
}

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

- (void)changeName:(NSString *)newName{
    
    [userDocRef updateData:@{
        @"fullName": newName
    }completion:^(NSError * _Nullable error) {
        if( error != nil){
            [self displayAlertView:error.localizedDescription];
        }else{
            [self displayAlertView:@"Name updated"];
            [self viewDidLoad];
        }
    }];
}

- (void)newPass:(NSString *)newPassword repeatPass: (NSString *)repeatPass{
    NSLog(@"New pass: %@", newPassword);
    NSLog(@"Repeat pass: %@", repeatPass);
    
    if([self validation:newPassword repeatPass:repeatPass]){
        FIRUser *user = [FIRAuth auth].currentUser;
        [user updatePassword:newPassword completion:^(NSError * _Nullable error) {
            if (error) {
                [self displayAlertView:error.localizedDescription];
                NSLog(@"Error in FIRAuth := %@",error.localizedDescription);
            }
            else{
                NSLog(@"Password changed: ");
            }
        }];
    }
    
}

- (BOOL)validation:(NSString *)newPass repeatPass: (NSString *)repeatPass{
    // Checking all 2 input fields for input
    if (newPass.length <= 0){
        [self displayAlertView:@"Please enter password"];
        return NO;
    }
    else if (repeatPass.length <= 0){
        [self displayAlertView:@"Please enter confirm password"];
        return NO;
    }
    else if (![newPass isEqualToString:repeatPass]){
        [self displayAlertView:@"Password and confirm password does not match"];
        return NO;
    }
    
    return YES;
}

@end
