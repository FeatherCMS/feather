import FeatherWebAdmin
import MediaWebAdmin
import FeatherWebShared
import Testing

@Suite
struct RouterRoutesTests {
    @Test
    func standardRoutesUseMediaAdminRoot() {
        let routes = Router.Routes.standard

        #expect(routes.admin.path == "/admin/")
        #expect(routes.root.path == "/admin/media/")
        #expect(routes.assetList.path == "/admin/media/assets/")
        #expect(routes.assetAdd.path == "/admin/media/assets/add/")
        #expect(routes.variantList.path == "/admin/media/variants/")
    }

    @Test
    func routesCanUseACustomRoot() {
        let routes = Router.Routes(
            admin: WebRoute.root.appending(pathComponent: "control"),
            root: WebRoute.root
                .appending(pathComponent: "control")
                .appending(pathComponent: "library")
        )

        #expect(routes.admin.path == "/control/")
        #expect(routes.root.path == "/control/library/")
        #expect(routes.assetList.path == "/control/library/assets/")
        #expect(routes.assetAdd.path == "/control/library/assets/add/")
        #expect(routes.variantList.path == "/control/library/variants/")
    }
}
