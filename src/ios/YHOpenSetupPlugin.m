//
//  YHContact.m
//  cutePuppyPics
//
//  Created by lv zaiyi on 2017/5/23.
//
//

#import "YHOpenSetupPlugin.h"
#import <AVFoundation/AVFoundation.h>

@interface YHOpenSetupPlugin()

@property (nonatomic, copy) NSString *callbackId;

@end


@implementation YHOpenSetupPlugin

#pragma mark - 打开设置
- (void)openSetup:(CDVInvokedUrlCommand *)command {
    NSDictionary *dict  = [command argumentAtIndex:0 withDefault:nil];
    if (dict) {
        self.callbackId = [command.callbackId copy];
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
        }
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:_callbackId];
    }
}

- (void)requestCameraPermissions:(CDVInvokedUrlCommand *)command{
    NSDictionary *dict  = [command argumentAtIndex:0 withDefault:nil];
    if (dict) {
        self.callbackId = [command.callbackId copy];
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        static NSDictionary *resultDict = nil;//[NSDictionary dictionary];
        
        if (authStatus == AVAuthorizationStatusNotDetermined){
            //            NSLog(@"系统还未知是否访问，第一次开启相机时");
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    //第一次用户接受
                    resultDict = @{@"authStatus":@1};
                }else{
                    //用户拒绝
                    resultDict = @{@"authStatus":@0};
                }
                CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
                [self.commandDelegate sendPluginResult:result callbackId:_callbackId];
            }];
        } else if (authStatus == AVAuthorizationStatusDenied ||
                   authStatus == AVAuthorizationStatusRestricted) {
            resultDict = @{@"authStatus":@0};
        } else {//授权
            resultDict = @{@"authStatus":@1};
        }
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
        [self.commandDelegate sendPluginResult:result callbackId:_callbackId];
    }
}
@end

