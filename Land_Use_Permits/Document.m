//
//  Document.m
//  Land_Use_Permits
//
//  Created by Michael Dorsey on 11/25/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import "Applicant.h"
#import "Application.h"
#import "Document.h"
#import "Property.h"

@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
		// Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (IBAction)fakeSomeData:(id)sender
{
    Applicant *larry = [Applicant findOrCreateApplicantWithName:@"Larry"
                                                        context:self.managedObjectContext];
    Applicant *moe = [Applicant findOrCreateApplicantWithName:@"Moe"
                                                      context:self.managedObjectContext];
    Applicant *curly = [Applicant findOrCreateApplicantWithName:@"Curly"
                                                        context:self.managedObjectContext];
    Property *one = [Property findOrCreatePropertyWithAddress:@"123 1ST ST"
                                                      context:self.managedObjectContext];
    Property *two = [Property findOrCreatePropertyWithAddress:@"123 2ND ST"
                                                      context:self.managedObjectContext];
    Property *three = [Property findOrCreatePropertyWithAddress:@"123 3RD ST"
                                                        context:self.managedObjectContext];
    Property *four = [Property findOrCreatePropertyWithAddress:@"123 4TH ST"
                                                       context:self.managedObjectContext];
    Application *a = [Application findOrCreateApplicationWithPermitNumber:@"10001"
                                                                  context:self.managedObjectContext];
    a.applicant = larry;
    a.property = one;
	a.applicationDate = [NSDate date];
	a.estimatedValue = @111.111;
	
    Application *b = [Application findOrCreateApplicationWithPermitNumber:@"10002"
                                                                  context:self.managedObjectContext];
    b.applicant = moe;
    b.property = two;
	b.applicationDate = [NSDate date];
	b.estimatedValue = @222.222;
	
    Application *c = [Application findOrCreateApplicationWithPermitNumber:@"10003"
                                                                  context:self.managedObjectContext];
    c.applicant = curly;
    c.property = three;
	c.applicationDate = [NSDate date];
	c.estimatedValue = @333.333;
	
    Application *d = [Application findOrCreateApplicationWithPermitNumber:@"10004"
                                                                  context:self.managedObjectContext];
    d.applicant = larry;
    d.property = four;
	d.applicationDate = [NSDate date];
	d.estimatedValue = @444.444;
	
    Application *e = [Application findOrCreateApplicationWithPermitNumber:@"10005"
															context:self.managedObjectContext];
    e.applicant = moe;
    e.property = one;
	e.applicationDate = [NSDate date];
	e.estimatedValue = @555.555;
	
    Application *f = [Application findOrCreateApplicationWithPermitNumber:@"10006"
                                                                  context:self.managedObjectContext];
    f.applicant = curly;
    f.property = two;
	f.applicationDate = [NSDate date];
    f.estimatedValue = @666.666;
	
	Application *g = [Application findOrCreateApplicationWithPermitNumber:@"10007"
                                                                  context:self.managedObjectContext];
    g.applicant = larry;
    g.property = three;
	g.applicationDate = [NSDate date];
	g.estimatedValue = @777.777;
	
    Application *h = [Application findOrCreateApplicationWithPermitNumber:@"10008"
                                                                  context:self.managedObjectContext];
    h.applicant = moe;
    h.property = four;
	h.applicationDate = [NSDate date];
	h.estimatedValue = @888.888;
	
    Application *i = [Application findOrCreateApplicationWithPermitNumber:@"10009"
                                                                  context:self.managedObjectContext];
    i.applicant = curly;
    i.property = one;
	i.applicationDate = [NSDate date];
	i.estimatedValue = @999.999;
	
	Application *j = [Application findOrCreateApplicationWithPermitNumber:@"10010"
		context:self.managedObjectContext];
	j.applicant = [Applicant findOrCreateApplicantWithName:@"Shemp" context:self.managedObjectContext];
	j.property = [Property findOrCreatePropertyWithAddress:@"123 5TH ST"
												   context:self.managedObjectContext];
	j.applicationDate = [NSDate date];
	j.estimatedValue = @10001.00001;
}

- (IBAction)fetchIt:(id)sender {
	[Application repopulateFromScratch:[self managedObjectContext]];
}

@end
