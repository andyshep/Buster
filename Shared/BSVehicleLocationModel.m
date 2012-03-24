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


@implementation BSVehicleLocationModel

@synthesize location = _location, error = _error;

#pragma mark -
#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		self.location = nil;
        self.error = nil;
    }
	
    return self;
}

- (void) dealloc {
    [_location release];
    [_error release];
    [super dealloc];
}

#pragma mark -
#pragma mark Location Request

- (void)requestLocationOfVehicle:(NSString *)vehicleId runningRoute:(NSString *)routeNumber atEpochTime:(NSString *)time {
        
    MBTAQueryStringBuilder *builder = [MBTAQueryStringBuilder sharedInstance];
	NSString *locationURL = [builder buildLocationsQueryForRoute:routeNumber
                                                    withEpochTime:@"0"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:locationURL]];
    
    BSMBTARequestOperation *operation = [BSMBTARequestOperation MBTARequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id object) {
        NSError *error_ = nil;
        SMXMLDocument *xml = [SMXMLDocument documentWithData:object error:&error_];
        
        NSLog(@"xml: %@", xml);
        
        if (!error_) {
            
            NSMutableDictionary *vehicleLocation = [NSMutableDictionary dictionaryWithCapacity:3];
            
            for (SMXMLElement *vehicleElement in [xml.root childrenNamed:@"vehicle"]) {
                NSString *currentVehicleId = [vehicleElement attributeNamed:@"id"];
                
                if ([currentVehicleId compare:vehicleId] == 0) {
                    // found a matching vehicle id so 
                    // the vehicle we want is currently vehicleElement
                    
                    // NSString *_vehicleId = [vehicleElement attributeNamed:@"id"];
                    NSString *_latitude = [vehicleElement attributeNamed:@"lat"];
                    NSString *_longitude = [vehicleElement attributeNamed:@"lon"];
                    NSString *_secondsStringReport = [vehicleElement attributeNamed:@"secsSinceReport"];
                    
                    //NSLog(@"found vehicle %@ at %@, %@", _vehicleId, _latitude, _longitude);
                    NSLog(@"%@", [vehicleElement attributeNamed:@"secsSinceReport"]);
                    
                    [vehicleLocation setObject:_longitude forKey:@"longitude"];
                    [vehicleLocation setObject:_latitude forKey:@"latitude"];
                    [vehicleLocation setObject:_secondsStringReport forKey:@"lastSeen"];
                    
                    NSLog(@"vehicleLocation: %@", vehicleLocation);
                    
                    self.location = [NSDictionary dictionaryWithDictionary:vehicleLocation];
                }
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // TODO: handle failure
    }];
    
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    [queue addOperation:operation];
}

@end
