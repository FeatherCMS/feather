import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebStandards

struct BlogSettingsForm: Component, FlowContent {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var postListPath: FieldState
        var authorListPath: FieldState
        var tagListPath: FieldState
        var postPathPrefix: FieldState
        var authorPathPrefix: FieldState
        var tagPathPrefix: FieldState
        var canEdit: Bool
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            postListPath.error = errors[postListPath.key]
            authorListPath.error = errors[authorListPath.key]
            tagListPath.error = errors[tagListPath.key]
            postPathPrefix.error = errors[postPathPrefix.key]
            authorPathPrefix.error = errors[authorPathPrefix.key]
            tagPathPrefix.error = errors[tagPathPrefix.key]
        }
    }

    var state: State
    var action: String = "/admin/blog/settings/"
    var submitLabel: String = "Save settings"

    func content() -> some BasicTag {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            H2("List paths")
            FormInputField(
                name: state.postListPath.key,
                label: state.postListPath.label,
                value: state.postListPath.value,
                error: state.postListPath.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            )
            FormInputField(
                name: state.authorListPath.key,
                label: state.authorListPath.label,
                value: state.authorListPath.value,
                error: state.authorListPath.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            )
            FormInputField(
                name: state.tagListPath.key,
                label: state.tagListPath.label,
                value: state.tagListPath.value,
                error: state.tagListPath.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            )

            H2("Prefixes")
            FormInputField(
                name: state.postPathPrefix.key,
                label: state.postPathPrefix.label,
                value: state.postPathPrefix.value,
                error: state.postPathPrefix.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            )
            FormInputField(
                name: state.authorPathPrefix.key,
                label: state.authorPathPrefix.label,
                value: state.authorPathPrefix.value,
                error: state.authorPathPrefix.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            )
            FormInputField(
                name: state.tagPathPrefix.key,
                label: state.tagPathPrefix.label,
                value: state.tagPathPrefix.value,
                error: state.tagPathPrefix.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            )

            if state.canEdit {
                Section {
                    Div {
                        Button(submitLabel)
                            .type(.submit)
                    }
                    .class("button-row")
                }
            }
        }
        .encType(.urlencoded)
        .method(.post)
        .action(action)
        .class("cms-form")
    }

}
