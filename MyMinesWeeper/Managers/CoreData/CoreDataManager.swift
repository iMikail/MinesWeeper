//
//  CoreDataManager.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 1.03.23.
//

import CoreData

final class CoreDataManager {
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "StoredRecords")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    private lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext

    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    func updateRecords(fromData data: Data) {
        deleteRecords()
        saveRecordsData(data)
    }

    private func deleteRecords() {
        let requested = StoreRecords.fetchRequest()
        do {
            let recordsArray = try viewContext.fetch(requested)
            for records in recordsArray {
                viewContext.delete(records)
                print("CoreData: records deleted")
            }
        } catch {
            let nserror = error as NSError
            print(nserror.description)
        }
    }

    private func saveRecordsData(_ data: Data) {
        guard let recDesc = NSEntityDescription.entity(forEntityName: String(describing: StoreRecords.self),
                                                                 in: viewContext) else {
            return
        }

        let storeRecords = StoreRecords(entity: recDesc, insertInto: viewContext)
        storeRecords.records = data
        saveContext()
        print("CoreData: records saved")
    }

    func fetchStoreRecordsData() -> Data? {
        do {
            let fetchData = StoreRecords.fetchRequest()
            let storeRecords = try viewContext.fetch(fetchData)

            return storeRecords.first?.records

        } catch let error {
            print("CoreData: \(error)")
        }

        return nil
    }
}
