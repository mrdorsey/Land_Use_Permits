//
//  Application.m
//  Land_Use_Permits
//
//  Created by Michael Dorsey on 11/27/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import "Application.h"
#import "Applicant.h"
#import "Property.h"


@implementation Application

@dynamic permitNumber;
@dynamic applicationDate;
@dynamic decisionDate;
@dynamic issueDate;
@dynamic statusURL;
@dynamic permitTypes;
@dynamic permitDescription;
@dynamic category;
@dynamic estimatedValue;
@dynamic status;
@dynamic applicant;
@dynamic property;

/*- (void)awakeFromInsert {
	self.applicationDate = [NSDate date];
	self.estimatedValue = @122.3331;
}*/

+ (Application *)findOrCreateApplicationWithPermitNumber:(NSString *)searchNumber
												 context:(NSManagedObjectContext *)moc {
	NSArray *applications = [self applicationsWithPermitNumber:searchNumber context:moc];
	
	Application *resultApplication = [applications lastObject];
	if (!resultApplication) {
		resultApplication = [NSEntityDescription
							 insertNewObjectForEntityForName:@"Application" inManagedObjectContext:moc];
		resultApplication.permitNumber = searchNumber;
	}
	
	return resultApplication;
}

+ (NSArray *)applicationsWithPermitNumber:(NSString *)searchNumber context:(NSManagedObjectContext *)moc {
	NSManagedObjectModel *mom = moc.persistentStoreCoordinator.managedObjectModel;
	
	NSFetchRequest *applicationsPermitNumberFetchRequest = [mom fetchRequestFromTemplateWithName:@"ApplicationsByPermitNumber"
																		   substitutionVariables:@{@"permitNumber" : searchNumber}];
	
	applicationsPermitNumberFetchRequest.fetchBatchSize = 1;
	
	NSError *error = nil;
	NSArray *result = [moc executeFetchRequest:applicationsPermitNumberFetchRequest error:&error];
	if (!result) {
		NSLog(@"%@", error.localizedDescription);
	}
	
	return result;
}

+ (NSString *)stringForJSONURL {
	return @"https://data.seattle.gov/api/views/uyyd-8gak/rows.json?accessType=DOWNLOAD";
}

+ (void)explorePulledData:(NSDictionary *)pulledData {
	NSArray *data = pulledData[@"data"];
	NSDictionary *meta = pulledData[@"meta"];
	NSLog(@"'meta' keys: %@", meta.allKeys);
	NSDictionary *view = meta[@"view"];
	NSLog(@"'view' keys: %@", view.allKeys);
	
	NSArray *columns = view[@"columns"];
	NSLog(@"columns are of class %@", columns.class);
	NSLog(@"column elements are of class %@", [columns[0] class]);
	NSDictionary *aColumnsElement = columns[0];
	NSLog(@"column keys are %@", aColumnsElement.allKeys);
	
	int columnCount = 0;
	NSLog(@"column values: position name description dataTypeName fieldName");
	for (NSDictionary *obj in columns) {
		columnCount++;
		NSLog(@"column %d: %@ %@ %@ %@ %@", columnCount, obj[@"position"], obj[@"name"], obj[@"description"], obj[@"dataTypeName"], obj[@"fieldName"]);
	}
	NSLog(@"meta %@ %@", meta.class, meta.allKeys);
	NSLog(@"view %@ %@", view.class, view.allKeys);
	
	int i = 0;
	for (NSArray *row in data) {
		int j = 0;
		for (id col in row) {
			NSLog(@"%d %@", j++, col);
		}
		if (i++ > 20) {
			break;
		}
	}
}

+ (BOOL)repopulateFromScratchWithData:(NSData *)inputData
							  context:(NSManagedObjectContext *)moc {
	NSParameterAssert(moc);
	
	NSLog(@"parsing data, size %ld bytes", inputData.length);
	NSDictionary *pulledData;
	NSError *error;
	pulledData = [NSJSONSerialization JSONObjectWithData:inputData options:kNilOptions error:&error];
	
	if (!pulledData) {
		NSLog(@"%@ %@", error.localizedDescription, error.localizedFailureReason);
		return NO;
	}
	else {
		[self explorePulledData:pulledData];
		NSLog(@"data pulled");
		
		NSDateFormatter *rfcDateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[[NSLocale alloc]
									  initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
        rfcDateFormatter.locale = enUSPOSIXLocale;
        rfcDateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
        rfcDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
		
		for (NSArray *row in pulledData[@"data"]) {
			NSString *permitNumberString = nil;
			NSString *addressString = nil;
			NSString *applicantString = nil;
			
			if (row[8] != [NSNull null]) {
				permitNumberString = row[8];
			}
			if (row[10] != [NSNull null]) {
				addressString = row[10];
			}
			if (row[16] != [NSNull null]) {
				applicantString = row[16];
			}
			
			Application *application = [Application findOrCreateApplicationWithPermitNumber:permitNumberString context:moc];
			
			application.permitNumber = permitNumberString;
			if (row[9] != [NSNull null]) {
				application.permitTypes = row[9];
			}
			if (row[11] != [NSNull null]) {
				application.permitDescription = row[11];
			}
			if (row[12] != [NSNull null]) {
				application.category = row[12];
			}
			if (row[21] != [NSNull null]) {
				application.status = row[21];
			}
			application.statusURL = row[22][0];
			if (row[15] != [NSNull null]) {
				NSString *estimatedValueString = row[15];
				application.estimatedValue = @([estimatedValueString doubleValue]);
			}
			if (row[17] != [NSNull null]) {
				NSString *applicationDateString = row[17];
				application.applicationDate = [rfcDateFormatter dateFromString:applicationDateString];
			}
			if (row[18] != [NSNull null]) {
				NSString *decisionDateString = row[18];
				application.decisionDate = [rfcDateFormatter dateFromString:decisionDateString];
			}
			if (row[20] != [NSNull null]) {
				NSString *issueDateString = row[20];
				application.issueDate = [rfcDateFormatter dateFromString:issueDateString];
			}
			
			if (applicantString) {
				Applicant *applicant = [Applicant findOrCreateApplicantWithName:applicantString context:moc];
				application.applicant = applicant;
			}
			
			if (addressString) {
				Property *property = [Property findOrCreatePropertyWithAddress:addressString context:moc];
				
				if (row[23] != [NSNull null]) {
					NSString *latString = row[23];
					property.latitude = @([latString doubleValue]);
				}
				if (row[24] != [NSNull null]) {
					NSString *longString = row[24];
					property.longitude	= @([longString doubleValue]);
				}
				application.property = property;
			}
		}
		
		[rfcDateFormatter release];
	}
	NSLog(@"parsing complete");
	return YES;
}

+ (BOOL)repopulateFromScratch:(NSManagedObjectContext *)moc {
	NSParameterAssert(moc);
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self stringForJSONURL]]];
	
	return [self repopulateFromScratchWithData:data context:moc];
}

@end
