//
//  NSString+ABXURLEncoding.h
//
//  Created by Stuart Hall on 21/05/2014.
//  Copyright (c) 2014 Appbot. All rights reserved.
//

@import Foundation;

@interface NSString (ABXURLEncoding)

- (NSString *)urlEncodedString;
- (NSString *)urlDecodedString;

@end
