//
//  EspressoFileActions.h
//  Espresso
//

// All actions share the same generic interface; the specific context changes
#import "EspressoActions.h"


//
// File actions (defined under FileActions in sugars) get a context conforming to this interface.
//
@interface NSObject (FileActionContext)

// Files the action applies to. This is typically the selection from a list of files.
// Note that URLs may be from various remote or local sources, possibly even mixed.
@property(readonly) NSArray *URLs;

// Returns a window suitable for displaying a sheet. May be nil.
@property(readonly) NSWindow *windowForSheet;

@end
