import ContactModule
import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

extension ContactModule.Form {
    struct TabBar: WebComponents.Component {
        enum Tab { case details, fields, emails, submissions }

        let formId: String
        let routes: Router.Routes
        let active: Tab

        func html(context: inout BuilderContext) -> Div {
            context.build(
                AdminTabBar(links: [
                    .init(
                        label: "Details",
                        href: routes.formDetailsPagePath(formId),
                        isCurrent: active == .details
                    ),
                    .init(
                        label: "Fields",
                        href: routes.formFieldsPath(formId),
                        isCurrent: active == .fields
                    ),
                    .init(
                        label: "Emails",
                        href: routes.formEmailsPath(formId),
                        isCurrent: active == .emails
                    ),
                    .init(
                        label: "Submissions",
                        href: routes.formSubmissionsPath(formId),
                        isCurrent: active == .submissions
                    ),
                ])
            )
        }
    }
}
