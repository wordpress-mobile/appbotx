//
//  NSDictionary+ABXNSNullAsNull.h
//
//  Created by Stuart Hall on 21/05/2014.
//  Copyright (c) 2014 Appbot. All rights reserved.
//

@import Foundation;

@interface NSDictionary (ABXNSNullAsNull)

- (id)objectForKeyNulled:(id)aKey;

@end
