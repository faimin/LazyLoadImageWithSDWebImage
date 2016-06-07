//
//  ViewController.m
//  LazyLoadImageWithSD
//
//  Created by apple on 14/12/5.
//  Copyright (c) 2014年 Fate.D.Saber. All rights reserved.
//
//  官方懒加载的Demo : https://developer.apple.com/library/ios/samplecode/LazyTableImages/Introduction/Intro.html#//apple_ref/doc/uid/DTS40009394
//  利用runloopObserver的一种实现方式： https://github.com/diwu/RunLoopWorkDistribution  

#import "ViewController.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "MyTableViewCell.h"
#import "ImageLinks.h"


static NSString *cellIdentifier = @"reusedCell";

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化UITableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, kSCReenWidth, kSCReenHeight - 20) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tableView];
    
    //注册重用标识
    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.data = [ImageLinks getImageUrls];
    
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"contactsCellId";
//    MyTableViewCell *cell = (MyTableViewCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
//    if (cell == nil) {
//        //cell = [[[NSBundle mainBundle]loadNibNamed:@"NameCell" owner:self options:nil]lastObject];
//        cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//        cell.imageView.image = [UIImage imageNamed:@"blank.png"];
//    }
    
    MyTableViewCell *cell = (MyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    if (self.data.count > 0) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"blank.png"];   //先给一张默认图片
        
        NSString *URLString = self.data[indexPath.row];             //图片地址
        
        ///初始化一个缓存池
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        NSLog(@"\n第%02ld行的图片缓存是否存在 : %@",(long)indexPath.row,[imageCache diskImageExistsWithKey:URLString] ? @"YES" : @"NO");
        
        ///从缓存中取图片
        [imageCache queryDiskCacheForKey:URLString done:^(UIImage *image, SDImageCacheType cacheType) {

            //图片存在就直接加载图片，否则就加载默认图片blank.png
            if (image) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = image;
                });
                
            }else{
                
                ///如果缓存里没找到对应的图片,当停止滑动时下载并缓存图片
                if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
                    ///异步下载图片
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        SDWebImageDownloader *downLoader = [SDWebImageDownloader sharedDownloader];
                        [downLoader downloadImageWithURL:[NSURL URLWithString:URLString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                            //此处可以设置下载进度（receivedSize/expectedSize）
                            
                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            
                            if (image && finished) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    cell.imageView.image = image;
                                });
                                ///以图片的下载地址作为key缓存图片
                                [[SDImageCache sharedImageCache]storeImage:image recalculateFromImage:NO imageData:data forKey:URLString toDisk:YES];
                            }
                        }];
                    });
                }
                ///按理说应该写在这里,但是写在这里的话不加载默认图片,还没找到原因
                //cell.imageView.image = [UIImage imageNamed:@"blank.png"];
                
            }
            
        }];
        
    }

    return cell;

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark - 加载当前屏幕Cell的图片

- (void)loadImagesForOnscreenRows
{
    if (self.data.count > 0) {
        
        ///获取到当期屏幕里的cell的indexPath
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            
            MyTableViewCell *cell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            NSString *imageString = self.data[indexPath.row];
            
            SDImageCache *imageCache = [[SDImageCache alloc]initWithNamespace:@"myCacheSpace"];
            [imageCache queryDiskCacheForKey:imageString done:^(UIImage *image, SDImageCacheType cacheType) {
                if (!image) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        SDWebImageDownloader *downLoader = [SDWebImageDownloader sharedDownloader];
                        [downLoader downloadImageWithURL:[NSURL URLWithString:imageString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                            //这里可以设置下载进度
                            
                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            if (image && finished) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    cell.imageView.image = image;
                                });
                                ///缓存图片
                                [[SDImageCache sharedImageCache]storeImage:image recalculateFromImage:NO imageData:data forKey:imageString toDisk:YES];
                            }
                        }];
                    });
                    
                }
            }];
            
        }
        //[self.tableView reloadData];
    }
}

#pragma mark - 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//    ///以下代码只是为了测试下封装的ZAF能不能用
//    [ZAFNetWorkService requestWithURL:@"http://api.douban.com/v2/movie/top250" params:nil httpMethod:@"GET" hasCertificate:NO sucess:^(id responseObject) {
//
//        //NSLog(@"\njson信息 = \n%@",responseObject);
//
//
//    } failure:^(NSError *error) {
//        NSLog(@"\n错误信息 = \n%@",error);
//    }];


@end
