//
//  GetDataVC.h
//  MacysTask
//
//  Created by Reema Vachhani on 4/12/16.
//  Copyright © 2016 jnvapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPSessionManager.h>
#import <AFURLRequestSerialization.h>
#import <MBProgressHUD.h>

@interface GetDataVC : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {
    
    IBOutlet UITableView *tblView;
}

@property (nonatomic) NSString* strParamValue;

@end
