import BlogAdminAPI
import FeatherAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct BlogSettingsForm: Component {
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

        mutating func apply(errors: [String: String]) {
            postListPath.error = errors[postListPath.key]
            authorListPath.error = errors[authorListPath.key]
            tagListPath.error = errors[tagListPath.key]
            postPathPrefix.error = errors[postPathPrefix.key]
            authorPathPrefix.error = errors[authorPathPrefix.key]
            tagPathPrefix.error = errors[tagPathPrefix.key]
        }
    }

    var state: State
    var action: String = BlogAdminRoutes.blog.description + "/settings/"

    func html(context: inout BuilderContext) -> Form {
        let form = NewAdminForm(action: action) {
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            H2("List paths")
            context.build(field(state.postListPath))
            context.build(field(state.authorListPath))
            context.build(field(state.tagListPath))
            H2("Prefixes")
            context.build(field(state.postPathPrefix))
            context.build(field(state.authorPathPrefix))
            context.build(field(state.tagPathPrefix))
            if state.canEdit {
                context.build(
                    NewAdminSubmitButton("Save settings", style: .primary)
                )
            }
        }
        return context.build(form)
    }

    private func field(_ value: FieldState) -> NewAdminFormFieldInput {
        NewAdminFormFieldInput(
            state: .init(
                name: value.key,
                label: value.label,
                value: value.value,
                error: value.error,
                isDisabled: !state.canEdit
            )
        )
    }
}
