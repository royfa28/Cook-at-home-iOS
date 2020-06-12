//
//  AddRecipeViewController.h
//  Cook@Home
//
//  Created by Roy felix Adekie on 11/6/20.
//  Copyright © 2020 Roy felix Adekie. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface AddRecipeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *recipeName;
@property (weak, nonatomic) IBOutlet UITextField *recipeTags;
@property (weak, nonatomic) IBOutlet UITextView *recipeIngredients;
@property (weak, nonatomic) IBOutlet UITextView *recipeInstruction;

@property FIRCollectionReference *recipesColRef;
@property FIRFirestore *firestore;

- (IBAction)addImageBtn:(id)sender;
- (IBAction)submitBtn:(id)sender;
- (IBAction)cancelBtn:(id)sender;


@end

NS_ASSUME_NONNULL_END
