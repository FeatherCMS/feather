import FeatherAdmin
import Hummingbird

enum MediaAdminRoutes {
    static let admin = RouterPath("admin")
    static let media = admin.appendingPath(RouterPath("media"))

    static let breadcrumb: [NewAdminBreadcrumb.Link] = [
        .init(label: "Admin", link: "/admin/"),
        .init(label: "Media", link: "/admin/media/"),
    ]
}

enum MediaAssetRoutes {
    static let list = MediaAdminRoutes.media.appendingPath(
        RouterPath("assets")
    )
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))

    static var listBreadcrumb: [NewAdminBreadcrumb.Link] {
        MediaAdminRoutes.breadcrumb
    }

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        MediaAdminRoutes.breadcrumb + [
            .init(label: "Assets", link: list.description)
        ]
    }

    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }

    static func edit(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("edit"))
    }

    static func remove(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("remove"))
    }
}

enum MediaFolderRoutes {
    static let list = MediaAssetRoutes.list
    static let add = MediaAdminRoutes.media
        .appendingPath(RouterPath("folders"))
        .appendingPath(RouterPath("add"))

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        MediaAdminRoutes.breadcrumb + [
            .init(label: "Assets", link: list.description)
        ]
    }

    static func edit(_ id: RouterPath) -> RouterPath {
        MediaAdminRoutes.media
            .appendingPath(RouterPath("folders"))
            .appendingPath(id)
            .appendingPath(RouterPath("edit"))
    }

    static func remove(_ id: RouterPath) -> RouterPath {
        MediaAdminRoutes.media
            .appendingPath(RouterPath("assets"))
            .appendingPath(RouterPath("folders"))
            .appendingPath(id)
            .appendingPath(RouterPath("remove"))
    }
}

enum MediaProcessorRoutes {
    static let list = MediaAdminRoutes.media.appendingPath(
        RouterPath("processors")
    )
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))

    static var listBreadcrumb: [NewAdminBreadcrumb.Link] {
        MediaAdminRoutes.breadcrumb
    }

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        MediaAdminRoutes.breadcrumb + [
            .init(label: "Processors", link: list.description)
        ]
    }

    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }

    static func edit(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("edit"))
    }

    static func remove(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("remove"))
    }
}
