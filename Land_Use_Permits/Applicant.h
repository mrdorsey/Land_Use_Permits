//
//  Applicant.h
//  Land_Use_Permits
//
//  Created by Michael Dorsey on 11/26/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Applicant : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet *applications;
@end

@interface Applicant (CoreDataGeneratedAccessors)

- (void)addApplicationsObject:(NSManagedObject *)value;
- (void)removeApplicationsObject:(NSManagedObject *)value;
- (void)addApplications:(NSSet *)values;
- (void)removeApplications:(NSSet *)values;

+ (Applicant *)findOrCreateApplicantWithName:(NSString *)searchName
                                     context:(NSManagedObjectContext *)moc;

+ (NSArray *)applicantsWithName:(NSString *)searchName
                        context:(NSManagedObjectContext *)moc;

@end
