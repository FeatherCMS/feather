import Foundation
public import Hummingbird

public enum ContactAppRoutes {
    public static let contact = RouterPath("api/v1/contact")
    public static let submission =
        contact
        .appendingPath(RouterPath("{formKey}"))
        .appendingPath(RouterPath("submit"))

    public static func submissionAction(
        for formKey: String
    ) -> String {
        let allowedCharacters = CharacterSet(
            charactersIn:
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
        )
        let encodedKey =
            formKey.addingPercentEncoding(
                withAllowedCharacters: allowedCharacters
            ) ?? ""
        return
            contact
            .appendingPath(RouterPath(encodedKey))
            .appendingPath(RouterPath("submit"))
            .description + "/"
    }
}
