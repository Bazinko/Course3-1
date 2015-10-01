//
//  CreatingCellViewController.m
//  Lesson1
//
//  Created by Евгений Сергеев on 01.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "CreatingCellViewController.h"
#import "Object.h"
#import "DataManager.h"
#import <ReactiveCocoa.h>

@interface CreatingCellViewController ()

@end

@implementation CreatingCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Object *object;
    
    if (self.isNew) {
        object = [[Object alloc] initWithNumber:0 text:@""];
        self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)object.number];
        [self.slider setValue:0 animated:YES];
    } else {
        object = [[DataManager sharedInstance]objectAtIndex:self.objectIndex];
        self.numberLabel.text = [NSString stringWithFormat:@"%ld", object.number];
        
        [self.slider setValue:object.number animated:YES];
        self.stringTextField.text = object.text;
    }
    
    @weakify(self);
    [[self.slider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISlider *slider) {
        @strongify(self);
        object.number = slider.value;
        self.numberLabel.text = [NSString stringWithFormat:@"%ld", object.number];
    }];
    
    RAC(self.saveButton, enabled) = [RACSignal combineLatest:@[self.stringTextField.rac_textSignal,RACObserve(object,number)] reduce:^(NSString *login,NSNumber *number){
        NSInteger sliderValue = [number integerValue];
        return @(login.length == sliderValue);
    }];
    
    [[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         object.text = self.stringTextField.text;
         if (self.isNew) {
             [[DataManager sharedInstance]addObject:object];
         }else{
             [[DataManager sharedInstance]saveObject:object atIndex:self.objectIndex];
         }
         [self.navigationController popViewControllerAnimated:YES];
     }];
    
    
}

- (IBAction)sliderChange:(id)sender {
    self.numberLabel.text = [NSString stringWithFormat:@"%d", (int)self.slider.value];
}


@end
