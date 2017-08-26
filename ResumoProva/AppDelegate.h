//
//  AppDelegate.h
//  ResumoProva
//
//  Created by Felipe da Silva Barbosa on 8/25/17.
//  Copyright © 2017 Felipe da Silva Barbosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

