import FeatherAdmin
import Hummingbird

enum MediaVariantRoutes {
    static let list = MediaAdminRoutes.media.appendingPath(RouterPath("variants"))
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))
    static let editRoute = edit(RouterPath("{id}"))
    static let processorAddRoute = processorAdd(RouterPath("{id}"))
    static let processorEditRoute = processorEdit(RouterPath("{id}"), processorId: RouterPath("{processorId}"))
    static let processorRemoveRoute = processorRemove(RouterPath("{id}"))

    static func edit(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id).appendingPath(RouterPath("edit"))
    }

    static func processorAdd(_ id: RouterPath) -> RouterPath {
        edit(id)
            .appendingPath(RouterPath("processors"))
            .appendingPath(RouterPath("add"))
    }

    static func processorEdit(_ id: RouterPath, processorId: RouterPath) -> RouterPath {
        edit(id)
            .appendingPath(RouterPath("processors"))
            .appendingPath(processorId)
            .appendingPath(RouterPath("edit"))
    }

    static func processorRemove(_ id: RouterPath) -> RouterPath {
        edit(id)
            .appendingPath(RouterPath("processors"))
            .appendingPath(RouterPath("remove"))
    }

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        MediaAdminRoutes.breadcrumb + [.init(label: "Variants", link: list.description)]
    }
}
