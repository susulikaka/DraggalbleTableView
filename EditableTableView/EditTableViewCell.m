//
//  EditTableViewCell.m
//  EditableTableView
//
//  Created by SupingLi on 16/8/29.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "EditTableViewCell.h"

@interface EditTableViewCell ()<UITextViewDelegate>

@end

@implementation EditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.text.delegate = self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self changeMoveBtn];
}

- (void)changeMoveBtn {
    if (self.isEditing) {
        
        if ([self.subviews isKindOfClass:[UIImageView class]]) {
            UIImageView *c = self.subviews.lastObject.subviews.lastObject;
            c.backgroundColor = [UIColor clearColor];
            c.image = [UIImage imageNamed:@"1"];
        }
        
    }
}

#pragma mark - private method

- (void)renderWithBlock:(void (^)(id obj))changeTextBlock {
    self.changeTextBlock = changeTextBlock;
}

#pragma mark - delegate

- (void)textViewDidChange:(UITextView *)textView {
    CGRect bounds = textView.bounds;
    CGSize maxSize = CGSizeMake(bounds.size.width, 10000);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textChange" object:nil];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (self.changeTextBlock) {
        self.changeTextBlock(textView.text);
    }
}

@end
