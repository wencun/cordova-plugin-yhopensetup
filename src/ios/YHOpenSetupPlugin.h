//
//  YHContact.h
//  cutePuppyPics
//
//  Created by lv zaiyi on 2017/5/23.
//
//

#import <Cordova/CDV.h>

@interface YHOpenSetupPlugin : CDVPlugin

- (void)openSetup:(CDVInvokedUrlCommand *)command;

- (void)requestCameraPermissions:(CDVInvokedUrlCommand *)command;
@end

