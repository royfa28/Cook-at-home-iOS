//
//  RecipeDetailViewController.m
//  Cook@Home
//
//  Created by Roy felix Adekie on 12/6/20.
//  Copyright © 2020 Roy felix Adekie. All rights reserved.
//

#import "RecipeDetailViewController.h"

@interface RecipeDetailViewController ()

@end

@implementation RecipeDetailViewController

@synthesize recipeName,recipeTags, recipeAuthor, recipeIngredients, recipeInstruction;
@synthesize cancelBtn, submitBtn, editBtn;
@synthesize recipes, firestore, authorRef;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = recipes[@"recipeName"];

    self.navigationController.navigationBarHidden = NO;

    recipeTags.text = [NSString stringWithFormat:@"Tags: %@", recipes[@"recipeTags"]];
    recipeIngredients.text = recipes[@"recipeIngredients"];
    recipeInstruction.text = recipes[@"recipeInstruction"];

    NSLog(@"Doc ID: %@", recipes.documentID);
    [self findName:recipes[@"userID"]];
    
    cancelBtn.hidden = YES;
    submitBtn.hidden = YES;
    [self checkAuthorToUser];
    
}

- (void)findName:(NSString *)authorID{
    firestore = FIRFirestore.firestore;
    authorRef = [[firestore collectionWithPath:@"Users"] documentWithPath: authorID];
    
    [authorRef getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if(snapshot.exists){
            
            if([snapshot.data[@"fullName"] isEqualToString:@""]){
                self->recipeAuthor.text = @"Author: Anonymous";
            }else{
                self->recipeAuthor.text = [NSString stringWithFormat:@"Author : %@", snapshot.data[@"fullName"]];
            }
        } else{
            NSLog(@"Document does not exist");
        }
    }];
}

- (void)checkAuthorToUser{
    
    NSString *uid;
    FIRUser *user = [FIRAuth auth].currentUser;
    if(user){
        uid = user.uid;
    }
    
    if([uid isEqualToString:recipes[@"userID"]]){
        editBtn.hidden = NO;
    }else{
        editBtn.hidden = YES;
    }
}

- (IBAction)cancelBtnClick:(id)sender {
    [self nonEditable:@"no"];
}

- (IBAction)submitBtnClick:(id)sender {
    
    [self nonEditable:@"no"];
}

- (IBAction)dislikeBtn:(id)sender {
}

- (IBAction)likeBtn:(id)sender {
}

- (IBAction)editBtnClick:(id)sender {
    
    [self nonEditable:@"yes"];

}

- (void)nonEditable:(NSString *)value{
    
    if([value isEqualToString:@"no"]){
        editBtn.hidden = NO;
        cancelBtn.hidden = YES;
        submitBtn.hidden = YES;
        
        recipeIngredients.editable = NO;
        recipeInstruction.editable = NO;
    }else{
        editBtn.hidden = YES;
        cancelBtn.hidden = NO;
        submitBtn.hidden = NO;
        
        recipeIngredients.editable = YES;
        recipeInstruction.editable = YES;
    }
    
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
