import FeatherWebAdmin
import FeatherWebShared
import Testing
import WebDomain
import WebModule

@testable import WebModuleWebAdmin

@Suite
struct AdminRouterTests {
    @Test
    func standardRoutesUseWebAdminRoot() {
        let routes = Router.Routes.standard

        #expect(routes.admin.path == "/admin/")
        #expect(routes.root.path == "/admin/web/")
    }

    @Test
    func pageRoutesDeriveFromConfiguredRoot() {
        let root = WebRoute.root
            .appending(pathComponent: "control")
            .appending(pathComponent: "website")
        let routes = Page.Router.Routes(
            root: root.appending(pathComponent: "pages"),
            breadcrumb: [],
            mediaAssetList:
                root
                .appending(pathComponent: "media")
                .appending(pathComponent: "assets")
        )

        #expect(routes.list.path == "/control/website/pages/")
        #expect(routes.add.path == "/control/website/pages/add/")
        #expect(routes.details.pattern == "/control/website/pages/{id}")
        #expect(
            routes.metadata.pattern
                == "/control/website/pages/{id}/edit/metadata/{metadataID}"
        )
    }

    @Test
    func menuRoutesDeriveFromConfiguredRoot() {
        let root = WebRoute.root
            .appending(pathComponent: "control")
            .appending(pathComponent: "website")
        let routes = Menu.Router.Routes(
            root: root.appending(pathComponent: "menus"),
            breadcrumb: []
        )

        #expect(routes.list.path == "/control/website/menus/")
        #expect(routes.add.path == "/control/website/menus/add/")
        #expect(routes.details.pattern == "/control/website/menus/{id}")
        let itemRoutes = MenuItem.Router.Routes(menu: routes)
        #expect(itemRoutes.items.pattern == "/control/website/menus/{id}/items")
    }
}
