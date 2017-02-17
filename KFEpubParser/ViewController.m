//
//  ViewController.m
//  KFEpubParser
//
//  Created by zhuxuhong on 2017/2/16.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

#import "ViewController.h"
#import "KFEpubKit.h"

@interface ViewController ()<KFEpubControllerDelegate, UIGestureRecognizerDelegate>

@property(nonatomic,strong)KFEpubController *epubController;
@property(nonatomic,strong)KFEpubContentModel *contentModel;

@property (nonatomic) NSUInteger spineIndex;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.spineIndex = 1;
    [self.epubController openAsynchronous:true];
    
    UISwipeGestureRecognizer *swipeRecognizer;
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRecognizer.delegate = self;
    [self.webview addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRecognizer.delegate = self;
    [self.webview addGestureRecognizer:swipeRecognizer];
}

- (void)didSwipeRight:(UIGestureRecognizer *)recognizer
{
    if (self.spineIndex > 1)
    {
        self.spineIndex--;
        [self updateContentForSpineIndex:self.spineIndex];
    }
}


- (void)didSwipeLeft:(UIGestureRecognizer *)recognizer
{
    if (self.spineIndex < self.contentModel.spine.count)
    {
        self.spineIndex++;
        [self updateContentForSpineIndex:self.spineIndex];
    }
}

-(KFEpubController *)epubController{
    if (!_epubController) {
        NSURL *epubURL = [[NSBundle mainBundle] URLForResource:@"demo.epub" withExtension:nil];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSURL *docURL = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *name = [[[epubURL lastPathComponent] componentsSeparatedByString:@"."] firstObject];
        NSURL *destFolder = [docURL URLByAppendingPathComponent: name];
        BOOL isDir = true;
        if (![fm fileExistsAtPath:destFolder.absoluteString isDirectory:&isDir]) {
            [fm createDirectoryAtURL:destFolder withIntermediateDirectories:false attributes:nil error:nil];
        }
        _epubController = [[KFEpubController alloc] initWithEpubURL:epubURL andDestinationFolder:destFolder];
        _epubController.delegate = self;
    }
    return _epubController;
}


- (void)updateContentForSpineIndex:(NSUInteger)currentSpineIndex
{
    NSString *contentFile = self.contentModel.manifest[self.contentModel.spine[currentSpineIndex]][@"href"];
    NSURL *contentURL = [self.epubController.epubContentBaseURL URLByAppendingPathComponent:contentFile];
    NSLog(@"content URL :%@", contentURL);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:contentURL];
    [self.webview loadRequest:request];
}


#pragma mark - KFEpubControllerDelegate
-(void)epubController:(KFEpubController *)controller willOpenEpub:(NSURL *)epubURL{
    NSLog(@"[%s]",__func__);
}

-(void)epubController:(KFEpubController *)controller didOpenEpub:(KFEpubContentModel *)contentModel{
    self.epubController = controller;
    self.contentModel = contentModel;
    [self updateContentForSpineIndex:self.spineIndex];
}

-(void)epubController:(KFEpubController *)controller didFailWithError:(NSError *)error{
    NSLog(@"[%s]",__func__);
}

@end
