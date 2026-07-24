import HTML
import SGML
import Testing

@testable import WebApp

@Suite
struct CheckboxFieldTestSuite {

    @Test
    func rendersCheckedCheckbox() async throws {
        let result = render(
            CheckboxField(
                name: "persistent",
                label: "Remember me",
                isChecked: true
            )
        )

        let expectation = #"""
            <section><label for="persistent" class="checkbox-field"><input type="checkbox" id="persistent" name="persistent" aria-invalid="false" checked><span class="checkbox-field__label">Remember me</span></label></section>
            """#

        #expect(result == expectation)
    }

    @Test
    func rendersLabelBeforeCheckbox() async throws {
        let result = render(
            CheckboxField(
                name: "persistent",
                label: "Remember me",
                labelPosition: .before
            )
        )

        let expectation = #"""
            <section><label for="persistent" class="checkbox-field"><span class="checkbox-field__label">Remember me</span><input type="checkbox" id="persistent" name="persistent" aria-invalid="false"></label></section>
            """#

        #expect(result == expectation)
    }

    @Test
    func rendersErrorAccessibilityAttributes() async throws {
        let result = render(
            CheckboxField(
                name: "noIndex",
                label: "No index",
                error: "No index value is invalid."
            )
        )

        let expectation = #"""
            <section class="has-error"><label for="noIndex" class="checkbox-field"><input type="checkbox" id="noIndex" name="noIndex" aria-describedby="noIndex-error" aria-invalid="true" aria-errormessage="noIndex-error"><span class="checkbox-field__label">No index</span></label><span id="noIndex-error" class="field-error error">No index value is invalid.</span></section>
            """#

        #expect(result == expectation)
    }

    @Test
    func rendersDisabledCheckbox() async throws {
        let result = render(
            CheckboxField(
                name: "persistent",
                label: "Remember me",
                isDisabled: true
            )
        )

        let expectation = #"""
            <section><label for="persistent" class="checkbox-field"><input type="checkbox" id="persistent" name="persistent" aria-invalid="false" disabled><span class="checkbox-field__label">Remember me</span></label></section>
            """#

        #expect(result == expectation)
    }

    private func render(
        _ field: CheckboxField
    ) -> String {
        let renderer = Renderer()
        let document = Document(root: field)
        return renderer.render(document: document)
    }
}
