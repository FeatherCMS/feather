import FeatherWebAdmin
public import FeatherWebShared

extension Contact {
    public enum Router {
        public struct Routes: Sendable {
            public let admin: WebRoute
            public let root: WebRoute

            public init(admin: WebRoute, root: WebRoute) {
                self.admin = admin
                self.root = root
            }

            public static let standard = Routes(
                admin: WebRoute.root.appending(pathComponent: "admin"),
                root: WebRoute.root
                    .appending(pathComponent: "admin")
                    .appending(pathComponent: "contact")
            )

            var breadcrumb: [AdminBreadcrumb.Link] {
                [
                    .init(label: "Admin", link: admin.path),
                    .init(label: "Contact", link: root.path),
                ]
            }
        }
    }
}
