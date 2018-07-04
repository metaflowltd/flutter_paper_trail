#import "FlutterPaperTrailPlugin.h"
#import <flutter_paper_trail/flutter_paper_trail-Swift.h>

@implementation FlutterPaperTrailPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPaperTrailPlugin registerWithRegistrar:registrar];
}
@end
