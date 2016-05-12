//
//  EUExDiDi.m
//  AppCanPlugin
//
//  Created by cc on 16/5/5.
//  Copyright © 2016年 zywx. All rights reserved.
//

#import "EUExDiDiTravel.h"
#import "JSON.h"
#import "EUtility.h"
#import "WidgetOneDelegate.h"
#import "DidiTravelViewController.h"
@implementation EUExDiDiTravel

-(id)initWithBrwView:(EBrowserView *) eInBrwView{
    if (self = [super initWithBrwView:eInBrwView])
    {
        
    }
    return self;
}
/**
 *  注册App；
 */
-(void)registerApp:(NSMutableArray*)array
{
    NSString * appString = [array objectAtIndex:0];
    NSDictionary * appDict = [appString JSONValue];
    [DIOpenSDK registerApp:[appDict objectForKey:@"appid"]secret:[appDict objectForKey:@"secrect"]];
    
}

/**
 *  showDDPage 拉起滴滴叫车主页面
 */
-(void)showDDPage:(NSMutableArray*)array
{
    NSString *  pageStr = [array objectAtIndex:0];
    NSDictionary * pageDict = [pageStr JSONValue];
    DIOpenSDKRegisterOptions * registerOptions = [[DIOpenSDKRegisterOptions alloc]init];
    registerOptions.fromlat = [pageDict objectForKey:@"fromlat"];
    registerOptions.fromlng = [pageDict objectForKey:@"fromlng"];
    registerOptions.fromaddr = [pageDict objectForKey:@"fromaddr"];
    registerOptions.fromname = [pageDict objectForKey:@"fromname"];
    registerOptions.tolng = [pageDict objectForKey:@"tolng"];
    registerOptions.tolat = [pageDict objectForKey:@"tolat"];
    registerOptions.toaddr = [pageDict objectForKey:@"toaddr"];
    registerOptions.toname = [pageDict objectForKey:@"toname"];
    registerOptions.biz = [pageDict objectForKey:@"biz"];
    registerOptions.phone = [pageDict objectForKey:@"phone"];
    registerOptions.maptype = [pageDict objectForKey:@"maptype"];
    
    UIViewController * vc = (UIViewController *)theApp.drawerController;
    
    [DIOpenSDK showDDPage:vc
                 animated:YES
                   params:registerOptions
                 delegate:self];
}
/**
 *    callDDApi 调用滴滴开放API
 */
-(void)callDDApi:(NSMutableArray*)array{
    
    NSString *  apiStr = [array objectAtIndex:0];
    NSDictionary * apiDict = [apiStr JSONValue];
    
    NSArray * keys = [apiDict allKeys];
    if ([keys containsObject:@"getEstimateTime"])//预估计时间
    {
        NSDictionary * timeDict = [apiDict objectForKey:@"getEstimateTime"];
        [DIOpenSDK asyncCallOpenAPI:@"getEstimateTime" params:timeDict resultBlock:^(NSError *error, DIBaseModel *model) {
            NSLog(@"返回数据：+++++%@",model.data);
            NSString * timeStr = [model.data JSONFragment];
            [self jsSuccessWithName:@"uexDiDiTravel.cbGetEstimateTime" opId:0 dataType:0 strData:timeStr];
        }];
        
    }else if ([keys containsObject:@"getEstimatePrice"])// 预估车费
    {
        NSDictionary * priceDict = [apiDict objectForKey:@"getEstimatePrice"];
        [DIOpenSDK asyncCallOpenAPI:@"getEstimatePrice" params:priceDict resultBlock:^(NSError *error, DIBaseModel *model) {
            NSLog(@"返回数据：+++++%@",model.data);
            NSString * priceStr = [model.data JSONFragment];
            [self jsSuccessWithName:@"uexDiDiTravel.cbGetEstimatePrice" opId:0 dataType:0 strData:priceStr];
        }];
        
    }
    else if ([keys containsObject:@"getCurrentOrderStatus"]) // 获取当前进行中的订单状态
    {
        [DIOpenSDK asyncCallOpenAPI:@"getCurrentOrderStatus" params:nil resultBlock:^(NSError *error, DIBaseModel *model) {
            NSLog(@"返回数据：+++++%@",model.data);
            
            NSString * StatusStr = [model.data JSONFragment];
            [self jsSuccessWithName:@"uexDiDiTravel.cbGetCurrentOrderStatus" opId:0 dataType:0 strData:StatusStr];
        }];
    }
    else if ([keys containsObject:@"getCurrentDriverInfo"])// 获取当前进行中订单的司机信息
    {
        [DIOpenSDK asyncCallOpenAPI:@"getCurrentDriverInfo" params:nil resultBlock:^(NSError *error, DIBaseModel *model) {
            NSLog(@"返回数据：+++++%@",model.data);
            
            NSString * InfoStr = [model.data JSONFragment];
            [self jsSuccessWithName:@"uexDiDiTravel.cbGetCurrentDriverInfo" opId:0 dataType:0 strData:InfoStr];
            
        }];
        
    }
    else if ([keys containsObject:@"getOrderList"])// 获取订单列表
    {
        NSDictionary * orderDict = [apiDict objectForKey:@"getOrderList"];
        [DIOpenSDK asyncCallOpenAPI:@"getOrderList" params:orderDict resultBlock:^(NSError *error, DIBaseModel *model) {
            NSLog(@"返回数据：+++++%@",model.data);
            
            NSString * listStr = [model.data JSONFragment];
            [self jsSuccessWithName:@"uexDiDiTravel.cbGetOrderList" opId:0 dataType:0 strData:listStr];
        }];
        
    }else{
        
        
        NSLog(@"走else了");
    }
}

