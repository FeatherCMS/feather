import Foundation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebModule

extension MenuItem {
    struct Router {
        struct Routes: Sendable {
            let menu: Menu.Router.Routes
            let items: WebRoute
            let itemsAdd: WebRoute
            let itemsRemove: WebRoute
            let itemDetails: WebRoute
            let itemEdit: WebRoute
            let itemMove: WebRoute
            let itemRemove: WebRoute

            enum RemoveOrigin: String, Sendable {
                case list
                case edit
                case view
            }

            init(menu: Menu.Router.Routes) {
                let items = menu.details.appending(pathComponent: "items")
                let itemDetails = items.appending(parameter: "itemId")
                self.menu = menu
                self.items = items
                self.itemsAdd = items.appending(pathComponent: "add")
                self.itemsRemove = items.appending(pathComponent: "remove")
                self.itemDetails = itemDetails
                self.itemEdit = itemDetails.appending(pathComponent: "edit")
                self.itemMove = itemDetails.appending(pathComponent: "move")
                self.itemRemove = itemDetails.appending(pathComponent: "remove")
            }

            func itemsPath(_ menuID: String) -> String {
                items.path(parameter: "id", value: menuID)
            }

            func itemsAddPath(_ menuID: String) -> String {
                itemsAdd.path(parameter: "id", value: menuID)
            }

            func itemsRemovePath(_ menuID: String) -> String {
                itemsRemove.path(parameter: "id", value: menuID)
            }

            func itemDetailsPath(menuID: String, itemID: String) -> String {
                itemPath(itemDetails, menuID: menuID, itemID: itemID)
            }

            func itemEditPath(menuID: String, itemID: String) -> String {
                itemPath(itemEdit, menuID: menuID, itemID: itemID)
            }

            func itemMovePath(menuID: String, itemID: String) -> String {
                itemPath(itemMove, menuID: menuID, itemID: itemID)
            }

            func itemRemovePath(
                menuID: String,
                itemID: String,
                origin: RemoveOrigin
            ) -> String {
                AdminLocation.url(
                    path: itemPath(
                        itemRemove,
                        menuID: menuID,
                        itemID: itemID
                    ),
                    queryItems: [
                        .init(name: "origin", value: origin.rawValue)
                    ]
                )
            }

            func removeOrigin(_ value: String?) -> RemoveOrigin {
                RemoveOrigin(rawValue: value ?? "") ?? .list
            }

            func itemBreadcrumb(_ menuID: String) -> [AdminBreadcrumb.Link] {
                menu.menuBreadcrumb(menuID) + [
                    .init(label: "Items", link: itemsPath(menuID))
                ]
            }

            private func itemPath(
                _ route: WebRoute,
                menuID: String,
                itemID: String
            ) -> String {
                try! route.path(
                    parameters: ["id": menuID, "itemId": itemID]
                )
            }
        }

        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine
        let routes: Routes

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            List
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)

            View
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)

            Add
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)

            Edit
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)

            Remove
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
        }
    }
}
