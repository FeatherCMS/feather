public import BlogModule
public import FeatherWebAdmin
public import FeatherWebShared

extension Settings {
    public enum Router {
        public struct Routes: Sendable {
            let settings: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]

            public init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                let settings = root.appending(pathComponent: "settings")
                self.settings = settings
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Settings", link: settings.path)
                    ]
            }
        }
    }
}
