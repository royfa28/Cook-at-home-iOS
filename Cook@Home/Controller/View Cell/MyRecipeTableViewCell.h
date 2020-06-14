//
//  MyRecipeTableViewCell.h
//  Cook@Home
//
//  Created by Roy felix Adekie on 12/6/20.
//  Copyright © 2020 Roy felix Adekie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyRecipeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UILabel *recipeTags;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

NS_ASSUME_NONNULL_END
