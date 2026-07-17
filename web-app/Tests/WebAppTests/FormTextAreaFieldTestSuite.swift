import HTML
import SGML
import Testing

@testable import WebApp

@Suite
struct FormTextAreaFieldTestSuite {

    @Test
    func rendersRequiredTextArea() async throws {
        let result = render(
            FormTextAreaField(
                name: "notes",
                label: "Notes",
                value: "Hello",
                rows: 6,
                isRequired: true
            )
        )

        let expectation = #"""
            <section><label for="notes"><span class="field-label">Notes</span><textarea id="notes" name="notes" rows="6" aria-invalid="false" required>Hello</textarea></label></section>
            """#

        #expect(result == expectation)
    }

    @Test
    func rendersOptionalTextArea() async throws {
        let result = render(
            FormTextAreaField(
                name: "notes",
                label: "Notes",
                placeholder: "Add notes"
            )
        )

        let expectation = #"""
            <section><label for="notes"><span class="field-label">Notes<span class="field-label__optional"> (Optional)</span></span><textarea id="notes" name="notes" rows="8" placeholder="Add notes" aria-invalid="false"></textarea></label></section>
            """#

        #expect(result == expectation)
    }

    @Test
    func rendersHelpErrorAndStates() async throws {
        let result = render(
            FormTextAreaField(
                name: "content",
                label: "Content",
                value: "Draft",
                error: "Content is invalid.",
                help: "Write the page content.",
                isDisabled: true,
                isReadOnly: true,
                textareaClass: "content-textarea"
            )
        )

        let expectation = #"""
            <section class="has-error"><label for="content"><span class="field-label">Content<span class="field-label__optional"> (Optional)</span></span><textarea id="content" name="content" rows="8" aria-describedby="content-help content-error" aria-invalid="true" aria-errormessage="content-error" disabled readonly class="content-textarea">Draft</textarea></label><span id="content-help" class="field-help">Write the page content.</span><span id="content-error" class="field-error">Content is invalid.</span></section>
            """#

        #expect(result == expectation)
    }

    private func render(
        _ field: FormTextAreaField
    ) -> String {
        let renderer = Renderer()
        let doc = Document(root: field)
        return renderer.render(document: doc)
    }
}
