//
//  ProfileViewController.h
//  Cook@Home
//
//  Created by Roy felix Adekie on 14/6/20.
//  Copyright © 2020 Roy felix Adekie. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property FIRFirestore *firestore;
@property FIRDocumentReference *userDocRef;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;

- (IBAction)editPassBtn:(id)sender;
- (IBAction)editNameBtn:(id)sender;

@end

NS_ASSUME_NONNULL_END
