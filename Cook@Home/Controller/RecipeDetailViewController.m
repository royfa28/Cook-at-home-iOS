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

@synthesize recipeTags, recipeAuthor, recipeIngredients, recipeInstruction;
@synthesize cancelBtn, submitBtn, editBtn;
@synthesize recipes, firestore, authorRef, recipeColRef;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    
    firestore = FIRFirestore.firestore;
    
    NSLog(@"Doc ID: %@", recipes.documentID);
    
    cancelBtn.hidden = YES;
    submitBtn.hidden = YES;
    
    [self getData:recipes.documentID];
    [self checkAuthorToUser];
    [self findName:recipes[@"userID"]];
    
    NSLog(@"Doc snapshot: %@", recipes);
    NSLog(@"Doc id From detail: %@", recipes.documentID);
}

- (void)getData:(NSString *)recipeID{
    recipeColRef = [[firestore collectionWithPath:@"Recipes"] documentWithPath:recipeID];
    
    [recipeColRef addSnapshotListener:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if(snapshot == nil){
            NSLog(@"Error fetching document: %@", error);
            return;
        }else{
            self.navigationItem.title = snapshot.data[@"recipeName"];
            self->recipeTags.text = snapshot.data[@"recipeTags"];
            self->recipeIngredients.text = snapshot.data[@"recipeIngredients"];
            self->recipeInstruction.text = snapshot.data[@"recipeInstruction"];
        }
    }];
}

- (void)findName:(NSString *)authorID{

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
    [self viewDidLoad];
}

- (IBAction)submitBtnClick:(id)sender {
    
    [self nonEditable:@"no"];
    recipeColRef = [[firestore collectionWithPath:@"Recipes"] documentWithPath:recipes.documentID];
    
    [recipeColRef updateData:@{
        @"recipeIngredients": recipeIngredients.text,
        @"recipeInstruction": recipeInstruction.text
    } completion:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error writing document: %@", error);
        } else{
            [self viewDidLoad];
        }
    }];
    
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
