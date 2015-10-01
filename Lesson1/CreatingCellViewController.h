//
//  CreatingCellViewController.h
//  Lesson1
//
//  Created by Евгений Сергеев on 01.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TestViewDelegate <NSObject>
@end

@interface CreatingCellViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UITextField *stringTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonatomic) BOOL isNew;
@property (assign, nonatomic) NSInteger objectIndex;

@end
