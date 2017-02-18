//
//  ChapterListController.m
//  KFEpubParser
//
//  Created by zhuxuhong on 2017/2/17.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

#import "ChapterListController.h"


@interface ChapterCell ()

@end

@implementation ChapterCell

-(void)setChapter:(NSDictionary *)chapter{
    _chapter = chapter;
    NSMutableString *text = [NSMutableString string];
    for (int i=0; i<[chapter[@"level"] integerValue]; i++) {
        [text appendString:@"  "];
    }
    _label.text = [text stringByAppendingString:chapter[@"label"]];
}

@end


@interface ChapterListController ()

@end

@implementation ChapterListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationForDidOpenEpub:) name:@"DidOpenEpub" object:nil];
}

-(void)setChapters:(NSArray *)chapters{
    _chapters = chapters;
    [self.tableView reloadData];
}

-(void)notificationForDidOpenEpub: (NSNotification*)noti{
    self.chapters = noti.object;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _chapters.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChapterCell" forIndexPath:indexPath];
    cell.chapter = _chapters[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *chapter = _chapters[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSelectChapter" object:chapter];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
