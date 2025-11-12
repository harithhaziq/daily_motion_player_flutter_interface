//
//  AdvertisingBridge.h
//  DailymotionPlayerSDK
//
//  Created by Florin Dobjenschi on 22.11.2022.
//  Copyright © 2022 Dailymotion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
//@protocol AdvertisingBridgeDelegate;

@protocol AdvertisingBridgeDelegate <NSObject>
- (void)imaMute:(BOOL)mute;
- (void)toggleFullscreen;
- (UIViewController * _Nullable)viewControllerForAds;
- (void)imaEventWithEvent:(NSString * _Nonnull)event;
- (void)imaLocalEventWithEvent:(NSString * _Nonnull)event;
 
@end

@interface AdvertisingBridge : NSObject
+(BOOL)advertisingModuleAvailable;
- (void)setupBridgeWith:(WKWebView *)webView imaContainer:(UIView*)imaContainer andDelegate:(id<AdvertisingBridgeDelegate>)delegate enableAdsControls:(BOOL)enableAdsControls logLevel:(NSNumber *)logLevel;

- (BOOL)omidActivate;
- (void)omidSendSignal:(NSString *)signal;
+ (NSString * _Nullable )omidPartnerName;
+ (NSString * _Nullable )omidPartnerVersion;
+ (NSString * _Nullable )omidDKVersion;

+ (NSString * _Nullable )imaSDKVersion;
- (void)imaAdRequested:(NSDictionary<NSString *, id> * _Nonnull) adRequest muted:(BOOL) muted;
- (void)imaStop;
- (BOOL)isAdCurrentlyLoading;
- (void)imaFullScreenViewController:(UIViewController * _Nullable) viewController;
- (void)imaPlayPause;
- (void)imaToggleMute;
- (void)imaToggleFullscreen;
- (void)imaPause;
- (void)imaPlay;

@end

NS_ASSUME_NONNULL_END
