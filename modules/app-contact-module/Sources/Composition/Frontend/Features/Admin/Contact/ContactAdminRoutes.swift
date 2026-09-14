import FeatherAdmin
import Hummingbird

enum ContactAdminRoutes {
    static let admin = RouterPath("admin")
    static let contact = admin.appendingPath(RouterPath("contact"))
    static let forms = contact.appendingPath(RouterPath("forms"))
    static let formAdd = forms.appendingPath(RouterPath("add"))
    static let formRemove = forms.appendingPath(RouterPath("remove"))
    static let fields = contact.appendingPath(RouterPath("fields"))
    static let fieldAdd = fields.appendingPath(RouterPath("add"))
    static let fieldRemove = fields.appendingPath(RouterPath("remove"))
    static let submissions = contact.appendingPath(RouterPath("submissions"))
    static let submissionRemove = submissions.appendingPath(
        RouterPath("remove")
    )

    static let breadcrumb: [NewAdminBreadcrumb.Link] = [
        .init(label: "Admin", link: "/admin/"),
        .init(label: "Contact", link: contact.description + "/")
    ]

    private static let formID = RouterPath(":formId")
    private static let fieldID = RouterPath(":fieldId")
    private static let mailID = RouterPath(":mailId")
    private static let submissionID = RouterPath(":submissionId")

    static let formDetailsRoute = formDetails(formID)
    static let formEditRoute = formEdit(formID)
    static let formFieldsRoute = formFields(formID)
    static let formFieldAddRoute = formFieldAdd(formID)
    static let formFieldRemoveRoute = formFieldRemove(
        formID: formID,
        fieldID: fieldID
    )
    static let formFieldRemoveSelectedRoute = formFieldRemove(formID)
    static let formEmailsRoute = formEmails(formID)
    static let formEmailAddRoute = formEmailAdd(formID)
    static let formEmailEditRoute = formEmailEdit(
        formID: formID,
        emailID: mailID
    )
    static let formEmailRemoveRoute = formEmailRemove(formID)
    static let formSubmissionsRoute = formSubmissions(formID)
    static let formSubmissionDetailsRoute = formSubmissionDetails(
        formID: formID,
        submissionID: submissionID
    )
    static let formSubmissionEditRoute = formSubmissionEdit(
        formID: formID,
        submissionID: submissionID
    )
    static let formSubmissionRemoveRoute = formSubmissionRemove(
        formID: formID,
        submissionID: submissionID
    )
    static let formSubmissionRemoveSelectedRoute = formSubmissionRemove(formID)
    static let fieldEditRoute = fields.appendingPath(fieldID)
        .appendingPath(RouterPath("edit"))
    static let fieldRemoveRoute = fields.appendingPath(fieldID)
        .appendingPath(RouterPath("remove"))

    static let formFieldEditRoute = formFields(formID)
        .appendingPath(fieldID)
        .appendingPath(RouterPath("edit"))

    static func formDetails(_ id: RouterPath) -> RouterPath {
        forms.appendingPath(id).appendingPath(RouterPath("details"))
    }

    static func formEdit(_ id: RouterPath) -> RouterPath {
        forms.appendingPath(id).appendingPath(RouterPath("edit"))
    }

    static func formFields(_ id: RouterPath) -> RouterPath {
        forms.appendingPath(id).appendingPath(RouterPath("fields"))
    }

    static func formFieldAdd(_ id: RouterPath) -> RouterPath {
        formFields(id).appendingPath(RouterPath("add"))
    }

    static func formFieldRemove(_ id: RouterPath) -> RouterPath {
        formFields(id).appendingPath(RouterPath("remove"))
    }

    static func formFieldRemove(
        formID: RouterPath,
        fieldID: RouterPath
    ) -> RouterPath {
        formFields(formID).appendingPath(fieldID)
            .appendingPath(RouterPath("remove"))
    }

    static func formEmails(_ id: RouterPath) -> RouterPath {
        forms.appendingPath(id).appendingPath(RouterPath("emails"))
    }

    static func formEmailAdd(_ id: RouterPath) -> RouterPath {
        formEmails(id).appendingPath(RouterPath("add"))
    }

    static func formEmailEdit(
        formID: RouterPath,
        emailID: RouterPath
    ) -> RouterPath {
        formEmails(formID).appendingPath(emailID)
            .appendingPath(RouterPath("edit"))
    }

    static func formEmailRemove(_ id: RouterPath) -> RouterPath {
        formEmails(id).appendingPath(RouterPath("remove"))
    }

    static func formSubmissions(_ id: RouterPath) -> RouterPath {
        forms.appendingPath(id).appendingPath(RouterPath("submissions"))
    }

    static func formSubmissionDetails(
        formID: RouterPath,
        submissionID: RouterPath
    ) -> RouterPath {
        formSubmissions(formID).appendingPath(submissionID)
    }

    static func formSubmissionEdit(
        formID: RouterPath,
        submissionID: RouterPath
    ) -> RouterPath {
        formSubmissionDetails(
            formID: formID,
            submissionID: submissionID
        ).appendingPath(RouterPath("edit"))
    }

    static func formSubmissionRemove(
        formID: RouterPath,
        submissionID: RouterPath
    ) -> RouterPath {
        formSubmissionDetails(
            formID: formID,
            submissionID: submissionID
        ).appendingPath(RouterPath("remove"))
    }

    static func formSubmissionRemove(_ id: RouterPath) -> RouterPath {
        formSubmissions(id).appendingPath(RouterPath("remove"))
    }
}
