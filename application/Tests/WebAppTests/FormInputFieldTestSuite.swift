import FeatherAdmin
import HTML
import SGML
import Testing

@testable import WebApp

@Suite
struct FormInputFieldTestSuite {

    @Test
    func rendersRequiredInput() async throws {
        let result = render(
            FormInputField(
                name: "title",
                label: "Title",
                value: "Hello",
                isRequired: true
            )
        )

        let expectation = #"""
            <section><label for="title"><span class="field-label">Title</span><input type="text" id="title" name="title" value="Hello" aria-invalid="false" required></label></section>
            """#

        #expect(result == expectation)
    }

    @Test
    func rendersOptionalInputLabel() async throws {
        let result = render(
            FormInputField(
                name: "notes",
                label: "Notes"
            )
        )

        let expectation = #"""
            <section><label for="notes"><span class="field-label">Notes<span class="field-label__optional"> (Optional)</span></span><input type="text" id="notes" name="notes" aria-invalid="false"></label></section>
            """#

        #expect(result == expectation)
    }

    @Test
    func rendersInputPrefix() async throws {
        let result = render(
            FormInputField(
                name: "slug",
                label: "Slug",
                prefix: "/"
            )
        )

        let expectation = #"""
            <section><label for="slug"><span class="field-label">Slug<span class="field-label__optional"> (Optional)</span></span><div class="admin-metadata-fields__prefixed-input"><span class="admin-metadata-fields__prefix">/</span><input type="text" id="slug" name="slug" aria-invalid="false"></div></label></section>
            """#

        #expect(result == expectation)
    }

    @Test
    func rendersHelpAndErrorAccessibilityAttributes() async throws {
        let result = render(
            FormInputField(
                name: "email",
                label: "Email",
                value: "bad",
                error: "Email is invalid.",
                help: "Use your work email.",
                type: .email,
                placeholder: "name@example.com",
                autocomplete: "email",
                inputClass: "text-input"
            )
        )

        let expectation = #"""
            <section class="has-error"><label for="email"><span class="field-label">Email<span class="field-label__optional"> (Optional)</span></span><input type="email" id="email" name="email" value="bad" placeholder="name@example.com" autocomplete="email" aria-describedby="email-help email-error" aria-invalid="true" aria-errormessage="email-error" class="text-input"></label><span id="email-help" class="field-help">Use your work email.</span><span id="email-error" class="field-error">Email is invalid.</span></section>
            """#

        #expect(result == expectation)
    }

    @Test
    func rendersDisabledAndReadOnlyStates() async throws {
        let result = render(
            FormInputField(
                name: "slug",
                label: "Slug",
                isDisabled: true,
                isReadOnly: true,
                wrapperClass: "slug-field"
            )
        )

        let expectation = #"""
            <section class="slug-field"><label for="slug"><span class="field-label">Slug<span class="field-label__optional"> (Optional)</span></span><input type="text" id="slug" name="slug" aria-invalid="false" disabled readonly></label></section>
            """#

        #expect(result == expectation)
    }

    @Test
    func rendersUpdatedState() async throws {
        var field = FormInputField(
            state: .init(
                name: "username",
                label: "Username"
            )
        )
        field.state.value = "bird"
        field.state.isRequired = true

        let result = render(field)

        let expectation = #"""
            <section><label for="username"><span class="field-label">Username</span><input type="text" id="username" name="username" value="bird" aria-invalid="false" required></label></section>
            """#

        #expect(result == expectation)
    }

    private func render(
        _ input: FormInputField
    ) -> String {
        let renderer = Renderer()
        let doc = Document(root: input)
        return renderer.render(document: doc)
    }
}
