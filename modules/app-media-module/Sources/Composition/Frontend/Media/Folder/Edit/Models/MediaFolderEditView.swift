import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

import class Foundation.ByteCountFormatter

struct MediaFolderEditView: Component {
    struct State {
        let model: AdminEditMediaFolderModel
        let isEdited: Bool
        let canAccess: Bool
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            if !state.canAccess {
                H1("Forbidden")
                P("Your account cannot edit media folders.")
            }
            else {
                context.render(AdminBreadcrumb(state: state.breadcrumb))
                H1("Edit media folder")
                if state.isEdited {
                    P("Media folder updated successfully.")
                }
                if let error = state.model.error {
                    P(error).class("error")
                }

                context.render(
                    AdminDetailsField(label: "Path", value: state.model.path)
                )
                context.render(
                    AdminDetailsField(
                        label: "Items",
                        value: state.model.assetCount == 1
                            ? "1 item"
                            : "\(state.model.assetCount) items"
                    )
                )
                context.render(
                    AdminDetailsField(
                        label: "Total size",
                        value: ByteCountFormatter.string(
                            fromByteCount: state.model.totalSizeBytes,
                            countStyle: .file
                        )
                    )
                )

                Form {
                    context.render(
                        FormInputField(
                            name: "name",
                            label: "Folder name",
                            value: state.model.name,
                            isRequired: true,
                            inputClass: "text-input"
                        )
                    )

                    Section {
                        Div { Button("Save").type(.submit) }.class("button-row")
                    }
                }
                .method(.post)
                .action("/admin/media/folders/\(state.model.id)/edit/")
                .class("cms-form")
            }
        }
        .class("cms-section")
    }
}
