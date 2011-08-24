//
//  StopListModel.h
//  Buster
//
//  Created by andyshep on 12/30/10.
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

#import "StopListOperation.h"
#import "MBTARouteDirection.h"
#import "MBTAStop.h"


@interface StopListModel : NSObject <BSNetworkOperationDelegate> {
	// these are used by table views
	NSArray *stops;
	NSArray *tags;
	NSArray *titles;
	NSString *title;
	
	NSMutableDictionary *stopListCache;
	
	NSDictionary *directions;
    NSError *error;
    
    StopListOperation *stopListOp_;
    NSOperationQueue *opQueue_;
}

@property (copy) NSArray *stops, *tags, *titles;
@property (copy) NSDictionary *directions;
@property (copy) NSError *error;
@property (nonatomic, retain) NSString *title;

- (void)requestStopList:(NSString *)stop;
- (void)unloadStopList;
- (void)loadStopsForTagIndex:(NSUInteger)index;

- (NSUInteger)countOfStops;
- (id)objectInStopsAtIndex:(NSUInteger)index;
- (void)getStops:(id *)objects range:(NSRange)range;

@end
