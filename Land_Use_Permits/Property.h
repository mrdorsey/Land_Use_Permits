//
//  Property.h
//  Land_Use_Permits
//
//  Created by Michael Dorsey on 11/26/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Application;

@interface Property : NSManagedObject

@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSSet *applications;
@end

@interface Property (CoreDataGeneratedAccessors)

- (void)addApplicationsObject:(Application *)value;
- (void)removeApplicationsObject:(Application *)value;
- (void)addApplications:(NSSet *)values;
- (void)removeApplications:(NSSet *)values;

+ (Property *)findOrCreatePropertyWithAddress:(NSString *)searchAddress
									  context:(NSManagedObjectContext *)moc;

+ (NSArray *)propertiesWithAddress:(NSString *)searchAddress
						   context:(NSManagedObjectContext *)moc;

@end
