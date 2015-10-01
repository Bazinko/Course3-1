//
//  AppViewController.m
//  Lesson1
//
//  Created by Azat Almeev on 21.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "AppViewController.h"
#import "DataManager.h"
#import "Object.h"
#import "CreatingCellViewController.h"
#import <ReactiveCocoa.h>
#import <KVOMutableArray+ReactiveCocoaSupport.h>
#import <BlocksKit+UIKit.h>

@interface AppViewController ()
@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    [[DataManager sharedInstance].objects.changeSignal subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        self.title = [NSString stringWithFormat:@"Items count: %@", @([tuple.first count])];
        NSKeyValueChange change = [tuple.second[NSKeyValueChangeKindKey] integerValue];
        NSArray *indices = [tuple.second[NSKeyValueChangeIndexesKey] bk_mapIndex:^id(NSUInteger index) {
            return [NSIndexPath indexPathForItem:index inSection:0];
        }];
        switch (change) {
            case NSKeyValueChangeInsertion:
                [self.tableView insertRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case NSKeyValueChangeRemoval:
                [self.tableView deleteRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case NSKeyValueChangeReplacement:
                [self.tableView reloadRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            default:
                [self.tableView reloadData];
                break;
        }
    }];
    
}

- (IBAction)logoutDidPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonDidPress:(id)sender {
    [self performSegueWithIdentifier:@"edit" sender:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DataManager sharedInstance].objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    Object *objects = [[DataManager sharedInstance] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", objects.number];
    cell.detailTextLabel.text = objects.text;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[DataManager sharedInstance] deleteObjectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"edit" sender:indexPath];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"edit"]) {
        CreatingCellViewController *create = segue.destinationViewController;
        if (sender) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            create.isNew = NO;
            create.objectIndex = indexPath.row;
        } else {
            create.isNew = YES;
        }
    }
}

@end
