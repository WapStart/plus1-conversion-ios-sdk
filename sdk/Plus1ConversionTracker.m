/**
 * Plus1ConversionTracker.m
 *
 * Copyright (c) 2013, Alexander Klestov <a.klestov@co.wapstart.ru>
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 * 
 *   * Redistributions of source code must retain the above copyright notice, 
 *     this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, 
 *     this list of conditions and the following disclaimer in the documentation
 *     and/or other materials provided with the distribution.
 *   * Neither the name of the "Wapstart" nor the names of its contributors 
 *     may be used to endorse or promote products derived from this software 
 *     without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "Plus1ConversionTracker.h"
#import "NSString+Base64.h"

#define ConversionUrl @"http://cnv.plus1.wapstart.ru/"
#define ConversionType 3

#define PreferencesName @"Plus1ConversionAlreadyTracked"

@interface Plus1ConversionTracker (PrivateMethods)

- (NSURL *) getConversionUrl;

@end

@implementation Plus1ConversionTracker

@synthesize applicationId = _applicationId;
@synthesize campaignId = _campaignId;
@synthesize callbackUrl = _callbackUrl;

- (id) initWithApplicationId:(NSInteger) applicationId andCallbackUrl:(NSString *) callbackUrl;
{
    if ((self = [super init]) != nil) {
        self.applicationId = applicationId;
        self.callbackUrl = callbackUrl;
    }
    
    return self;
}

- (id) initWithCampaignId:(NSInteger)campaignId andCallbackUrl:(NSString *) callbackUrl;
{
    if ((self = [super init]) != nil) {
        self.campaignId = campaignId;
        self.callbackUrl = callbackUrl;
    }

    return self;
}

- (BOOL) isFirstRun
{
    return ![[NSUserDefaults standardUserDefaults] boolForKey:PreferencesName];
}

- (void) run
{
    if ([self isFirstRun]) {
        NSURL *url = [self getConversionUrl];

        if (url != nil) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

            if (defaults) {
                [defaults setBool:YES forKey:PreferencesName];
                [defaults synchronize];
            }

            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (NSURL *) getConversionUrl
{
    if (!_callbackUrl)
        @throw([NSException exceptionWithName:@"Plus1ConversionTracker" reason:@"You must define callback url" userInfo:nil]);

    NSMutableString *url = [NSMutableString stringWithString:ConversionUrl];

    if (_campaignId)
        [url appendFormat:@"%@/%d/%d", @"campaign", ConversionType, _campaignId];
    else if (_applicationId)
        [url appendFormat:@"%@/%d/%d", @"app", ConversionType, _applicationId];
    else {
        NSLog(@"Plus1ConversionTracker: %@", @"You forget about set campain/application id");

        return nil;
    }
    
    [url appendFormat:@"/?callback=%@", [NSString stringWithBase64EncodedString:_callbackUrl]];
    
    return [NSURL URLWithString:url];
}
@end
