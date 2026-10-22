import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

enum AdminRoutes {
    static let admin = Router.Routes.standard.admin.routerPath
    static let web = Router.Routes.standard.root.routerPath

    static var breadcrumb: [AdminBreadcrumb.Link] {
        Router.Routes.standard.breadcrumb
    }
}
