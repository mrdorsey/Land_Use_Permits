//
//  Applicant.m
//  Land_Use_Permits
//
//  Created by Michael Dorsey on 11/26/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import "Applicant.h"


@implementation Applicant

@dynamic name;
@dynamic applications;

+ (Applicant *)findOrCreateApplicantWithName:(NSString *)searchName
									 context:(NSManagedObjectContext *)moc {
	NSArray *applicants = [self applicantsWithName:searchName context:moc];
	
	Applicant *resultApplicant = [applicants lastObject];
	
	if(!resultApplicant) {
		resultApplicant = [NSEntityDescription
						   insertNewObjectForEntityForName:@"Applicant" inManagedObjectContext:moc];
		resultApplicant.name = searchName;
	}
	
	return resultApplicant;
}

+ (NSArray *)applicantsWithName:(NSString *)searchName
								  context:(NSManagedObjectContext *)moc {
	NSManagedObjectModel *mom = moc.persistentStoreCoordinator.managedObjectModel;
	
	NSFetchRequest *applicantNameFetchRequest = [mom fetchRequestFromTemplateWithName:@"ApplicantsByName"
																		  substitutionVariables:@{@"name" : searchName}];
	
	applicantNameFetchRequest.fetchBatchSize = 1;
	
	NSError *error = nil;
	NSArray *result = [moc executeFetchRequest:applicantNameFetchRequest error:&error];
	if(!result) {
		NSLog(@"%@", error.localizedDescription);
	}
	
	return result;
}

@end
