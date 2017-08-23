//
//  BSPrediction.h
//  Buster
//
//  Created by Andrew Shepard on 8/22/17.
//

@import Foundation;

@interface BSPrediction : NSObject <NSCoding>

@property (nonnull, nonatomic, strong) NSString *routeId;
@property (nonnull, nonatomic, strong) NSString *stopId;
@property (nonnull, nonatomic, strong) NSString *direction;

@property (nonnull, nonatomic, strong) NSString *name;

+ (NSArray<BSPrediction *> * _Nonnull)predictionsFromData:(NSData  * _Nonnull)data;

@end