/**
 *   getTicket 获取API Ticket
 */
-(void)getTicket:(NSMutableArray*)array
{
    NSString *  ticketStr = [array objectAtIndex:0];
    NSDictionary * ticketDict = [ticketStr JSONValue];
    [DIOpenSDK asyncGetTicket:[ticketDict objectForKey:@"type"] resultBlock:^(NSError *error, DIBaseModel *model) {
        NSLog(@"getTicket返回数据：++++%@",model.data);
        
        NSString * getTicketString = [model.data JSONFragment];
        [self jsSuccessWithName:@"uexDiDiTravel.cbGetTicket" opId:0 dataType:0 strData:getTicketString];
    }];
}

/**
 *  检查打车主页是否登陆
 *
 *  @return 已登录返回YES,未登录返回NO
 */
-(void)isLogin:(NSMutableArray*)array
{
    BOOL isLogin = [[DIOpenSDK alloc] checkLogin];
    if (isLogin==YES)
    {
        [self jsSuccessWithName:@"uexDiDiTravel.cbIsLogin" opId:0 dataType:0 strData:@"0"];

    }else{
    
        [self jsSuccessWithName:@"uexDiDiTravel.cbIsLogin" opId:0 dataType:0 strData:@"1"];
    }
    
}

/**
 *   login 登录页面
 */
-(void)openPage:(NSMutableArray*)array{
    
    NSString *  showPageStr = [array objectAtIndex:0];
    NSDictionary * showPageDict = [showPageStr JSONValue];
    NSArray * keys = [showPageDict allKeys];
    if ([keys containsObject:@"login"])// 登录界面
    {
        [DIOpenSDK openPage:@"login" params:showPageDict navTheme:nil resultBlock:^(NSError *error, UIViewController * viewController) {
            UIViewController * vcs = (UIViewController *)theApp.drawerController;
            [vcs presentViewController:viewController animated:YES completion:^{
                NSLog(@"uexDiDiTravel");
            }];
        }];
    }
    else if ([keys containsObject:@"orderDetail"])// 行程详情界面
    {
        NSDictionary * orderOrderDetailDict = [showPageDict objectForKey:@"orderDetail"];
        [DIOpenSDK openPage:@"orderDetail" params:orderOrderDetailDict navTheme:nil resultBlock:^(NSError *error, UIViewController *viewController) {
            NSLog(@"%@",viewController);
            UIViewController * vcss = (UIViewController *)theApp.drawerController;
            [vcss presentViewController:viewController animated:YES completion:^{
                NSLog(@"uexDiDiTravel");
            }];
            
        }];
    }
    else if ([keys containsObject:@"invoice"])//发票开局界面
    {
        NSDictionary * invoiceDict = [showPageDict objectForKey:@"invoice"];
        [DIOpenSDK openPage:@"invoice" params:invoiceDict navTheme:nil resultBlock:^(NSError *error, UIViewController *viewController) {
            NSLog(@"%@",viewController);
            UIViewController * vcsss = (UIViewController *)theApp.drawerController;
            [vcsss presentViewController:viewController animated:YES completion:^{
                NSLog(@"uexDiDiTravel");
            }];        }];
    }else if ([keys containsObject:@"orderList"])// 订单列表界面
    {
        [DIOpenSDK openPage:@"orderList" params:nil navTheme:nil resultBlock:^(NSError *error, UIViewController *viewController) {
            NSLog(@"%@",viewController);
            UIViewController * vcssss = (UIViewController *)theApp.drawerController;
            [vcssss presentViewController:viewController animated:YES completion:^{
                NSLog(@"uexDiDiTravel");
            }];
        }];
    }
    
}

/**
 *
 *  callPhone 呼叫电话
 */

-(void)callPhone:(NSMutableArray*)array
{
    NSString * phoneString = [array objectAtIndex:0];
    NSDictionary * phoneDcit = [phoneString JSONValue];
    NSError * error;
    [DIOpenSDK callPhone:[phoneDcit objectForKey:@"phone"] prompt:YES error:&error];
}









@end
