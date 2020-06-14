//
//  HomepageViewController.m
//  Cook@Home
//
//  Created by Roy felix Adekie on 11/6/20.
//  Copyright © 2020 Roy felix Adekie. All rights reserved.
//

#import "HomepageViewController.h"
#import "HomepageRecipesCell.h"

@interface HomepageViewController ()

@end

@implementation HomepageViewController{
    NSMutableArray<FIRDocumentSnapshot *> *_recipes;
}

@synthesize data, firestore, recipesColRef, tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    firestore = FIRFirestore.firestore;
    
    data = [[NSMutableArray alloc] init];
    recipesColRef = [firestore collectionWithPath:@"Recipes"];
    [self getRecipes];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomepageRecipesCell *cell = (HomepageRecipesCell *)[tableView dequeueReusableCellWithIdentifier:@"recipeList"];
    FIRDocumentSnapshot *recipesList = data[indexPath.row];

    cell.layer.borderColor = UIColor.orangeColor.CGColor;
//    NSLog(@"Recipe name: %@", recipesList);
    
    cell.recipeName.text = recipesList[@"recipeName"];
    cell.recipeTags.text = recipesList[@"recipeTags"];

    //Get image URL
//    NSString *result = recipesList[@"photoUrl"];
//    NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString:result]];
//    cell.recipeImage.image = [UIImage imageWithData:imageData];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (void) getRecipes{

    [recipesColRef addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if(snapshot == nil){
            NSLog(@"Error fetching documents: %@", error);
        }
        else{
            self->_recipes = [snapshot.documents copy];
            NSLog(@"Recipes %@", snapshot.documents);
            // Listen for snapshot changes
            for (FIRDocumentSnapshot *document in snapshot.documents){
                [self->data addObject:document.data];
                [self.tableView reloadData];
            }
        }
    }];
}

-(void)genericError:(NSString *)strmessage{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
        message: strmessage
        preferredStyle:UIAlertControllerStyleAlert];
     
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
        [self getRecipes];
    }];
     
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FIRDocumentSnapshot *recipe = data[indexPath.row];

}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    FIRDocumentSnapshot *recipe = _recipes[indexPath.row];
    
    if([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        
        RecipeDetailViewController *destViewController = segue.destinationViewController;
        destViewController.recipes = recipe;
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
