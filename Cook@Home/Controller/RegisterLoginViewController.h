//
//  RegisterLoginViewController.h
//  Cook@Home
//
//  Created by Roy felix Adekie on 7/6/20.
//  Copyright © 2020 Roy felix Adekie. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface RegisterLoginViewController : UIViewController

@property FIRAuth *firAuth;

@property (weak, nonatomic) IBOutlet UITextField *loginEmailText;
@property (weak, nonatomic) IBOutlet UITextField *loginPassText;

@property (weak, nonatomic) IBOutlet UITextField *registerEmailText;
@property (weak, nonatomic) IBOutlet UITextField *registerPassText;
@property (weak, nonatomic) IBOutlet UITextField *registerRepeatPassText;

- (IBAction)loginBtn:(id)sender;
- (IBAction)registerBtn:(id)sender;


@end

NS_ASSUME_NONNULL_END
