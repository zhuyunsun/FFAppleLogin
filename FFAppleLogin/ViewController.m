//
//  ViewController.m
//  FFAppleLogin
//
//  Created by 朱运 on 2021/2/25.
//

#import "ViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
@interface ViewController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>{
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     苹果登录,iOS13系统之后才有的功能;
     苹果公司要求:有第三方登录的APP,必须接入Sign in with Apple功能
     下面来讲解如何接入Sing in with Apple功能
     
     配置信息:
     1,开发证书和上架证书制作的时候,需要勾选支持苹果登录的选项;
     2,Xcode在Singing&Capabilitles添加Sign in with Apple功能;
     3,导入AuthenticationServices.framework
     代码实现:
     1,编写代码实现苹果登录功能
     测试:
     真机和模拟器都可以测试,登录有效的Apple ID即可;
     */
    
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"苹果登录(Sing in with Apple)";
    
    /*
     苹果提供的样式按钮
     需要给到足够的长度,不然文字不会展示完整;
     
     1,有不同的文字样式:ASAuthorizationAppleIDButtonType
     2,有不同的外观和底色样式:ASAuthorizationAppleIDButtonStyle
     */
     ASAuthorizationAppleIDButton *appleButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhite];
     appleButton.frame = CGRectMake(100,200, 200, 39);
    [appleButton addTarget:self action:@selector(appleBtnAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:appleButton];
    
    
    
    
    
    /*
     自定义按钮,需要符合苹果提供按钮要求
     规范地址:https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/buttons/
     
     需要规范的按钮内容:
     文字,文字颜色,文字大小,底色,外框颜色,图片logo
     */
    
    UIButton *coustomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    coustomButton.frame = CGRectMake(100, 500, 44, 44);
    [coustomButton setImage:[UIImage imageNamed:@"apple_login"] forState:UIControlStateNormal];
    [coustomButton addTarget:self action:@selector(appleBtnAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:coustomButton];
}
-(void)appleBtnAction{
    if (@available(iOS 13, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }
}
#pragma mark 协议回调
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    return [UIApplication sharedApplication].windows.lastObject;
}
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  NS_SWIFT_NAME(authorizationController(controller:didCompleteWithError:)) API_AVAILABLE(ios(13.0)){
    //失败
    NSLog(@"error %lu",error.code);
    NSString *msg = @"";
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            //取消了授权
            msg = @"取消授权";
            break;
        case ASAuthorizationErrorInvalidResponse:
            //请求授权无效
            msg = @"授权无效";
            break;
        case ASAuthorizationErrorNotHandled:
            //未能处理响应请求
            msg = @"未能响应授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            //请求失败,原因未知
            msg = @"授权失败,原因未知";
            break;
        case ASAuthorizationErrorFailed:
            //请求授权失败
            msg = @"请求授权失败";
            break;
        default:
            break;
    }
    msg = [msg stringByAppendingFormat:@"%lu",error.code];
    NSLog(@"失败信息:%@",msg);
}
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization NS_SWIFT_NAME(authorizationController(controller:didCompleteWithAuthorization:)) API_AVAILABLE(ios(13.0)) API_AVAILABLE(ios(13.0)){
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user = appleIDCredential.user;NSLog(@"user = %@",user);
        // 使用过授权的，可能获取不到以下三个参数
        NSString *familyName = appleIDCredential.fullName.familyName;
        NSString *givenName = appleIDCredential.fullName.givenName;
        NSString *email = appleIDCredential.email;
        
        NSLog(@"familyName = %@,givenName = %@,email = %@",familyName,givenName,email);
        
        NSData *identityToken = appleIDCredential.identityToken;
        NSData *authorizationCode = appleIDCredential.authorizationCode;
        
        // 服务器验证需要使用的参数
        NSString *identityTokenStr = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
        NSString *authorizationCodeStr = [[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding];
        NSLog(@"msg\n%@\n\n%@", identityTokenStr, authorizationCodeStr);
    }
//    else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
//        //获取icloud账号密码信息
//        // 用户登录使用现有的密码凭证
//        ASPasswordCredential *passwordCredential = authorization.credential;
//        // 密码凭证对象的用户标识 用户的唯一标识
//        NSString *user = passwordCredential.user;
//        // 密码凭证对象的密码
//        NSString *password = passwordCredential.password;
//
//    }
    else{
        //失败
        NSLog(@"error1");
    }
}

@end
