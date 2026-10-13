import FeatherAdmin
import HTML
import SGML
import Testing

@testable import WebApp

@Suite
struct FormSelectFieldTestSuite {

    @Test
    func rendersRequiredSelectWithSelectedOption() async throws {
        let result = render(
            FormSelectField(
                name: "status",
                label: "Status",
                options: [
                    .init(label: "Draft", value: "draft"),
                    .init(label: "Published", value: "published"),
                ],
                selectedValue: "published",
                isRequired: true
            )
        )

        let expectation = #"""
            <section><label for="status"><span class="field-label">Status</span><select id="status" name="status" aria-invalid="false" required><option value="draft">Draft</option><option value="published" selected>Published</option></select></label></section>
            """#

        #expect(result == expectation)
    }

    @Test
    func rendersOptionalSelect() async throws {
        let result = render(
            FormSelectField(
                name: "visibility",
                label: "Visibility",
                options: [
                    .init(label: "Public", value: "public"),
                    .init(label: "Private", value: "private"),
                ]
            )
        )

        let expectation = #"""
            <section><label for="visibility"><span class="field-label">Visibility<span class="field-label__optional"> (Optional)</span></span><select id="visibility" name="visibility" aria-invalid="false"><option value="public">Public</option><option value="private">Private</option></select></label></section>
            """#

        #expect(result == expectation)
    }

    @Test
    func rendersHelpErrorAndDisabledStates() async throws {
        let result = render(
            FormSelectField(
                name: "status",
                label: "Status",
                options: [
                    .init(label: "Draft", value: "draft"),
                    .init(
                        label: "Archived",
                        value: "archived",
                        isDisabled: true
                    ),
                ],
                error: "Status is invalid.",
                help: "Select the current status.",
                isDisabled: true,
                selectClass: "text-input"
            )
        )

        let expectation = #"""
            <section class="has-error"><label for="status"><span class="field-label">Status<span class="field-label__optional"> (Optional)</span></span><select id="status" name="status" aria-describedby="status-help status-error" aria-invalid="true" aria-errormessage="status-error" disabled class="text-input"><option value="draft">Draft</option><option value="archived" disabled>Archived</option></select></label><span id="status-help" class="field-help">Select the current status.</span><span id="status-error" class="field-error">Status is invalid.</span></section>
            """#

        #expect(result == expectation)
    }

    private func render(
        _ field: FormSelectField
    ) -> String {
        let renderer = Renderer()
        let doc = Document(root: field)
        return renderer.render(document: doc)
    }
}
