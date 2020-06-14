//
//  MyRecipeTableViewController.h
//  Cook@Home
//
//  Created by Roy felix Adekie on 12/6/20.
//  Copyright © 2020 Roy felix Adekie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRecipeTableViewCell.h"
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface MyRecipeTableViewController : UITableViewController

@property FIRFirestore *firestore;
@property FIRCollectionReference *myRecipesColRef, *recipesColRef;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *data;

@end

NS_ASSUME_NONNULL_END
