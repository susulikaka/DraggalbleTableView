//
//  ViewController.m
//  EditableTableView
//
//  Created by SupingLi on 16/8/29.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "ViewController.h"
#import "EditTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray arrayWithObjects:@"aa",@"bb",@"cc",@(1),@"dd",@"ee",@"ff",@"gg",@(2), nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([EditTableViewCell class])];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:@"textChange" object:nil];
}

- (void)textChange {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (IBAction)editAction:(id)sender {
    UIButton * btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    [self.tableView setEditing:btn.selected animated:YES];
    [self.tableView reloadData];
}

#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    id xx = self.dataSource[sourceIndexPath.row];
    [self.dataSource removeObjectAtIndex:sourceIndexPath.row];
    [self.dataSource insertObject:xx atIndex:destinationIndexPath.row];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.dataSource removeObjectAtIndex:indexPath.row];
    } else if(editingStyle == UITableViewCellEditingStyleInsert) {
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.dataSource insertObject:@"" atIndex:indexPath.row];
    } else if (editingStyle == UITableViewCellEditingStyleNone) {
        EditTableViewCell *cell = (EditTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:cell.text.text];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    if (!self.tableView.isEditing) {
    if (![self.dataSource[indexPath.row] isKindOfClass:[NSString class]]) {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.dataSource[indexPath.row]]];
    } else {
        cell.textLabel.text = self.dataSource[indexPath.row];
        [cell.textLabel sizeToFit];
        cell.textLabel.numberOfLines = 0;
    }
    return cell;
    } else {
        
        EditTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditTableViewCell class])];
        
        [cell renderWithBlock:^(id obj) {
            [self.dataSource replaceObjectAtIndex:indexPath.row withObject:obj];
            [self.tableView reloadData];
        }];
        if ([self.dataSource[indexPath.row] isKindOfClass:[NSString class]]) {
            cell.text.text = self.dataSource[indexPath.row];
        } else {
            cell.text.text = [NSString stringWithFormat:@"%@",self.dataSource[indexPath.row]];
        }
        return cell;
    }
}

@end
