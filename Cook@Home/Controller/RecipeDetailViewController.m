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
@synthesize recipes, firestore, authorRef;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    
    recipeName.text = [NSString stringWithFormat:@"Recipe for: %@", recipes[@"recipeName"]];
    recipeTags.text = [NSString stringWithFormat:@"Tags: %@", recipes[@"recipeTags"]];
    recipeIngredients.text = recipes[@"recipeIngredients"];
    recipeInstruction.text = recipes[@"recipeInstruction"];
    
    [self findName:recipes[@"userID"]];
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

- (IBAction)dislikeBtn:(id)sender {
}

- (IBAction)likeBtn:(id)sender {
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
