//
//  VehicleLocationModel.m
//  Buster
//
//  Created by andyshep on 1/9/11.
//
//  Copyright (c) 2010 Andrew Shepard
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

#import "VehicleLocationModel.h"


@implementation VehicleLocationModel

@synthesize location, error;

#pragma mark -
#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		
		// init a nothing location for the model
		self.location = nil, self.error = nil;
		
		// create our operation queue
		opQueue_ = [[NSOperationQueue alloc] init];
    }
	
    return self;
}

- (void) dealloc {
    [opQueue_ release];
    [location release];
    [error release];
    [super dealloc];
}

#pragma mark -
#pragma mark Location Request

- (void) requestLocationOfVehicle:(NSString *)vehicleId runningRoute:(NSString *)routeNumber atEpochTime:(NSString *)time {
        
#if USE_STUB_SERVICE
    VehicleLocationOperation *locationOp = [[VehicleLocationOperation alloc] initWithURLString:@"http://localhost:8081/vehicles.xml" delegate:self];
#else
    MBTAQueryStringBuilder *_builder = [MBTAQueryStringBuilder sharedMBTAQueryStringBuilder];
    
	NSString *locationURL = [_builder buildLocationsQueryForRoute:routeNumber
                                                    withEpochTime:@"0"];
    
    VehicleLocationOperation *locationOp = [[VehicleLocationOperation alloc] initWithURLString:locationURL delegate:self];
#endif
    
    locationOp.vehicleId = vehicleId;
    locationOp.routeNumber = routeNumber;
    locationOp.epochTime = time;
    
    [opQueue_ addOperation:locationOp];
    [locationOp release];
}

#pragma mark -
#pragma mark VehicleLocationOperationDelegate methods

- (void)didConsumeData:(id)consumedData {
	self.location = consumedData;
}

- (void)didFailWithError:(NSError *)aError {
    self.error = aError;
}

@end
