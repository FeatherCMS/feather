import HTML
import SGML
import WebStandards

struct BlogSettingsForm: Component, FlowContent {

    struct FieldState: Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: Object {
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
            field(state.postListPath)
            field(state.authorListPath)
            field(state.tagListPath)

            H2("Prefixes")
            field(state.postPathPrefix)
            field(state.authorPathPrefix)
            field(state.tagPathPrefix)

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

    private func field(
        _ field: FieldState
    ) -> some BasicTag {
        Section {
            Label {
                AdminFieldLabel(label: field.label, required: false)

                Input()
                    .type(.text)
                    .class("text-input")
                    .id(field.key)
                    .name(field.key)
                    .value(field.value)
                    .if(!state.canEdit) {
                        $0.setAttribute(name: "disabled", value: "")
                    }
            }
            if let error = field.error {
                Span(error).class("field-error")
            }
        }
        .if(field.error != nil) { $0.class("has-error") }
    }
}
