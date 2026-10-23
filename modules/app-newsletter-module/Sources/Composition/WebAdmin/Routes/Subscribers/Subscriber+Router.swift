import FeatherWebAdmin
import FeatherWebShared
import NewsletterModule

extension Subscriber {
    enum Router {}
}

extension Subscriber.Router {
    struct Routes: Sendable {
        let admin: WebRoute
        let root: WebRoute
        let list: WebRoute
        let add: WebRoute
        let remove: WebRoute
        let details: WebRoute
        let breadcrumb: [AdminBreadcrumb.Link]

        init(admin: WebRoute, root: WebRoute) {
            self.admin = admin
            self.root = root
            self.list = root.appending(pathComponent: "subscribers")
            self.add = list.appending(pathComponent: "add")
            self.remove = list.appending(pathComponent: "remove")
            self.details = list.appending(parameter: "subscriberId")
            self.breadcrumb = [
                .init(label: "Admin", link: admin.path),
                .init(label: "Newsletter", link: root.path),
            ]
        }

        func detailsPath(_ id: String) -> String {
            details.path(parameter: "subscriberId", value: id)
        }
    }
}
