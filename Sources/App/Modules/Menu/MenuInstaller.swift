//
//  MenuInstaller.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import Vapor
import Fluent

/// installer component for the menu module
struct MenuInstaller: ViperInstaller {
    
    /// we create the main menu with some menu items
    func createModels(_ req: Request) -> EventLoopFuture<Void>? {
        let id = UUID()
        let mainMenu = MenuModel(id: id, handle: "main", name: "Main menu")

        let mainItems = [
            MenuItemModel(label: "Home", url: "/", priority: 1000, menuId: id),
            MenuItemModel(label: "Posts", url: "/posts/", priority: 900, menuId: id),
            MenuItemModel(label: "Categories", url: "/categories/", priority: 800, menuId: id),
            MenuItemModel(label: "Authors", url: "/authors/", priority: 700, menuId: id),
            MenuItemModel(label: "About", url: "/about/", priority: 600, menuId: id),
        ]
        
        /// we create the main menu with the associated menu items
        return mainMenu.create(on: req.db).flatMap {
            mainItems.create(on: req.db)
        }
    }
}
