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

            public var forms: WebRoute {
                root.appending(pathComponent: "forms")
            }

            public var formAdd: WebRoute {
                forms.appending(pathComponent: "add")
            }

            public var formRemove: WebRoute {
                forms.appending(pathComponent: "remove")
            }

            public var formDetails: WebRoute {
                forms.appending(parameter: "formKey")
            }

            public var formEdit: WebRoute {
                formDetails.appending(pathComponent: "edit")
            }

            public var formEmails: WebRoute {
                formDetails.appending(pathComponent: "emails")
            }

            public var formEmailAdd: WebRoute {
                formEmails.appending(pathComponent: "add")
            }

            public var formEmailEdit: WebRoute {
                formEmails.appending(parameter: "mailId")
                    .appending(pathComponent: "edit")
            }

            public var formEmailRemove: WebRoute {
                formEmails.appending(pathComponent: "remove")
            }

            public func formDetailsPath(_ key: String) -> String {
                formDetails.path(parameter: "formKey", value: key)
            }

            public func formEditPath(_ key: String) -> String {
                formEdit.path(parameter: "formKey", value: key)
            }

            public func formEmailsPath(_ key: String) -> String {
                formEmails.path(parameter: "formKey", value: key)
            }

            public func formEmailAddPath(_ key: String) -> String {
                formEmailAdd.path(parameter: "formKey", value: key)
            }

            public func formEmailEditPath(
                formKey: String,
                mailId: String
            ) -> String {
                try! formEmailEdit.path(
                    parameters: ["formKey": formKey, "mailId": mailId]
                )
            }

            public func formEmailRemovePath(_ key: String) -> String {
                formEmailRemove.path(parameter: "formKey", value: key)
            }

            public var fields: WebRoute {
                root.appending(pathComponent: "fields")
            }

            public var submissions: WebRoute {
                root.appending(pathComponent: "submissions")
            }

            var breadcrumb: [AdminBreadcrumb.Link] {
                [
                    .init(label: "Admin", link: admin.path),
                    .init(label: "Contact", link: root.path),
                ]
            }

            var formsBreadcrumb: [AdminBreadcrumb.Link] {
                breadcrumb + [
                    .init(label: "Forms", link: forms.path)
                ]
            }

            func formEmailsBreadcrumb(_ key: String)
                -> [AdminBreadcrumb.Link]
            {
                formsBreadcrumb + [
                    .init(label: "Emails", link: formEmailsPath(key))
                ]
            }
        }
    }
}
