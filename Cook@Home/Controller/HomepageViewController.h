//
//  HomepageViewController.h
//  Cook@Home
//
//  Created by Roy felix Adekie on 11/6/20.
//  Copyright © 2020 Roy felix Adekie. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface HomepageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property FIRFirestore *firestore;
@property FIRCollectionReference *recipesColRef;

@end

NS_ASSUME_NONNULL_END
