import Foundation
public import Hummingbird

/// Provides a double-submit cookie nonce for public browser form submissions.
public enum WebFormSubmissionNonce {
    public static let cookieName = "web_form_nonce"

    public static func generate() -> String {
        var generator = SystemRandomNumberGenerator()
        let bytes = (0..<32)
            .map { _ in
                UInt8.random(in: .min ... .max, using: &generator)
            }
        return Data(bytes).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    public static func resolve(
        existingCookieValue: String?
    ) -> String {
        guard isValid(existingCookieValue), let existingCookieValue else {
            return generate()
        }
        return existingCookieValue
    }

    public static func isValid(
        _ value: String?
    ) -> Bool {
        guard let value, value.utf8.count == 43 else {
            return false
        }
        return value.utf8.allSatisfy { byte in
            (byte >= 48 && byte <= 57)
                || (byte >= 65 && byte <= 90)
                || (byte >= 97 && byte <= 122)
                || byte == 45
                || byte == 95
        }
    }

    public static func matches(
        formValue: String?,
        cookieValue: String?
    ) -> Bool {
        guard
            let formValue,
            let cookieValue,
            isValid(formValue),
            isValid(cookieValue)
        else {
            return false
        }
        let difference = zip(formValue.utf8, cookieValue.utf8)
            .reduce(UInt8(0)) {
                $0 | ($1.0 ^ $1.1)
            }
        return difference == 0
    }

    public static func cookie(
        value: String,
        secure: Bool
    ) -> Cookie {
        Cookie(
            name: cookieName,
            value: value,
            maxAge: 24 * 60 * 60,
            path: "/",
            secure: secure,
            httpOnly: true,
            sameSite: .lax
        )
    }
}
