//
//  SuccessViewController.m
//  liveDeal
//
//  Created by claudio barbera on 03/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()

@end

@implementation SuccessViewController
@synthesize offertaSelezionata, lblTitolo, btnAddReminder;

- (void)viewDidLoad
{
    [super viewDidLoad];
    store = [[EKEventStore alloc] init];
    self.navigationItem.hidesBackButton = YES;

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
   
    
	// Do any additional setup after loading the view.
    
    [lblTitolo setText:[NSString stringWithFormat:@"Complimenti, hai acquistato il deal %@", offertaSelezionata.Titolo]];
    [lblTitolo  setVerticalAlignment:MSLabelVerticalAlignmentMiddle];
    [lblTitolo setLineHeight:14];
    
    btnAddReminder.hidden =  ![store respondsToSelector:@selector(requestAccessToEntityType:completion:)];
}

-(IBAction)backToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)performCalendarActivity
{

    EKEvent *myEvent  = [EKEvent eventWithEventStore:store];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    myEvent.title     =  offertaSelezionata.Titolo;
    myEvent.startDate =  [dateformatter dateFromString:offertaSelezionata.DataFineValidita];
    myEvent.endDate   =[dateformatter dateFromString:offertaSelezionata.DataFineValidita];
    
    myEvent.allDay = NO;
    
    [myEvent setCalendar:[store defaultCalendarForNewEvents]];
    
    NSMutableArray *myAlarmsArray = [[NSMutableArray alloc] init];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //calcolo la data per l'allarme. tolgo un giorno dalla data scadenza
    NSDate *dataReminder = [[dateformatter dateFromString:offertaSelezionata.DataFineValidita] dateByAddingTimeInterval:-1*24*60*60];
    
    //imposto l'orario della notifica in base a quanto scelto nelle preferenze
    NSDate *oraNotifica = [[NSUserDefaults standardUserDefaults] objectForKey:@"orarioNotifiche"];
    
    NSDateComponents *timecomponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:oraNotifica];

    
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:dataReminder];
   
    [components setHour: [timecomponents hour]];
    [components setMinute: [timecomponents minute]];

    
    
    NSDate *data = [calendar dateFromComponents: components];
    
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:data];
    
    [myAlarmsArray addObject:alarm];
    myEvent.alarms = myAlarmsArray;
   
    NSError *err = nil;
    [store saveEvent:myEvent span:EKSpanThisEvent error:&err];
    
    if (err == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *errorString = @"La scadenza del deal è stata aggiunta al calendario.";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ok" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
        });
    }
    else
    {
        NSLog(@"DetailedError: %@", [err userInfo]);
    }
}
-(void)addToCalendar:(id)sender
{
   
    if([store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted){
                //---- codes here when user allow your app to access theirs' calendar.
                [self performCalendarActivity];
            }else
            {
                //----- codes here when user NOT allow your app to access the calendar.
            }
        }];
    }
    else
    {
          [self performCalendarActivity];
    }
    
   
}

-(void)performReminderActivity
{
    EKReminder *reminder = [EKReminder reminderWithEventStore:store];
    
    reminder.title = offertaSelezionata.Titolo;
    
    [reminder setCalendar:[store defaultCalendarForNewReminders]];
    
    NSMutableArray *myAlarmsArray = [[NSMutableArray alloc] init];
      
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //calcolo la data per l'allarme. tolgo un giorno dalla data scadenza
    NSDate *dataReminder = [[dateformatter dateFromString:offertaSelezionata.DataFineValidita] dateByAddingTimeInterval:-1*24*60*60];
    
    NSDate *oraNotifica = [[NSUserDefaults standardUserDefaults] objectForKey:@"orarioNotifiche"];
    
    NSDateComponents *timecomponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:oraNotifica];
    NSInteger hour = [timecomponents hour];
    NSInteger minute = [timecomponents minute];
    
    
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:dataReminder];
    
    [components setHour: hour];
    [components setMinute: minute];
    
    
    
    NSDate *data = [calendar dateFromComponents: components];
    
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:data];
    
    [myAlarmsArray addObject:alarm];
    
    reminder.alarms = myAlarmsArray;

                       
    NSError *err;
    BOOL success = [store saveReminder:reminder commit:YES error:&err];
    
    if (!success) {
        NSLog(@"DetailedError: %@", [err userInfo]);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *errorString = @"La scadenza del deal è stata aggiunta al promemoria. Ti verrà ricordata un giorno prima.";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ok" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
        });

        
    }
}
-(void)addReminder:(id)sender
{
    [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        
        if (granted)
        {
            [self performReminderActivity];
        }
    }];
}

@end
