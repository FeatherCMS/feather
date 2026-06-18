import HTML
import SGML
import WebStandards

import class Foundation.ByteCountFormatter

struct MediaFolderEditView: Component {
    struct State {
        let model: AdminEditMediaFolderModel
        let isEdited: Bool
        let canAccess: Bool
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1("Forbidden")
                P("Your account cannot edit media folders.")
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb)
                H1("Edit media folder")
                if state.isEdited {
                    P("Media folder updated successfully.")
                }
                if let error = state.model.error {
                    P(error).class("error")
                }

                AdminDetailsField(label: "Path", value: state.model.path)
                AdminDetailsField(
                    label: "Items",
                    value: state.model.assetCount == 1
                        ? "1 item"
                        : "\(state.model.assetCount) items"
                )
                AdminDetailsField(
                    label: "Total size",
                    value: ByteCountFormatter.string(
                        fromByteCount: state.model.totalSizeBytes,
                        countStyle: .file
                    )
                )

                Form {
                    Section {
                        Label {
                            AdminFieldLabel(
                                label: "Folder name",
                                required: true
                            )
                            Input().type(.text).class("text-input").name("name")
                                .value(state.model.name).id("name")
                        }
                    }

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
