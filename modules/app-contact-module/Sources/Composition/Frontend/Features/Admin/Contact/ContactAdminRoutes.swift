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
        .init(label: "Contact", link: contact.description + "/"),
    ]

    static let fieldsBreadcrumb =
        breadcrumb + [
            .init(label: "Fields", link: fields.description + "/")
        ]
    static let formsBreadcrumb =
        breadcrumb + [
            .init(label: "Forms", link: forms.description + "/")
        ]
    static let submissionsBreadcrumb =
        breadcrumb + [
            .init(label: "Submissions", link: submissions.description + "/")
        ]

    static func formEmailsBreadcrumb(_ id: RouterPath)
        -> [NewAdminBreadcrumb.Link]
    {
        formsBreadcrumb + [
            .init(label: "Emails", link: formEmails(id).description + "/")
        ]
    }

    static func formSubmissionsBreadcrumb(_ id: RouterPath)
        -> [NewAdminBreadcrumb.Link]
    {
        formsBreadcrumb + [
            .init(
                label: "Submissions",
                link: formSubmissions(id).description + "/"
            )
        ]
    }

    private static let formKey = RouterPath(":formKey")
    private static let fieldID = RouterPath(":fieldId")
    private static let mailID = RouterPath(":mailId")
    private static let submissionID = RouterPath(":submissionId")

    static let formDetailsRoute = formDetails(formKey)
    static let formEditRoute = formEdit(formKey)
    static let formEmailsRoute = formEmails(formKey)
    static let formEmailAddRoute = formEmailAdd(formKey)
    static let formEmailEditRoute = formEmailEdit(
        formID: formKey,
        emailID: mailID
    )
    static let formEmailRemoveRoute = formEmailRemove(formKey)
    static let formSubmissionsRoute = formSubmissions(formKey)
    static let formSubmissionDetailsRoute = formSubmissionDetails(
        formID: formKey,
        submissionID: submissionID
    )
    static let formSubmissionEditRoute = formSubmissionEdit(
        formID: formKey,
        submissionID: submissionID
    )
    static let formSubmissionRemoveRoute = formSubmissionRemove(
        formID: formKey,
        submissionID: submissionID
    )
    static let formSubmissionRemoveSelectedRoute = formSubmissionRemove(formKey)
    static let fieldEditRoute = fields.appendingPath(fieldID)
        .appendingPath(RouterPath("edit"))
    static let fieldRemoveRoute = fields.appendingPath(fieldID)
        .appendingPath(RouterPath("remove"))

    static func formDetails(_ id: RouterPath) -> RouterPath {
        forms.appendingPath(id).appendingPath(RouterPath("details"))
    }

    static func formEdit(_ id: RouterPath) -> RouterPath {
        forms.appendingPath(id).appendingPath(RouterPath("edit"))
    }

    static func fieldRemove(_ id: RouterPath) -> RouterPath {
        fields.appendingPath(id).appendingPath(RouterPath("remove"))
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
        )
        .appendingPath(RouterPath("edit"))
    }

    static func formSubmissionRemove(
        formID: RouterPath,
        submissionID: RouterPath
    ) -> RouterPath {
        formSubmissionDetails(
            formID: formID,
            submissionID: submissionID
        )
        .appendingPath(RouterPath("remove"))
    }

    static func formSubmissionRemove(_ id: RouterPath) -> RouterPath {
        formSubmissions(id).appendingPath(RouterPath("remove"))
    }
}
