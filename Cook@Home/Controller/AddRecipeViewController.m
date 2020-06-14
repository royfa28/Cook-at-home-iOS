//
//  AddRecipeViewController.m
//  Cook@Home
//
//  Created by Roy felix Adekie on 11/6/20.
//  Copyright © 2020 Roy felix Adekie. All rights reserved.
//

#import "AddRecipeViewController.h"

@interface AddRecipeViewController ()

@end

@implementation AddRecipeViewController

@synthesize recipeName, recipeTags, recipeIngredients, recipeInstruction;

@synthesize recipesColRef, firestore;

NSString *uid;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    
    FIRUser *user = [FIRAuth auth].currentUser;
    if(user){
        uid = user.uid;
    }
    // Initialize the firestore
    firestore = FIRFirestore.firestore;
}

- (IBAction)submitBtn:(id)sender {
    
    // Set the path of the collection
    recipesColRef = [firestore collectionWithPath:@"Recipes"];

    if ([self validation]){
        // Write to Databaes based on the Collection Reference path with the input from user
        
        __block FIRDocumentReference *ref = [recipesColRef addDocumentWithData:@{
            @"recipeName":          recipeName.text,
            @"recipeTags":          recipeTags.text,
            @"recipeIngredients":   recipeIngredients.text,
            @"recipeInstruction":   recipeInstruction.text,
            @"userID":              uid,
            @"likes":               @(0),
            @"dislikes":            @(0),
            
        }completion:^(NSError * _Nullable error) {

            if( error != nil){
                NSLog(@"Error");
            }else{

                // If the write is successful it will go to another function
                [self addToUser:ref.documentID];
            }
        }];
    };
    
}

- (IBAction)cancelBtn:(id)sender {
    UIViewController *uvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Homepage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController pushViewController:uvc animated:YES];
}

- (IBAction)addImageBtn:(id)sender {
    
    if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self displayAlertView:@"Camera not found"];

    } else {

        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraPicker.delegate =self;
        // Show image picker
        [self presentViewController:cameraPicker animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Get the selected image
//    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    // Generate data from image selected
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    // Create file metadata
    FIRStorageMetadata *metaData = [[FIRStorageMetadata alloc] init];
    metaData.contentType = @"image/jpeg";
    
    // Get a referenece to the storage service using firebase default
    FIRStorage *storage = [FIRStorage storage];
    
    // Create storage reference
    FIRStorageReference *storageRef = [storage reference];
    
    // Upload file and metadata to the object
    FIRStorageUploadTask *uploadTask = [storageRef putData:imageData metadata:metaData];
    
    // Listen for state changes
    [uploadTask observeStatus:FIRStorageTaskStatusResume handler:^(FIRStorageTaskSnapshot * _Nonnull snapshot) {
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];

}

// This function is ot write it on user page
- (void)addToUser:(NSString *)docID{
    FIRCollectionReference *userRecipes = [[[firestore collectionWithPath:@"Users"] documentWithPath:uid]
                                           collectionWithPath:@"User Recipes"];
    
    [[userRecipes documentWithPath:docID] setData:@{
        @"recipeName":          recipeName.text,
        @"recipeTags":          recipeTags.text,
        @"recipeIngredients":   recipeIngredients.text,
        @"recipeInstruction":   recipeInstruction.text,
        @"userID":              uid
        
    }completion:^(NSError * _Nullable error) {
        
        if( error != nil){
            NSLog(@"Error");
        }else{
            UIViewController *uvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Homepage"];
            [self.navigationController pushViewController:uvc animated:YES];
            
            [self displayAlertView:@"Success"];
        }
    }];
}


- (BOOL)validation{
    
    NSString *strName = [recipeName.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    NSString *strTags = [recipeTags.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    NSString *strIngredients = [recipeIngredients.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    NSString *strInstruction = [recipeInstruction.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    
    // Checking all 3 input fields does for input
    if (strName.length              <= 0){
        [self displayAlertView:@"The recipe name field must be filled"];
        return NO;
    }
    else if(strTags.length          <= 0){
        [self displayAlertView:@"The tags field must be filled"];
        return NO;
    }
    else if(strIngredients.length   <= 0){
        [self displayAlertView:@"The ingredients field must be filled"];
        return NO;
    }
    else if(strInstruction.length   <= 0){
        [self displayAlertView:@"The instruction field must be filled"];
        return NO;
    }
    
    return YES;
}

-(void)displayAlertView:(NSString *)strMessage{
    
    // Making own alert box
    
    if([strMessage isEqualToString:@"Success"]){
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
            message:@"Added your recipe to Database"
            preferredStyle:UIAlertControllerStyleAlert];
         
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
            message:strMessage
            preferredStyle:UIAlertControllerStyleAlert];
         
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
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
