//
//  ImageLinks.m
//  LazyLoadImageWithSD
//
//  Created by apple on 14/12/5.
//  Copyright (c) 2014年 Fate.D.Saber. All rights reserved.
//

#import "ImageLinks.h"

@implementation ImageLinks

+ (NSArray *)getImageUrls
{
    ///手头上没有图片链接,所以此处借用的是豆瓣电影公开API里的图片链接(*^__^*) 嘻嘻……
    
    NSArray *imageStrs = [NSArray arrayWithObjects:
                          @"http://img3.douban.com/img/celebrity/small/17525.jpg",
                          @"http://img3.douban.com/img/celebrity/small/34642.jpg",
                          @"http://img5.douban.com/img/celebrity/small/5837.jpg",@"http://img3.douban.com/img/celebrity/small/230.jpg",
                          @"http://img3.douban.com/view/movie_poster_cover/ipst/public/p480747492.jpg",
                          @"http://img3.douban.com/img/celebrity/small/8833.jpg",
                          @"http://img3.douban.com/img/celebrity/small/2274.jpg",
                          @"http://img3.douban.com/img/celebrity/small/104.jpg",
                          @"http://img5.douban.com/img/celebrity/small/47146.jpg",
                          @"http://img3.douban.com/view/movie_poster_cover/ipst/public/p511118051.jpg",
                          @"http://img3.douban.com/img/celebrity/small/28603.jpg",
                          @"http://img3.douban.com/img/celebrity/small/1389328920.51.jpg",
                          @"http://img3.douban.com/img/celebrity/small/1345.jpg",
                          @"http://img3.douban.com/img/celebrity/small/505.jpg",
                          @"http://img3.douban.com/view/movie_poster_cover/ipst/public/p510876400.jpg",
                          @"http://img3.douban.com/img/celebrity/small/5515.jpg",
                          @"http://img3.douban.com/img/celebrity/small/10381.jpg",
                          @"http://img5.douban.com/img/celebrity/small/39626.jpg",
                          @"http://img5.douban.com/img/celebrity/small/1379615419.48.jpg",
                          @"http://img3.douban.com/view/movie_poster_cover/ipst/public/p1910813120.jpg",
                          @"http://img3.douban.com/img/celebrity/small/26764.jpg",
                          @"http://img5.douban.com/img/celebrity/small/9548.jpg",
                          @"http://img3.douban.com/img/celebrity/small/45590.jpg",
                          @"http://img3.douban.com/img/celebrity/small/26764.jpg",
                          @"http://img3.douban.com/view/movie_poster_cover/ipst/public/p510861873.jpg",
                          @"http://img3.douban.com/img/celebrity/small/6281.jpg",
                          @"http://img5.douban.com/img/celebrity/small/1355152571.6.jpg",
                          @"http://img3.douban.com/img/celebrity/small/12333.jpg",
                          @"http://img3.douban.com/img/celebrity/small/195.jpg",
                          @"http://img5.douban.com/view/movie_poster_cover/ipst/public/p511146957.jpg",
                          @"http://img5.douban.com/img/celebrity/small/44906.jpg",
                          @"http://img5.douban.com/img/celebrity/small/1374649659.58.jpg",
                          @"http://img3.douban.com/img/celebrity/small/28941.jpg",
                          @"http://img3.douban.com/img/celebrity/small/34602.jpg",
                          @"http://img3.douban.com/view/movie_poster_cover/ipst/public/p492406163.jpg",
                          @"http://img3.douban.com/img/celebrity/small/19145.jpg",
                          @"http://img5.douban.com/img/celebrity/small/44986.jpg",
                          @"http://img3.douban.com/img/celebrity/small/18785.jpg",
                          @"http://img5.douban.com/img/celebrity/small/616.jpg",
                          @"http://img5.douban.com/view/movie_poster_cover/ipst/public/p1910830216.jpg",
                          nil];

    return imageStrs;
}

@end
