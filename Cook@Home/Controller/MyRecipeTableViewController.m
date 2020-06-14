//
//  MyRecipeTableViewController.m
//  Cook@Home
//
//  Created by Roy felix Adekie on 12/6/20.
//  Copyright © 2020 Roy felix Adekie. All rights reserved.
//

#import "MyRecipeTableViewController.h"

@interface MyRecipeTableViewController ()

@end

@implementation MyRecipeTableViewController{
    NSMutableArray<FIRDocumentSnapshot *> *_myRecipes;
}

@synthesize data, firestore, myRecipesColRef, tableView, recipesColRef;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *uid;
    FIRUser *user = [FIRAuth auth].currentUser;
    if(user){
        uid = user.uid;
    }
    
    data = [[NSMutableArray alloc] init];
    firestore = FIRFirestore.firestore;
    myRecipesColRef = [[[firestore collectionWithPath:@"Users"] documentWithPath:uid] collectionWithPath:@"User Recipes"];
    
    // This function is to get the whole documents in the collection of recipes based on the user ID
    [myRecipesColRef getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
        if(snapshot == nil){
            NSLog(@"Error fetching document: %@", error);
        }else{
            for (FIRDocumentSnapshot *document in snapshot.documents){
                
                self->_myRecipes = [snapshot.documents copy];
                [self->data addObject:document.data];
                NSLog(@"My recipes: %@", self->data);
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyRecipeTableViewCell *cell = (MyRecipeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"myRecipes"];
    
    FIRDocumentSnapshot *myRecipe = _myRecipes[indexPath.row];

    cell.recipeName.text = [NSString stringWithFormat:@"Recipe: %@", myRecipe[@"recipeName"]];
    cell.recipeTags.text = [NSString stringWithFormat:@"Tags: %@", myRecipe[@"recipeTags"]];
    
    // Get image URL
    NSString *result = myRecipe[@"photoUrl"];
    NSLog(@"Image %@", result);
    NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString:result]];
    cell.recipeImage.image = [UIImage imageWithData:imageData];
    
    [cell.deleteBtn addTarget:self action:@selector(delete :) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

#pragma mark - Firestore function
- (void)delete:(id)sender{
    
    // Get index of row clicked
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:touchPoint];
    
    // Deleting your recipe from Users/uid/User Recipes path
    FIRDocumentSnapshot *myRecipe = _myRecipes[indexPath.row];
    NSLog(@"Doc id :%@", [myRecipe documentID]);

    [[myRecipesColRef documentWithPath:[myRecipe documentID]] deleteDocumentWithCompletion:^(NSError *error) {
        if (error != nil){
            NSLog(@"Error removing document: %@", error);
        }else{
            NSLog(@"Document removed");
            [self recipeRemoved];
        }
    }];
    
    // Deleting recipe from Recipes path
    recipesColRef = [firestore collectionWithPath:@"Recipes"];
    [[recipesColRef documentWithPath:[myRecipe documentID]] deleteDocumentWithCompletion:^(NSError * _Nullable error) {
        if (error != nil){
                NSLog(@"Error removing document: %@", error);
            }else{
                NSLog(@"Document removed");
                [self recipeRemoved];
            }
    }];
    
    [[self tableView ]reloadData];
}

#pragma mark - UI AlertView methods

-(void)recipeRemoved{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
        message:@"Product has been removed"
        preferredStyle:UIAlertControllerStyleAlert];
     
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
        [self.tableView reloadData];
    }];
     
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
