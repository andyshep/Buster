//
//  RouteListOperation.m
//  Buster
//
//  Created by andyshep on 10/30/10.
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

#import "RouteListOperation.h"

@implementation RouteListOperation

#pragma mark -
#pragma mark fetch data

- (id)consumeData {
    consumedData = [super consumeData];
    SMXMLDocument *xml = [SMXMLDocument documentWithData:consumedData error:NULL];
    NSMutableArray *routeList = [NSMutableArray arrayWithCapacity:20];
    
    for (SMXMLElement *routeElement in [xml.root childrenNamed:@"route"]) {
        
        MBTARoute *route = [[MBTARoute alloc] init];
        
        route.title = [routeElement attributeNamed:@"title"];
        route.tag = [routeElement attributeNamed:@"tag"];
        
        [routeList addObject:route];
        [route release];
    }
    
    return routeList;
}

@end
