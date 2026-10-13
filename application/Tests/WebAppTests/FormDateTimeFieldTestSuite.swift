import FeatherAdmin
import HTML
import SGML
import Testing

@testable import WebApp

@Suite
struct FormDateTimeFieldTestSuite {

    @Test
    func rendersDateTimeMarkup() async throws {
        let result = render(
            FormDateTimeField(
                name: "publicationDate",
                label: "Publication date & time",
                value: "2026-07-22T14:30",
                isRequired: true
            )
        )

        #expect(result.contains("class=\"form-datetime-field\""))
        #expect(result.contains("id=\"publicationDate-display\""))
        #expect(
            result.contains(
                "id=\"publicationDate\" name=\"publicationDate\" value=\"2026-07-22T14:30\""
            )
        )
        #expect(result.contains("id=\"publicationDate-picker\""))
        #expect(result.contains("role=\"dialog\""))
        #expect(result.contains("class=\"form-datetime-field__calendar\""))
        #expect(result.contains("id=\"publicationDate-hour\""))
        #expect(result.contains("id=\"publicationDate-minute\""))
        #expect(result.contains("new Intl.DateTimeFormat"))
        #expect(result.contains("event.stopPropagation()"))
    }

    @Test
    func rendersOptionalLabel() async throws {
        let result = render(
            FormDateTimeField(
                name: "expirationDate",
                label: "Expiration date & time"
            )
        )

        #expect(result.contains("Expiration date & time"))
        #expect(result.contains("field-label__optional"))
    }

    @Test
    func rendersHelpErrorAndDisabledState() async throws {
        let result = render(
            FormDateTimeField(
                name: "publicationDate",
                label: "Publication date & time",
                error: "Date is invalid.",
                help: "Choose when the content becomes visible.",
                isDisabled: true,
                wrapperClass: "metadata-date-field"
            )
        )

        #expect(
            result.contains(
                "class=\"form-datetime-field has-error metadata-date-field\""
            )
        )
        #expect(
            result.contains(
                "aria-describedby=\"publicationDate-help publicationDate-error\""
            )
        )
        #expect(result.contains("aria-invalid=\"true\""))
        #expect(result.contains("aria-errormessage=\"publicationDate-error\""))
        #expect(result.contains("disabled"))
        #expect(result.contains("publicationDate-help"))
        #expect(result.contains("publicationDate-error"))
    }

    private func render(
        _ field: FormDateTimeField
    ) -> String {
        let renderer = Renderer()
        let doc = Document(root: field)
        return renderer.render(document: doc)
    }
}
