# LazyLoadImageWithSDWebImage

参考苹果官方懒加载的[Sample Code](https://developer.apple.com/library/ios/samplecode/LazyTableImages/Introduction/Intro.html#//apple_ref/doc/uid/DTS40009394)，利用`SDWebImage` lib 中`SDWebImageDownloader`和`SDImageCach`两个类实现图片的缓存和下载

----

 参考苹果官方懒加载的[Sample Code](https://developer.apple.com/library/ios/samplecode/LazyTableImages/Introduction/Intro.html#//apple_ref/doc/uid/DTS40009394)，利用`SDWebImage` lib 中`SDWebImageDownloader`和`SDImageCach`两个类实现图片的缓存和下载
>* 此处懒加载是指当滑动视图（比如`UITableView`）滚动太快时图片暂不加载，只有滑动停止后才加载，而且只加载当前可视界面中的图片
 参考苹果官方懒加载的[Sample Code](https://developer.apple.com/library/ios/samplecode/LazyTableImages/Introduction/Intro.html#//apple_ref/doc/uid/DTS40009394)，利用`SDWebImage` lib 中`SDWebImageDownloader`和`SDImageCach`两个类实现图片的缓存和下载

----
#### 主要代码如下:
```objc

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
                                [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:NO imageData:data forKey:imageString toDisk:YES];
                            }
                        }];
                    });
                }
            }];
            
        }
        //[self.tableView reloadData];
    }
}

```

