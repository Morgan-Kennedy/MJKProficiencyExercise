//
//  ViewController.m
//  ProficiencyExercise
//
//  Created by Morgan Kennedy on 19/01/2015.
//  Copyright (c) 2015 MorganKennedy. All rights reserved.
//

#import "ViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "APIManager.h"
#import <SIAlertView.h>
#import "Fact.h"
#import "FactNode.h"
#import "UIColor+HexString.h"
#import "Constants.h"
#import <MBProgressHUD.h>

@interface ViewController () <ASTableViewDataSource, ASTableViewDelegate>

@property (nonatomic, strong) ASTableView *tableView;
@property (nonatomic, strong) NSMutableArray *facts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) MBProgressHUD *progressHUD;

- (void)refreshFacts;

@end

@implementation ViewController

#pragma mark -
#pragma mark - Lifecycle Methods
- (instancetype)init
{
    if (!(self = [super init]))
        return nil;
    
    _tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // KittenNode has its own separator
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.asyncDataSource = self;
    _tableView.asyncDelegate = self;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:TableViewBackgroundColor withAlpha:1.0f];
    
    [self.view addSubview:self.tableView];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshFacts) forControlEvents:UIControlEventValueChanged];
    
    self.facts = @[].mutableCopy;
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self refreshFacts];
}

- (void)viewWillLayoutSubviews
{
    self.tableView.frame = self.view.bounds;
}

#pragma mark -
#pragma mark - Private Methods
- (void)refreshFacts
{
    [[APIManager sharedAPIManager] getFactsWithCompletion:^(NSString *title, NSArray *facts, BOOL success, NSError *error) {
        [self.refreshControl endRefreshing];
        [self.progressHUD hide:YES];
        
        if (success)
        {
            [self.facts removeAllObjects];
            
            self.title = title;
            
            [self.facts addObjectsFromArray:facts];
            
            [self.tableView reloadData];
        }
        else
        {
            SIAlertView *errorLoadingFacts = [[SIAlertView alloc] initWithTitle:@"Error"
                                                                     andMessage:[NSString stringWithFormat:@"Error loading Facts: %@", error.localizedDescription]];
            
            [errorLoadingFacts addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
            
            [errorLoadingFacts addButtonWithTitle:@"Refresh"
                                             type:SIAlertViewButtonTypeDefault
                                          handler:^(SIAlertView *alertView) {
                                              [self refreshFacts];
                                          }];
            
            errorLoadingFacts.transitionStyle = SIAlertViewTransitionStyleDropDown;
            
            [errorLoadingFacts show];
        }
    }];
}

#pragma mark -
#pragma mark - ASTableViewDataSource Methods
- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FactNode *node = [[FactNode alloc] initWithFact:[self.facts objectAtIndex:indexPath.row]
                                          isOddCell:(indexPath.row % 2)];
    return node;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.facts.count;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


@end
