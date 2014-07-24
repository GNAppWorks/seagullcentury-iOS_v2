//
//  SGC_Tests.m
//  SGC_Tests
//
//  Created by Brandon Altvater on 7/23/14.
//  Copyright (c) 2014 Seagull Century. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SeaGullRouteManager.h"

@interface SGC_Tests : XCTestCase

@end

@implementation SGC_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRouteManagerCreation{
    
    SeaGullRouteManager *route = [SeaGullRouteManager sharedInstance];
    XCTAssertNotNil(route, @"Should NOT be nil");

}

@end
