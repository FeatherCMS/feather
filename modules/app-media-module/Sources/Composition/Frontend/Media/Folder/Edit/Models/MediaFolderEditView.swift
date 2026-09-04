import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

import class Foundation.ByteCountFormatter

struct MediaFolderEditView: Leaf {
    struct State {
        let model: AdminEditMediaFolderModel
        let isEdited: Bool
        let canAccess: Bool
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1("Forbidden")
                P("Your account cannot edit media folders.")
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb).renderHTML()
                H1("Edit media folder")
                if state.isEdited {
                    P("Media folder updated successfully.")
                }
                if let error = state.model.error {
                    P(error).class("error")
                }

                AdminDetailsField(label: "Path", value: state.model.path).renderHTML()
                AdminDetailsField(
                    label: "Items",
                    value: state.model.assetCount == 1
                        ? "1 item"
                        : "\(state.model.assetCount) items"
                ).renderHTML()
                AdminDetailsField(
                    label: "Total size",
                    value: ByteCountFormatter.string(
                        fromByteCount: state.model.totalSizeBytes,
                        countStyle: .file
                    )
                ).renderHTML()

                Form {
                    FormInputField(
                        name: "name",
                        label: "Folder name",
                        value: state.model.name,
                        isRequired: true,
                        inputClass: "text-input"
                    ).renderHTML()

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
