//
//  ViewController.m
//  dirtystd
//
//  Created by Alvin Ho on 5/27/14.
//  Copyright (c) 2014 std. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (readwrite, nonatomic) IBOutlet UIWebView *viewWeb;
@property (readwrite, nonatomic) UIScrollView* currentScrollView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view, typically from a nib.
    NSString *fullURL = @"http://dishlist.herokuapp.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    
    _viewWeb.scrollView.showsHorizontalScrollIndicator = NO;
    _viewWeb.scrollView.showsVerticalScrollIndicator = YES;
    
    _viewWeb.scrollView.delegate = self;
    [_viewWeb.scrollView setShowsHorizontalScrollIndicator:NO];
    
    
    // Implementing the scroll up to refresh
    [_viewWeb setDelegate:self];
    _viewWeb.tag = 999;
    for (UIView* subView in _viewWeb.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            _currentScrollView = (UIScrollView *)subView;
            _currentScrollView.delegate = (id) self;
        }
    }
    // End of implement scroll up to refresh
    // Set up Pull to Refresh code
    PullToRefreshView *pull = [[PullToRefreshView alloc] initWithScrollView:_currentScrollView];
    [pull setDelegate:self];
    pull.tag = 998;
    [_currentScrollView addSubview:pull];
    [self.view addSubview:_viewWeb];
    
    
    
    [_viewWeb loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    
}

- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.viewWeb stringByEvaluatingJavaScriptFromString:
     [NSString stringWithFormat:
      @"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
      (int)self.viewWeb.frame.size.width]];
    
    NSLog(@"orientation width: %d", (int)self.viewWeb.frame.size.width);
}

-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    [(UIWebView *)[self.view viewWithTag:999] reload];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv
{
    [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
}

@end
