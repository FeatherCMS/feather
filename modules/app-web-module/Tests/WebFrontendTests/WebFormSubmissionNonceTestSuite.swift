import Testing

@testable import WebFrontend

@Suite
struct WebFormSubmissionNonceTestSuite {

    @Test
    func generatedNonceIsURLSafeAndMatchesItself() {
        let nonce = WebFormSubmissionNonce.generate()

        #expect(WebFormSubmissionNonce.isValid(nonce))
        #expect(
            WebFormSubmissionNonce.matches(
                formValue: nonce,
                cookieValue: nonce
            )
        )
    }

    @Test
    func rejectsMissingMalformedAndMismatchedNonces() {
        let nonce = WebFormSubmissionNonce.generate()

        #expect(
            !WebFormSubmissionNonce.matches(
                formValue: nil,
                cookieValue: nonce
            )
        )
        #expect(
            !WebFormSubmissionNonce.matches(
                formValue: "invalid",
                cookieValue: nonce
            )
        )
        #expect(
            !WebFormSubmissionNonce.matches(
                formValue: nonce,
                cookieValue: WebFormSubmissionNonce.generate()
            )
        )
    }

    @Test
    func resolveReusesOnlyValidCookieValues() {
        let nonce = WebFormSubmissionNonce.generate()

        #expect(
            WebFormSubmissionNonce.resolve(
                existingCookieValue: nonce
            ) == nonce
        )

        let resolved = WebFormSubmissionNonce.resolve(
            existingCookieValue: "invalid"
        )
        #expect(WebFormSubmissionNonce.isValid(resolved))
        #expect(resolved != "invalid")
    }

    @Test
    func cookieIsHostOnlyHttpOnlyAndLastsForAFormSession() {
        let nonce = WebFormSubmissionNonce.generate()
        let cookie = WebFormSubmissionNonce.cookie(
            value: nonce,
            secure: true
        )

        #expect(cookie.name == WebFormSubmissionNonce.cookieName)
        #expect(cookie.value == nonce)
        #expect(cookie.domain == nil)
        #expect(cookie.path == "/")
        #expect(cookie.httpOnly)
        #expect(cookie.secure)
        #expect(cookie.sameSite == .lax)
        #expect(cookie.maxAge == 24 * 60 * 60)
    }
}
