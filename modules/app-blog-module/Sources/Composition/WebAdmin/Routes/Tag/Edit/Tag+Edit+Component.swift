import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents

import protocol SGML.BasicTag

extension Tag.Edit {
    struct Component: WebComponents.Component {
        struct State {
            let id: String
            let form: Tag.Form.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Tag.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit tag",
                            description: "Update this blog tag."
                        )
                    )
                )
                context.build(
                    Tag.Form(
                        state: state.form,
                        metadataHref: state.routes
                            .tagEditMetadata(
                                state.id,
                                state.id
                            ),
                        action: state.routes.tagEdit(state.id),
                        submitLabel: "Edit tag",
                        removeHref: state.routes
                            .tagRemove(state.id),
                        removeLabel: "Remove tag"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
