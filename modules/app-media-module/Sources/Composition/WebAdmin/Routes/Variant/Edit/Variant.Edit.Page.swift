import FeatherWebAdmin
import HTML
import Hummingbird
import MediaModule
import SGML
import WebBuilders
import WebComponents

extension Variant.Edit {
    struct Page: Component {
        struct State {
            let id: String
            let detail: Model
            let form: Variant.Form
            let routes: Variant.Router.Routes
            let moreActions: [AdminButton.State]
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminBreadcrumb(links: state.routes.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit \(state.detail.name)",
                            description: "Update the media variant details.",
                            moreActions: state.moreActions
                        )
                    )
                )
                context.build(
                    Variant.Tabs(
                        id: state.id,
                        active: .details,
                        routes: state.routes
                    )
                )
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Variant details",
                            description: "Edit the media variant configuration."
                        )
                    ) {
                        context.build(state.form)
                    }
                )
            }
            .class("cms-section")
        }
    }
}
