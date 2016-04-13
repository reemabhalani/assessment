//
//  ViewController.m
//  MacysTask
//
//  Created by Reema Vachhani on 4/11/16.
//  Copyright © 2016 jnvapps.com. All rights reserved.
//

#import "ViewController.h"
#import "GetDataVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Welcome";
}

- (IBAction) btnShowMeaningsTapped:(id)sender {
    
    [txtParam resignFirstResponder];
    
    GetDataVC *obj = [[GetDataVC alloc] initWithNibName:@"GetDataVC"
                                                 bundle:nil];
    
    obj.strParamValue = [txtParam.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
