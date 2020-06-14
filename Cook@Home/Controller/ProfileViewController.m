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
    
}

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

- (void)changeName:(NSString *)newName{
    
    [userDocRef updateData:@{
        @"fullName": newName
    }completion:^(NSError * _Nullable error) {
        if( error != nil){
            NSLog(@"Error updating document: %@", error);
        }else{
            NSLog(@"Document successfully udpate");
            [self viewDidLoad];
        }
    }];
}

@end
