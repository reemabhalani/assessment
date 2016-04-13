//
//  GetDataVC.m
//  MacysTask
//
//  Created by Reema Vachhani on 4/12/16.
//  Copyright © 2016 jnvapps.com. All rights reserved.
//

#import "GetDataVC.h"

@interface GetDataVC ()

@end

@implementation GetDataVC

{
    MBRoundProgressView* currentProgress;
    
    NSArray* arrMeanings;
    
    AFHTTPSessionManager* operation;
}

@synthesize strParamValue;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = strParamValue;
    
    tblView.dataSource = self;
    tblView.delegate = self;
    
    currentProgress = [[MBRoundProgressView alloc] init];
    currentProgress.hidden = NO;
    currentProgress.progress = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = NSLocalizedString(@"Loading....", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self getMeanings];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
    });
  
}

- (void) getMeanings {
    
    NSString* baseUrl = @"http://www.nactem.ac.uk";
    NSString* path = [NSString stringWithFormat:@"/software/acromine/dictionary.py?sf=%@", strParamValue];
    // NSURL* uri = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseUrl, path]];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [manager GET:path
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
            NSLog(@"Progress: %@", downloadProgress);
            currentProgress.progress = downloadProgress.completedUnitCount;
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ( [responseObject isKindOfClass:[NSArray class]] ) {
                
                arrMeanings = [responseObject valueForKeyPath:@"lfs.lf.@firstObject"];
                
                [tblView reloadData];
            }
            else {
                
                // Error parsing expected JSON format, from server response.
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Json Parsing Error!"
                                                      message:@"Error parsing expected JSON format, from server response."                                                 preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                           handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController
                                   animated:YES
                                 completion:nil];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"Error: %@", error);
            
            // Alertview
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Error!"
                                                  message:[NSString stringWithFormat:@"%@", error.localizedDescription]                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController
                               animated:YES
                             completion:nil];
            
            
        }];
}


#pragma marks- UITableView Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrMeanings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *kcellIdentifier = @"cellResult";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kcellIdentifier];
    }
    
    if ( arrMeanings != nil ) {
        
        cell.textLabel.text = [arrMeanings objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
