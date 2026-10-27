import FeatherWebAdmin
import FeatherWebShared
import NewsletterModule

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

        var campaignBreadcrumb: [AdminBreadcrumb.Link] {
            breadcrumb + [.init(label: "Campaign", link: list.path)]
        }

        var subscribers: WebRoute {
            list.appending(parameter: "newsletterId")
                .appending(pathComponent: "subscribers")
        }

        var subscriberAdd: WebRoute {
            subscribers.appending(pathComponent: "add")
        }

        var subscriberImport: WebRoute {
            subscribers.appending(pathComponent: "import")
        }

        var subscriberDetails: WebRoute {
            subscribers.appending(parameter: "subscriberId")
        }

        var subscriberEdit: WebRoute {
            subscriberDetails.appending(pathComponent: "edit")
        }

        var subscriberRemove: WebRoute {
            subscribers.appending(pathComponent: "remove")
        }

        func subscribersPath(newsletterId: String) -> String {
            subscribers.path(parameter: "newsletterId", value: newsletterId)
        }

        func subscriberAddPath(newsletterId: String) -> String {
            subscriberAdd.path(parameter: "newsletterId", value: newsletterId)
        }

        func subscriberImportPath(newsletterId: String) -> String {
            subscriberImport.path(
                parameter: "newsletterId",
                value: newsletterId
            )
        }

        func subscriberDetailsPath(
            newsletterId: String,
            subscriberId: String
        ) -> String {
            resolvedPath(
                for: subscriberDetails,
                parameters: [
                    "newsletterId": newsletterId,
                    "subscriberId": subscriberId,
                ]
            )
        }

        func subscriberEditPath(
            newsletterId: String,
            subscriberId: String
        ) -> String {
            resolvedPath(
                for: subscriberEdit,
                parameters: [
                    "newsletterId": newsletterId,
                    "subscriberId": subscriberId,
                ]
            )
        }

        func subscriberRemovePath(newsletterId: String) -> String {
            subscriberRemove.path(
                parameter: "newsletterId",
                value: newsletterId
            )
        }

        var issues: WebRoute {
            list.appending(parameter: "newsletterId")
                .appending(pathComponent: "issues")
        }

        var issueAdd: WebRoute {
            issues.appending(pathComponent: "add")
        }

        var issueAddSend: WebRoute {
            issueAdd.appending(pathComponent: "send")
        }

        var issueDetails: WebRoute {
            issues.appending(parameter: "issueId")
        }

        var issueEdit: WebRoute {
            issueDetails.appending(pathComponent: "edit")
        }

        var issueSend: WebRoute {
            issueDetails.appending(pathComponent: "send")
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

        func issueAddSendPath(newsletterId: String) -> String {
            issueAddSend.path(parameter: "newsletterId", value: newsletterId)
        }

        func issueEditPath(newsletterId: String, issueId: String) -> String {
            resolvedPath(
                for: issueEdit,
                parameters: [
                    "newsletterId": newsletterId,
                    "issueId": issueId,
                ]
            )
        }

        func issueSendPath(newsletterId: String, issueId: String) -> String {
            resolvedPath(
                for: issueSend,
                parameters: [
                    "newsletterId": newsletterId,
                    "issueId": issueId,
                ]
            )
        }

        func issueDetailsPath(newsletterId: String, issueId: String) -> String {
            resolvedPath(
                for: issueDetails,
                parameters: [
                    "newsletterId": newsletterId,
                    "issueId": issueId,
                ]
            )
        }

        func issueRemovePath(newsletterId: String, issueId: String) -> String {
            resolvedPath(
                for: issueRemove,
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
            resolvedPath(
                for: issueDetailTestEmail,
                parameters: [
                    "newsletterId": newsletterId,
                    "issueId": issueId,
                ]
            )
        }

        private func resolvedPath(
            for route: WebRoute,
            parameters: [String: String]
        ) -> String {
            do {
                return try route.path(parameters: parameters)
            }
            catch {
                preconditionFailure("A Campaign route is missing a parameter.")
            }
        }
    }
}
