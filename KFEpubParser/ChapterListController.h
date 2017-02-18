//
//  ChapterListController.h
//  KFEpubParser
//
//  Created by zhuxuhong on 2017/2/17.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChapterCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@property(nonatomic, strong)NSDictionary *chapter;

@end


@interface ChapterListController : UITableViewController

@property(nonatomic,strong)NSArray *chapters;

@end
