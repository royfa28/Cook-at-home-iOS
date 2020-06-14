//
//  RecipeDetailViewController.h
//  Cook@Home
//
//  Created by Roy felix Adekie on 12/6/20.
//  Copyright © 2020 Roy felix Adekie. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface RecipeDetailViewController : UIViewController

@property FIRDocumentSnapshot *recipes;
@property FIRFirestore *firestore;
@property FIRDocumentReference *authorRef;

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UILabel *recipeAuthor;
@property (weak, nonatomic) IBOutlet UITextView *recipeIngredients;
@property (weak, nonatomic) IBOutlet UITextView *recipeInstruction;
@property (weak, nonatomic) IBOutlet UILabel *recipeTags;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)editBtnClick:(id)sender;
- (IBAction)likeBtn:(id)sender;
- (IBAction)dislikeBtn:(id)sender;
- (IBAction)submitBtnClick:(id)sender;
- (IBAction)cancelBtnClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
