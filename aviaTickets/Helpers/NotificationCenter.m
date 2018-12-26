//
//  NotificationCenter.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 24/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "NotificationCenter.h"
#import "UserNotifications/UserNotifications.h"

@interface NotificationCenter() <UNUserNotificationCenterDelegate>

@end

@implementation NotificationCenter

+ (instancetype)sharedInstance
{
  static NotificationCenter *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [NotificationCenter new];
  });
  return instance;
}

- (void)registerService
{
  if (@available(iOS 10.0, *)) {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
      if (!error) {
        NSLog(@"Permissions were granted");
      }
    }];
  }
}

- (void)sendNotification:(Notification)notification
{
  if (@available(iOS 10.0, *)) {
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = notification.title;
    content.body = notification.body;
    content.sound = [UNNotificationSound defaultSound];
    
    if (notification.imageURL) {
      UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:notification.imageURL options:nil error:nil];
      if (attachment) {
        content.attachments = @[attachment];
      }
    }
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar componentsInTimeZone:[NSTimeZone localTimeZone] fromDate:notification.date];
    NSDateComponents *notificationTriggerDate = [NSDateComponents new];
    notificationTriggerDate.calendar = calendar;
    notificationTriggerDate.timeZone = [NSTimeZone localTimeZone];
    notificationTriggerDate.month = dateComponents.month;
    notificationTriggerDate.day = dateComponents.day;
    notificationTriggerDate.hour = dateComponents.hour;
    notificationTriggerDate.minute = dateComponents.minute;
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:notificationTriggerDate repeats:NO];
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"Notification" content:content trigger:trigger];
    UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    [notificationCenter addNotificationRequest:notificationRequest withCompletionHandler:nil];
  }
}

Notification NotificationMake(NSString* _Nullable title, NSString* _Nonnull body, NSDate* _Nonnull date, NSURL* _Nullable imageURL)
{
  Notification notification;
  notification.title = title;
  notification.body = body;
  notification.date = date;
  notification.imageURL = imageURL;
  return notification;
}

@end
