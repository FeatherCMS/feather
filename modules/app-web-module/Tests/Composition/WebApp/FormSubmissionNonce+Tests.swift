import Hummingbird
import Testing

@testable import WebModuleWebApp

@Suite
struct FormSubmissionNonceTests {

    @Test
    func generatedNonceIsURLSafeAndMatchesItself() {
        let nonce = FormSubmissionNonce.generate()

        #expect(FormSubmissionNonce.isValid(nonce))
        #expect(
            FormSubmissionNonce.matches(
                formValue: nonce,
                cookieValue: nonce
            )
        )
    }

    @Test
    func rejectsMissingMalformedAndMismatchedNonces() {
        let nonce = FormSubmissionNonce.generate()

        #expect(
            !FormSubmissionNonce.matches(
                formValue: nil,
                cookieValue: nonce
            )
        )
        #expect(
            !FormSubmissionNonce.matches(
                formValue: "invalid",
                cookieValue: nonce
            )
        )
        #expect(
            !FormSubmissionNonce.matches(
                formValue: nonce,
                cookieValue: FormSubmissionNonce.generate()
            )
        )
    }

    @Test
    func resolveReusesOnlyValidCookieValues() {
        let nonce = FormSubmissionNonce.generate()

        #expect(
            FormSubmissionNonce.resolve(
                existingCookieValue: nonce
            ) == nonce
        )

        let resolved = FormSubmissionNonce.resolve(
            existingCookieValue: "invalid"
        )
        #expect(FormSubmissionNonce.isValid(resolved))
        #expect(resolved != "invalid")
    }

    @Test
    func cookieIsHostOnlyHttpOnlyAndLastsForAFormSession() {
        let nonce = FormSubmissionNonce.generate()
        let cookie = FormSubmissionNonce.cookie(
            value: nonce,
            secure: true
        )

        #expect(cookie.name == FormSubmissionNonce.cookieName)
        #expect(cookie.value == nonce)
        #expect(cookie.domain == nil)
        #expect(cookie.path == "/")
        #expect(cookie.httpOnly)
        #expect(cookie.secure)
        #expect(cookie.sameSite == .lax)
        #expect(cookie.maxAge == 24 * 60 * 60)
    }
}
