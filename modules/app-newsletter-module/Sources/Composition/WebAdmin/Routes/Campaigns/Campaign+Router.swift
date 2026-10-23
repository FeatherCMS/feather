import FeatherWebAdmin
import FeatherWebShared
import NewsletterModule

extension Campaign {
    enum Router {}
}

extension Campaign.Router {
    struct Routes: Sendable {
        let admin: WebRoute
        let root: WebRoute
        let list: WebRoute
        let add: WebRoute
        let removeSelected: WebRoute
        let details: WebRoute
        let edit: WebRoute
        let breadcrumb: [AdminBreadcrumb.Link]

        init(admin: WebRoute, root: WebRoute) {
            self.admin = admin
            self.root = root
            self.list = root.appending(pathComponent: "campaigns")
            self.add = list.appending(pathComponent: "add")
            self.removeSelected = root.appending(pathComponent: "remove")
            self.details =
                list
                .appending(parameter: "newsletterId")
                .appending(pathComponent: "details")
            self.edit =
                list
                .appending(parameter: "newsletterId")
                .appending(pathComponent: "edit")
            self.breadcrumb = [
                .init(label: "Admin", link: admin.path),
                .init(label: "Newsletter", link: root.path),
            ]
        }

        func detailsPath(_ id: String) -> String {
            details.path(parameter: "newsletterId", value: id)
        }

        func editPath(_ id: String) -> String {
            edit.path(parameter: "newsletterId", value: id)
        }
    }
}
