import Foundation

public struct AdminStatusActionRedirect {
    public static func location(
        defaultPath: String,
        returnTo: String?,
        title: String,
        message: String
    ) -> String {
        AdminToastRedirect.location(
            defaultPath: defaultPath,
            returnTo: returnTo,
            title: title,
            message: message
        )
    }
}
