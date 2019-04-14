//
//  EspressoActions.h
//  Espresso
//

//
// Every action type in Espresso uses this same basic interface; only the passed context argument changes.
// For the various action contexts, see the Espresso*Actions headers.
//
@interface NSObject (Action)

// Optional; called instead of -init if implemented.
// Dictionary contains the keys defined in the <setup> tag of action definitions. This is how you can create 
// generic item classes that behave differently depending on the XML settings.
- (id)initWithDictionary:(NSDictionary *)dictionary bundlePath:(NSString *)bundlePath;

// Required: return whether or not the action can be performed on the context.
// It's recommended to keep this as lightweight as possible, since you're not the only action in Espresso.
- (BOOL)canPerformActionWithContext:(id)context;

// Required: actually perform the action on the context.
// If an error occurs, pass an NSError via outError (warning: outError may be NULL!)
- (BOOL)performActionWithContext:(id)context error:(NSError **)outError;

@end
