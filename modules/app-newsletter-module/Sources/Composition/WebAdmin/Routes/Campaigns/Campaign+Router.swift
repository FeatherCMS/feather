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

        static let standard = Routes(
            admin: WebRoute.root.appending(pathComponent: "admin"),
            root: WebRoute.root
                .appending(pathComponent: "admin")
                .appending(pathComponent: "newsletter")
        )

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

        var subscribers: WebRoute {
            list.appending(parameter: "newsletterId")
                .appending(pathComponent: "subscribers")
        }

        var issues: WebRoute {
            list.appending(parameter: "newsletterId")
                .appending(pathComponent: "issues")
        }

        var issueAdd: WebRoute {
            issues.appending(pathComponent: "add")
        }

        var issueDetails: WebRoute {
            issues.appending(parameter: "issueId")
        }

        var issueEdit: WebRoute {
            issueDetails.appending(pathComponent: "edit")
        }

        var issueRemove: WebRoute {
            issueDetails.appending(pathComponent: "remove")
        }

        var issueTestEmail: WebRoute {
            issues.appending(pathComponent: "test-email")
        }

        var issueDetailTestEmail: WebRoute {
            issueDetails.appending(pathComponent: "test-email")
        }

        func issuesPath(newsletterId: String) -> String {
            issues.path(parameter: "newsletterId", value: newsletterId)
        }

        func issueAddPath(newsletterId: String) -> String {
            issueAdd.path(parameter: "newsletterId", value: newsletterId)
        }

        func issueEditPath(newsletterId: String, issueId: String) -> String {
            try! issueEdit.path(
                parameters: [
                    "newsletterId": newsletterId,
                    "issueId": issueId,
                ]
            )
        }

        func issueDetailsPath(newsletterId: String, issueId: String) -> String {
            try! issueDetails.path(
                parameters: [
                    "newsletterId": newsletterId,
                    "issueId": issueId,
                ]
            )
        }

        func issueRemovePath(newsletterId: String, issueId: String) -> String {
            try! issueRemove.path(
                parameters: [
                    "newsletterId": newsletterId,
                    "issueId": issueId,
                ]
            )
        }

        func issueTestEmailPath(newsletterId: String) -> String {
            issueTestEmail.path(parameter: "newsletterId", value: newsletterId)
        }

        func issueDetailTestEmailPath(
            newsletterId: String,
            issueId: String
        ) -> String {
            try! issueDetailTestEmail.path(
                parameters: [
                    "newsletterId": newsletterId,
                    "issueId": issueId,
                ]
            )
        }
    }
}
