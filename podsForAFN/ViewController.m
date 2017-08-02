//
//  ViewController.m
//  podsForAFN
//
//  Created by SunGuoYan on 16/9/18.
//  Copyright © 2016年 SunGuoYan. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "AFNetWorking.h"
#import "AFHTTPSessionManager.h"


//#import "AFHTTPRequestOperationManager.h"

#define baseUrl @"http://120.52.12.203:8100"  //公网
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //我刚才添加的内容呢
    //这是我第三次添加的内容
    //这是我第4次添加的内容
    /*
    self.view.backgroundColor=[UIColor cyanColor];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    button.frame=CGRectMake(100, 400, 100, 100);
    button.backgroundColor=[UIColor greenColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    */
    
    
//    [self getAllStations];
//    [self login];
    [self sendChargingRequest];
    //注：
    //用新版本的AFN 如果token错误，会直接进error
    //但是原版的AFN token 错误的时候 会打印response 返回token无效
    
//    [self addFavoriteStation];
    
    
}
//添加收藏
-(void)addFavoriteStation{
    
    NSString *api=@"/api/account/like";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"objectId":@"2"};
    
    AFHTTPSessionManager *_operation = [AFHTTPSessionManager  manager];
    //申明请求的数据是json类型
    //    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
   
    [_operation PUT:urlStr parameters:para success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"task.response:%@",task.response);
        NSLog(@"task.response:%@",task.description);
        NSLog(@"response:%@",responseObject);
        NSLog(@"str:%@",[NSString stringWithFormat:@"%@",responseObject]);
        
        //请求成功执行此处的代码
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic:%@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error：%@",error);
    }];
    
    
}


//发起充电请求
-(void)sendChargingRequest{
    
    NSString *api=@"/api/charging/request";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"chargerNo":@(111)};
    
    AFHTTPSessionManager *_operation = [AFHTTPSessionManager  manager];
    //    //申明请求的数据是json类型
    //    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    // 设置返回格式
    _operation.responseSerializer= [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求头二
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    [_operation POST:urlStr parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"response:%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error：%@",error);
        
    }];
    
   
    
}
-(void)login{
    
    NSString *api=@"/oauth/token";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"grant_type":@"password",@"phone":@"13657229663",@"password":@"tomm"};
    
    AFHTTPSessionManager *_operation = [AFHTTPSessionManager  manager];
    
    // 设置超时时间
//    [_operation.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    _operation.requestSerializer.timeoutInterval = 3.f;
//    [_operation.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [_operation.requestSerializer setValue:@"Basic eW91ZXRvbmctYW5kcm9pZDpzZWNyZXQ=" forHTTPHeaderField:@"Authorization"];
    
    [_operation POST:urlStr parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"response:%@",responseObject);
        
        NSString *token=responseObject[@"access_token"];
        
        //        NSLog(@"token:%@",token);
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:token forKey:@"token"];
        [defaults synchronize];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error:%@",error);
        
    }];
    
    
}
//查找附近所有站点
-(void)getAllStations{
    NSString *api=@"/api/devices/search";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"longitude":@(0),@"latitude":@(0),@"search":@"湖北",@"idelonly":@(NO)};
    
    AFHTTPSessionManager *_operation = [AFHTTPSessionManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    [_operation GET:urlStr parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"response:%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error：%@",error);
    }];
    
//    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //        NSLog(@"operation:%@",operation);
//        
//        NSLog(@"response:%@",responseObject);
//        
//        for (NSDictionary *tempDic in responseObject) {
//            
//            NSLog(@"stationId:%@",tempDic[@"stationId"]);
//            
//            NSLog(@"name:%@",tempDic[@"name"]);
//            NSLog(@"operatorName:%@",tempDic[@"operatorName"]);
//            NSLog(@"district:%@",tempDic[@"district"]);
//            NSLog(@"payType:%@",tempDic[@"payType"]);
//            NSLog(@"stationType:%@",tempDic[@"stationType"]);
//            NSLog(@"chargeType:%@",tempDic[@"chargeType"]);
//            
//            NSLog(@"atype:%@",tempDic[@"atype"]);
//            NSLog(@"ctype:%@",tempDic[@"ctype"]);
//            NSLog(@"stype:%@",tempDic[@"stype"]);
//            
//            NSLog(@"sstatus:%@",tempDic[@"sstatus"]);
//            NSLog(@"province:%@",tempDic[@"province"]);
//            
//            NSLog(@"\n");
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"error：%@",error);
//        
//    }];
    
    
    /*
     {
     address = 23523452345;
     area = OTHER;
     atype = "\U5176\U5b83";
     chargeType = ALL;
     city = 1111;
     ctype = "\U5feb\U5145&\U6162\U5145";
     distance = "0.00";
     district = "\U65b0\U6d32\U533a";
     geoPoint =         {
     lat = 0;
     lon = 0;
     };
     id = "58123648-dd5d-4157-99ed-34d11de519e5";
     idleCount = 0;
     name = "\U5145\U7535\U7ad91";
     operatorName = "\U8fd0\U8425\U5546\U540d\U79f01";
     payType = "\U5176\U4ed6\U652f\U4ed8";
     paymentMethod = OTHER;
     price = 123300;
     province = "\U5317\U4eac";
     sstatus = "\U6709\U7a7a\U95f2";
     stationId = 5;
     stationType = PUBLIC;
     status = IDLE;
     stype = "\U516c\U5171\U7ad9";
     totalCount = 0;
     }
     */
}
//[UIApplication sharedApplication].keyWindow 这里放在viewDidLoad中就不能实现！！！
-(void)buttonClick
{
    UIView *c=[[UIView alloc]initWithFrame:self.view.bounds];
    c.backgroundColor=[UIColor lightGrayColor];
    c.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:c];
    [MBProgressHUD showHUDAddedTo:c animated:YES];
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
