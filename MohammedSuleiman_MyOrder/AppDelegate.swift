//
//  AppDelegate.swift
//  MohammedSuleiman_MyOrder
//
//  Created by Mohammed on 2021-02-05.
// Name: Mohammed Suleiman Mohamed Al-Falahy    ID: 121083174

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    //Core stack (Initializing persistentContainer)
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoffeeOrderModel")
        container.loadPersistentStores { (StoreDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error) : \(error.userInfo)")
            }
        }
        return container
    }()
    
    //saves the changes to the db
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do{
                try context.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError) : \(nsError.userInfo)")
            }
        }
    }
}

