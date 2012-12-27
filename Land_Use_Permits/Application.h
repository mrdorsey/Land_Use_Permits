//
//  Application.h
//  Land_Use_Permits
//
//  Created by Michael Dorsey on 11/27/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Applicant, Property;

@interface Application : NSManagedObject

@property (nonatomic, retain) NSDate *applicationDate;
@property (nonatomic, retain) NSDate *decisionDate;
@property (nonatomic, retain) NSDate *issueDate;
@property (nonatomic, retain) NSString *statusURL;
@property (nonatomic, retain) NSString *permitNumber;
@property (nonatomic, retain) NSString *permitTypes;
@property (nonatomic, retain) NSString *permitDescription;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSNumber *estimatedValue;
@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, retain) Applicant *applicant;
@property (nonatomic, retain) Property *property;

+ (Application *)findOrCreateApplicationWithPermitNumber:(NSString *)searchNumber
                                                 context:(NSManagedObjectContext *)moc;

+ (NSArray *)applicationsWithPermitNumber:(NSString *)searchNumber
                                  context:(NSManagedObjectContext *)moc;

+ (NSString *)stringForJSONURL;

+ (BOOL)repopulateFromScratch:(NSManagedObjectContext *)moc;

+ (BOOL)repopulateFromScratchWithData:(NSData *)inputData
								context:(NSManagedObjectContext *)moc;
@end
