//
//  Property.m
//  Land_Use_Permits
//
//  Created by Michael Dorsey on 11/26/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import "Property.h"
#import "Application.h"


@implementation Property

@dynamic address;
@dynamic latitude;
@dynamic longitude;
@dynamic applications;

/*- (void)awakeFromInsert {
	self.latitude = @47.6097;
	self.longitude = @122.3331;
}*/

+ (Property *)findOrCreatePropertyWithAddress:(NSString *)searchAddress
									  context:(NSManagedObjectContext *)moc {
	NSArray *properties = [self propertyWithAddress:searchAddress context:moc];
	
	Property *resultProperty = [properties lastObject];
	if(!resultProperty) {
		resultProperty = [NSEntityDescription
						  insertNewObjectForEntityForName:@"Property" inManagedObjectContext:moc];
		resultProperty.address = searchAddress;
	}
	
	return resultProperty;
}

+ (NSArray *)propertyWithAddress:(NSString *)searchAddress
								  context:(NSManagedObjectContext *)moc {
	NSManagedObjectModel *mom = moc.persistentStoreCoordinator.managedObjectModel;
	
	NSFetchRequest *propertyAddressFetchRequest = [mom fetchRequestFromTemplateWithName:@"PropertiesByAddress"
																		  substitutionVariables:@{@"searchAddress" : searchAddress}];
	
	propertyAddressFetchRequest.fetchBatchSize = 1;
	
	NSError *error = nil;
	NSArray *result = [moc executeFetchRequest:propertyAddressFetchRequest error:&error];
	if(!result) {
		NSLog(@"%@", error.localizedDescription);
	}
	
	return result;
}

@end
