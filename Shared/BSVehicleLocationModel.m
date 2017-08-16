//
//  BSVehicleLocationModel.m
//  Buster
//
//  Created by andyshep on 1/9/11.
//
//  Copyright (c) 2010-2011 Andrew Shepard
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "BSVehicleLocationModel.h"

#import "MBTAQueryStringBuilder.h"
#import "BSMBTARequestOperation.h"
#import "SMXMLDocument.h"

@implementation BSVehicleLocationModel

- (id)init {
	if ((self = [super init])) {
        //
    }
	
    return self;
}

- (void)requestLocationOfVehicle:(NSString *)vehicleId runningRoute:(NSString *)routeNumber atEpochTime:(NSString *)time {
    MBTAQueryStringBuilder *builder = [MBTAQueryStringBuilder sharedInstance];
	NSString *locationURL = [builder buildLocationsQueryForRoute:routeNumber withEpochTime:@"0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:locationURL]];
    
    BSMBTARequestOperation *operation = [BSMBTARequestOperation MBTARequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id object) {
        NSError *error = nil;
        SMXMLDocument *xml = [SMXMLDocument documentWithData:object error:&error];
        
        if (!error) {
            NSMutableDictionary *vehicleLocation = [NSMutableDictionary dictionaryWithCapacity:3];
            
            for (SMXMLElement *vehicleElement in [xml.parent childrenNamed:@"vehicle"]) {
                NSString *currentVehicleId = [vehicleElement attributeNamed:@"id"];
                
                if ([currentVehicleId compare:vehicleId] == 0) {
                    // found a matching vehicle id so 
                    // the vehicle we want is currently vehicleElement
                    NSString *latitude = [vehicleElement attributeNamed:@"lat"];
                    NSString *longitude = [vehicleElement attributeNamed:@"lon"];
                    NSString *secondsStringReport = [vehicleElement attributeNamed:@"secsSinceReport"];
                    
                    [vehicleLocation setObject:longitude forKey:@"longitude"];
                    [vehicleLocation setObject:latitude forKey:@"latitude"];
                    [vehicleLocation setObject:secondsStringReport forKey:@"lastSeen"];
                    
                    self.location = [NSDictionary dictionaryWithDictionary:vehicleLocation];
                }
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // TODO: handle failure
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

@end
