//
//  ViewController.h
//  LazyLoadImageWithSD
//
//  Created by apple on 14/12/5.
//  Copyright (c) 2014年 Fate.D.Saber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *data;

@end

