//
//  LBWebViewController.m
//  
//
//  Created by 林彬 on 16/4/7.
//  Copyright © 2016年 linbin. All rights reserved.
//

#import "LBWebViewController.h"
#import <WebKit/WebKit.h>
#import "UIImage+LBImage.h"

@interface LBWebViewController ()<WKUIDelegate , WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressV;

@property(nonatomic , weak)WKWebView *webV;
@end

@implementation LBWebViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpNavBarLeftButton];
    [self setUpNavBarRightButton];
    
    WKWebView *webV = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _webV = webV;
    // 设置代理
    webV.UIDelegate = self;
    webV.navigationDelegate = self;
    
    // 添加到最底层,避免覆盖进度条
    [self.view insertSubview:webV atIndex:0];
    
    // 根据外界传入的URL,新建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    
    // 设置超时时间
    request.timeoutInterval = 10;
    
    // 加载请求
    [webV loadRequest:request];
    
    // KVO
    // KVO: 让self对象监听webView的estimatedProgress  , 监听新值的改变
    [webV addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

// 支持JS的事件
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:webView.title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    } ]];
    [self presentViewController:ac animated:YES completion:nil];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{

}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"---%@",error);
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:webView.title message:@"请求超时" preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    } ]];
    
    [self presentViewController:ac animated:YES completion:nil];
}

// 只要监听的属性有新值就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    _progressV.progress = _webV.estimatedProgress;
    
    _progressV.hidden = _progressV.progress >= 1;
}

// KVO一定要移除观察者
- (void)dealloc
{
    [self.webV removeObserver:self forKeyPath:@"estimatedProgress"];
}


-(void)setUpNavBarLeftButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageOriRenderNamed:@"navigationButtonReturnClick"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageOriRenderNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barBtn;
}

- (void)back
{
    if (self.webV.canGoBack) {
        [self.webV goBack];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUpNavBarRightButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageOriRenderNamed:@"composer_emoticon_delete_highlighted"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageOriRenderNamed:@"composer_emoticon_delete"] forState:UIControlStateHighlighted];
//    [btn setTitle:@"退出" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(out) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    // 设置按钮偏移量.只有在设置好按钮的位置,也就是自适应后才能起作用
//    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtn;
}

- (void)out
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
