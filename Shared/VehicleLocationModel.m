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

@synthesize location;

SYNTHESIZE_SINGLETON_FOR_CLASS(VehicleLocationModel);

#pragma mark -
#pragma mark Lifecycle

- (id) init {
    self = [super init];
    
	if (self != nil) {
		
		// init a nothing location for the model
		self.location = nil;
		
		// create our operation queue
		opQueue = [[NSOperationQueue alloc] init];
    }
	
    return self;
}

- (void) dealloc {
    [opQueue release];
    [super dealloc];
}

#pragma mark -
#pragma mark Location Request

- (void) requestLocationOfVehicle:(NSString *)vehicleId runningRoute:(NSString *)routeNumber atEpochTime:(NSString *)time {
	VehicleLocationOperation *locationOp = [[VehicleLocationOperation alloc] initWithDelegate:self 
																				 andVehicleId:vehicleId
																			   andRouteNumber:routeNumber 
																				  atEpochTime:time];
	[opQueue addOperation:locationOp];
	[locationOp release];
}

#pragma mark -
#pragma mark VehicleLocationOperationDelegate methods

- (void)updateLocation:(NSDictionary *)data {
	NSLog(@"updatePredictions: %@", data);
	
	self.location = data;
}

@end
