import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

extension Campaign.Add {
    struct View: Component {
        struct State {
            let key: String
            let name: String
            let fromEmail: String
            let error: String?
        }

        let state: State
        let routes: Campaign.Router.Routes

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminBreadcrumb(
                        links: routes.breadcrumb + [
                            .init(
                                label: "Campaigns",
                                link: routes.list.path
                            ),
                            .init(
                                label: "Add",
                                link: routes.add.path
                            ),
                        ]
                    )
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Add campaign",
                            description: "Create a newsletter campaign."
                        )
                    )
                )
                context.build(
                    Campaign.Form.Component(
                        state: .init(
                            key: state.key,
                            name: state.name,
                            fromEmail: state.fromEmail,
                            error: state.error,
                            success: nil
                        ),
                        action: routes.add.path,
                        submitLabel: "Add campaign"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
