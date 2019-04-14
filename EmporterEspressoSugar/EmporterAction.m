//
//  EmporterAction.m
//  EmporterEspressoSugar
//
//  Created by Mikey on 03/04/2019.
//  Copyright © 2019 Young Dynasty. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "EspressoFileActions.h"
#import "Emporter.h"


@interface EmporterAction : NSObject
@property (readonly) NSString *stringValue;
- (NSURL *)projectURLForContext:(id)context;
@end


@interface NSObject (PrivateEspressoDirectoryContext)
@property(readonly) NSURL *contextDirectoryURL;
@end


@implementation EmporterAction

- (id)initWithDictionary:(NSDictionary *)dictionary bundlePath:(NSString *)bundlePath {
    self = [super init];
    if (self == nil)
        return nil;
    
    id stringValue = (dictionary ?: @{})[@"action"];
    _stringValue = (stringValue != nil && [stringValue isKindOfClass:[NSString class]]) ? stringValue : @"";
    
    return self;
}

#pragma mark - Actions

static NSString *const EmporterConfigureAction = @"configure";

- (BOOL)canPerformActionWithContext:(id)context {
    if ([_stringValue isEqualToString:EmporterConfigureAction]) {
        return [self projectURLForContext:context] != nil;
    } else {
        return NO;
    }
}

- (BOOL)performActionWithContext:(id)context error:(NSError **)outError {
    if ([_stringValue isEqualToString:EmporterConfigureAction]) {
        [self configureURLWithContext:context];
        return YES;
    } else {
        return NO;
    }
}

- (void)configureURLWithContext:(id)context {
    // Check Emporter is installed
    Emporter *emporter = [[Emporter alloc] init];
    if (emporter == nil) {
        return [Emporter isInstalled] ? NSBeep() : [self showDownloadAlert];
    }
    
    // Make sure we're in a project window
    NSURL *projectURL = [self projectURLForContext:context];
    if (projectURL == nil) {
        return NSBeep();
    }
    
    NSError *error = nil;
    [[NSWorkspace sharedWorkspace] openURLs:@[projectURL] withApplicationAtURL:emporter.bundleURL options:0 configuration:@{} error:&error];

    if (error != nil) {
        NSLog(@"Could not configure URL: %@", error);
        NSBeep();
    }
}

#pragma mark -

- (NSURL *)projectURLForContext:(id)context {
    if (![context respondsToSelector:@selector(contextDirectoryURL)]) {
        return nil;
    }
    return [context contextDirectoryURL];
}

#pragma mark -

- (void)showDownloadAlert {
    NSAlert *alert = [[NSAlert alloc] init];
    
    alert.alertStyle = NSAlertStyleInformational;
    alert.messageText = @"Emporter must be installed before continuing.";
    alert.informativeText = @"Emporter creates secure, public URLs to your Mac. It's free.";
    
    [alert addButtonWithTitle:@"View in Mac App Store"];
    [alert addButtonWithTitle:@"Cancel"];
    
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        [[NSWorkspace sharedWorkspace] openURL:[Emporter appStoreURL]];
    }
}

@end
