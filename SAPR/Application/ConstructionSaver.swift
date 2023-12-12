//
//  ConstructionSaver.swift
//  SAPR
//
//  Created by Владимир on 12.12.2023.
//

import Foundation
import UIKit
import CoreData



class ConstructionSaver {
    
    
    var constructions = [Construction]()
    
    
    init() {
        loadConstructions()
    }
    
    
    func saveConstruction(construction: Construction) {
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        let constructionEntity = NSEntityDescription.insertNewObject(forEntityName: "ConstructionEntity", into: managedContext) as! ConstructionEntity
        constructionEntity.name = construction.name
        constructionEntity.isLeftFixed = construction.supportParametres.isLeftFixed
        constructionEntity.isRightFixed = construction.supportParametres.isRightFixed
        constructionEntity.leftFocusedLoad = construction.focusedLoads[0]
        
        var materials = [RodMaterialEntity]()
        for material in construction.rodMaterials {
            let rodMaterialEntity = NSEntityDescription.insertNewObject(forEntityName: "RodMaterialEntity", into: managedContext) as! RodMaterialEntity
            rodMaterialEntity.construction = constructionEntity
            rodMaterialEntity.elasticModulus = material.elasticModulus
            rodMaterialEntity.permissibleVoltage = material.permissibleVoltage
            materials.append(rodMaterialEntity)
        }
        constructionEntity.materials = NSSet(array: materials)
        
        var sticksEntity = [StickEntity]()
        for i in 0 ..< construction.rodParametres.count {
            let stickEntity = NSEntityDescription.insertNewObject(forEntityName: "StickEntity", into: managedContext) as! StickEntity
            sticksEntity.append(stickEntity)
            stickEntity.num = Int16(i)
            stickEntity.construction = constructionEntity
            stickEntity.lenght = construction.rodParametres[i].length
            stickEntity.square = construction.rodParametres[i].square
            stickEntity.materialId = Int16(construction.rodParametres[i].materialId!)
            
            stickEntity.rightFocusedLoad = construction.focusedLoads[i + 1]
            stickEntity.distributedLoad = construction.distributedLoads[i]
        }
        constructionEntity.stick = NSSet(array: sticksEntity)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Не удалось сохранить конструкцию. Ошибка: \(error), \(error.userInfo)")
        }
    }
    
    
    func loadConstructions() {
        var constructions: [Construction] = []
        
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        let fetchRequest = NSFetchRequest<ConstructionEntity>(entityName: "ConstructionEntity")
        
        do {
            let constructionEntities = try managedContext.fetch(fetchRequest)
            for constructionEntity in constructionEntities {
                let supportParametres = SupportParametres(isLeftFixed: constructionEntity.isLeftFixed, isRightFixed: constructionEntity.isRightFixed)
                
                var rodMaterials = [RodMaterial]()
                
                if let materialsSet = constructionEntity.materials as? Set<RodMaterialEntity> {
                    materialsSet.forEach { material in
                        rodMaterials.append(RodMaterial(elasticModulus: material.elasticModulus, permissibleVoltage: material.permissibleVoltage))
                    }
                }
                var parametres = [RodParametres]()
                var focusedLoads = [constructionEntity.leftFocusedLoad]
                var distributedLoads = [Double]()
                if let sticksSet = constructionEntity.stick as? Set<StickEntity> {
                    let sortedSticks = sticksSet.sorted { $0.num < $1.num }
                    for stickEntity in sortedSticks {
                        parametres.append(RodParametres(length: stickEntity.lenght, square: stickEntity.square, materialId: Int(stickEntity.materialId)))
                        distributedLoads.append(stickEntity.distributedLoad)
                        focusedLoads.append(stickEntity.rightFocusedLoad)
                    }
                }
                
                constructions.append(Construction(name: constructionEntity.name, supportParametres: supportParametres, rodParametres: parametres, rodMaterials: rodMaterials, focusedLoads: focusedLoads, distributedLoads: distributedLoads))
            }
            
        } catch let error as NSError {
            print("Не удалось загрузить конструкции. Ошибка: \(error), \(error.userInfo)")
        }
        self.constructions = constructions
    }
    
    
    
    func deleteAll() {
        for entity in ["ConstructionEntity", "RodMaterialEntity", "StickEntity"] {
            deleteEntity(entityName: entity)
        }
    }
    
    
    func deleteConstruction(name: String) {
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }

        let fetchRequest: NSFetchRequest<ConstructionEntity> = ConstructionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
            let constructionsToDelete = try managedContext.fetch(fetchRequest)
            for constructionEntity in constructionsToDelete {
                managedContext.delete(constructionEntity)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Не удалось удалить конструкцию. Ошибка: \(error), \(error.userInfo)")
        }
    }
    
    
    private func deleteEntity(entityName: String) {
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result {
                managedContext.delete(data as! NSManagedObject)
            }
        } catch let error as NSError {
            print("Не удалось удалить данные. Ошибка: \(error), \(error.userInfo)")
        }
    }
}
