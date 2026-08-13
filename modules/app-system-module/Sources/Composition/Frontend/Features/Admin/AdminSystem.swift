import FeatherAdmin
import FeatherApplication
import FeatherContracts
import Hummingbird

public struct AdminSystem {
    public let renderingEngine: any RenderingEngine
    private let adminEvents: any EventPublisher

    public init(
        renderingEngine: any RenderingEngine,
        adminEvents: any EventPublisher
    ) {
        self.renderingEngine = renderingEngine
        self.adminEvents = adminEvents
    }

    public enum Scope {
        public static let permissions = PermissionScope(
            module: "system",
            resource: "permissions"
        )
        public static let variables = PermissionScope(
            module: "system",
            resource: "variables"
        )
        public static let jobs = PermissionScope(
            module: "system",
            resource: "jobs"
        )
    }

    public func route(
        on router: Router<AppRequestContext>
    ) {
        AdminGetHome(
            renderingEngine: renderingEngine,
            events: adminEvents
        )
        .controller.route(on: router)

        AdminGetSystemHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListSystemPermission(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetSystemPermission(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddSystemPermission(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditSystemPermission(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveSystemPermission(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListSystemVariable(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddSystemVariable(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditSystemVariable(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveSystemVariable(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetSystemVariable(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListSystemJob(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetSystemJob(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
