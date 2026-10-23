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

            public var formDetailsPage: WebRoute {
                formDetails.appending(pathComponent: "details")
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

            public func formDetailsPagePath(_ key: String) -> String {
                formDetailsPage.path(parameter: "formKey", value: key)
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

            public var fieldAdd: WebRoute {
                fields.appending(pathComponent: "add")
            }

            public var fieldEdit: WebRoute {
                fields.appending(parameter: "fieldId")
                    .appending(pathComponent: "edit")
            }

            public func fieldEditPath(_ id: String) -> String {
                fieldEdit.path(parameter: "fieldId", value: id)
            }

            public var fieldRemove: WebRoute {
                fields.appending(parameter: "fieldId")
                    .appending(pathComponent: "remove")
            }

            public func fieldRemovePath(_ id: String) -> String {
                fieldRemove.path(parameter: "fieldId", value: id)
            }

            public var fieldsRemove: WebRoute {
                fields.appending(pathComponent: "remove")
            }

            public var formFields: WebRoute {
                formDetails.appending(pathComponent: "fields")
            }

            public func formFieldsPath(_ key: String) -> String {
                formFields.path(parameter: "formKey", value: key)
            }

            public var formFieldsData: WebRoute {
                forms.appending(parameter: "formKey")
                    .appending(pathComponent: "fields-data")
            }

            func fieldAddBreadcrumb(_ formKey: String?)
                -> [AdminBreadcrumb.Link]
            {
                if let formKey {
                    return formsBreadcrumb + [
                        .init(label: formKey, link: formFieldsPath(formKey)),
                        .init(label: "Add field", link: fieldAdd.path),
                    ]
                }
                return fieldsBreadcrumb + [
                    .init(label: "Add field", link: fieldAdd.path)
                ]
            }

            var fieldsBreadcrumb: [AdminBreadcrumb.Link] {
                breadcrumb + [
                    .init(label: "Fields", link: fields.path)
                ]
            }

            public var submissions: WebRoute {
                root.appending(pathComponent: "submissions")
            }

            public var submissionsRemove: WebRoute {
                submissions.appending(pathComponent: "remove")
            }

            public var formSubmissions: WebRoute {
                formDetails.appending(pathComponent: "submissions")
            }

            public var formSubmissionDetail: WebRoute {
                formSubmissions.appending(parameter: "submissionId")
            }

            public var formSubmissionEdit: WebRoute {
                formSubmissionDetail.appending(pathComponent: "edit")
            }

            public var formSubmissionRemoveSelected: WebRoute {
                formSubmissions.appending(pathComponent: "remove")
            }

            public func formSubmissionDetailPath(
                formKey: String,
                submissionId: String
            ) -> String {
                try! formSubmissionDetail.path(
                    parameters: [
                        "formKey": formKey,
                        "submissionId": submissionId,
                    ]
                )
            }

            public func formSubmissionEditPath(
                formKey: String,
                submissionId: String
            ) -> String {
                try! formSubmissionEdit.path(
                    parameters: [
                        "formKey": formKey,
                        "submissionId": submissionId,
                    ]
                )
            }

            public func formSubmissionRemoveSelectedPath(
                _ formKey: String
            ) -> String {
                formSubmissionRemoveSelected.path(
                    parameter: "formKey",
                    value: formKey
                )
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

            func formDetailsBreadcrumb(_ key: String)
                -> [AdminBreadcrumb.Link]
            {
                formsBreadcrumb + [
                    .init(label: key, link: formDetailsPagePath(key))
                ]
            }

            func formEmailsBreadcrumb(_ key: String)
                -> [AdminBreadcrumb.Link]
            {
                formsBreadcrumb + [
                    .init(label: "Emails", link: formEmailsPath(key))
                ]
            }

            func formSubmissionsBreadcrumb(_ key: String)
                -> [AdminBreadcrumb.Link]
            {
                formsBreadcrumb + [
                    .init(
                        label: "Submissions",
                        link: formSubmissions.path(
                            parameter: "formKey",
                            value: key
                        )
                    )
                ]
            }
        }
    }
}
