import FeatherWebAdmin
import Testing

@testable import WebModuleWebAdmin

@Suite
struct WebAdminRouterTestSuite {
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
        let routes = Page.Router.Routes(root: root)

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
        let routes = Menu.Router.Routes(root: root)

        #expect(routes.list.path == "/control/website/menus/")
        #expect(routes.add.path == "/control/website/menus/add/")
        #expect(routes.details.pattern == "/control/website/menus/{id}")
        #expect(routes.items.pattern == "/control/website/menus/{id}/items")
    }
}
