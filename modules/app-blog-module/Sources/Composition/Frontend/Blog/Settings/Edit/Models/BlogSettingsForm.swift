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

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action) {
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            H2("List paths")
            context.render(field(state.postListPath))
            context.render(field(state.authorListPath))
            context.render(field(state.tagListPath))
            H2("Prefixes")
            context.render(field(state.postPathPrefix))
            context.render(field(state.authorPathPrefix))
            context.render(field(state.tagPathPrefix))
            if state.canEdit {
                context.render(
                    NewAdminSubmitButton("Save settings", style: .primary)
                )
            }
        }
        return context.render(form)
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
