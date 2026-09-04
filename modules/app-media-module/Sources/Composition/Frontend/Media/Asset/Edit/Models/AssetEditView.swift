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

struct AssetEditView: Leaf {
    struct State {
        let model: AdminEditMediaAssetModel
        let isEdited: Bool
        let canAccess: Bool
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1("Forbidden")
                P("Your account cannot edit media assets.")
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb).renderHTML()
                H1("Edit media asset")
                if state.isEdited {
                    P("Media asset updated successfully.")
                }
                if let error = state.model.error {
                    P(error).class("error")
                }

                AdminDetailsField(
                    label: "Storage key",
                    value: state.model.storageKey
                ).renderHTML()
                AdminDetailsField(label: "Type", value: state.model.type).renderHTML()
                AdminDetailsField(label: "Status", value: state.model.status).renderHTML()
                AdminDetailsField(
                    label: "Size bytes",
                    value: "\(state.model.sizeBytes)"
                ).renderHTML()

                Form {
                    FormInputField(
                        name: "title",
                        label: "Title",
                        value: state.model.title,
                        inputClass: "text-input"
                    ).renderHTML()

                    FormInputField(
                        name: "altText",
                        label: "Alt text",
                        value: state.model.altText,
                        inputClass: "text-input"
                    ).renderHTML()

                    Section {
                        Div { Button("Save").type(.submit) }.class("button-row")
                    }
                }
                .method(.post)
                .action("/admin/media/assets/\(state.model.id)/edit/")
                .class("cms-form")
            }
        }
        .class("cms-section")
    }
}
