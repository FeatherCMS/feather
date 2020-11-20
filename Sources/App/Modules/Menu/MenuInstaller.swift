//
//  MenuInstaller.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import FeatherCore

/// installer component for the menu module
struct MenuInstaller: ViperInstaller {
    
    /// we create the menus with the associated menu items
    func createModels(_ req: Request) -> EventLoopFuture<Void>? {
        let mainId = UUID()
        let mainMenu = MenuModel(id: mainId, handle: "main", name: "Main menu")

        let mainItems = [
            MenuItemModel(label: "Home", url: "/", priority: 1000, menuId: mainId),
            MenuItemModel(label: "Posts", url: "/posts/", priority: 900, menuId: mainId),
            MenuItemModel(label: "Categories", url: "/categories/", priority: 800, menuId: mainId),
            MenuItemModel(label: "Authors", url: "/authors/", priority: 700, menuId: mainId),
            MenuItemModel(label: "About", url: "/about/", priority: 600, menuId: mainId),
        ]

        let footerId = UUID()
        let footerMenu = MenuModel(id: footerId, handle: "footer", name: "Footer menu")

        let footerItems = [
            MenuItemModel(label: "Sitemap", url: "/sitemap.xml", priority: 1000, targetBlank: true, menuId: footerId),
            MenuItemModel(label: "RSS", url: "/rss.xml", priority: 900, targetBlank: true, menuId: footerId),
        ]

        return [mainMenu, footerMenu].create(on: req.db).flatMap {
            (mainItems + footerItems).create(on: req.db)
        }
    }
}
