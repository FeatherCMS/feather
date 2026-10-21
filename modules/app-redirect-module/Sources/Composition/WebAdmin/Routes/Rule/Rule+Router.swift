import FeatherWebAdmin
import RedirectModule

extension RedirectModule.Rule {
    public enum Router {
        public struct Routes {
            public let list: WebRoute
            public let add: WebRoute
            public let remove: WebRoute
            public let removeDetails: WebRoute
            public let details: WebRoute
            public let edit: WebRoute
            public let breadcrumb: [AdminBreadcrumb.Link]
            public let redirectBreadcrumb: [AdminBreadcrumb.Link]

            public init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                let root = root.appending(pathComponent: "rules")
                self.list = root
                self.add = root.appending(pathComponent: "add")
                self.remove = root.appending(pathComponent: "remove")
                self.details = root.appending(parameter: "redirectRuleId")
                self.edit = self.details.appending(pathComponent: "edit")
                self.removeDetails = self.details.appending(
                    pathComponent: "remove"
                )
                self.breadcrumb = breadcrumb + [
                    .init(label: "Rules", link: root.path)
                ]
                self.redirectBreadcrumb = breadcrumb
            }

            public func detailsPath(_ id: String) -> String {
                details.path(parameter: "redirectRuleId", value: id)
            }

            public func editPath(_ id: String) -> String {
                edit.path(parameter: "redirectRuleId", value: id)
            }

            public func removePath(_ id: String) -> String {
                removeDetails.path(parameter: "redirectRuleId", value: id)
            }
        }
    }
}
