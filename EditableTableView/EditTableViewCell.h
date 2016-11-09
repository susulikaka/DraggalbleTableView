//
//  EditTableViewCell.h
//  EditableTableView
//
//  Created by SupingLi on 16/8/29.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTableViewCell : UITableViewCell

@property (copy, nonatomic) void(^changeTextBlock)(id obj);
@property (weak, nonatomic) IBOutlet UITextView *text;

- (void)renderWithBlock:(void(^)(id obj))changeTextBlock;

@end
