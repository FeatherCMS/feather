import Foundation

struct AdminStatusActionRedirect {
    static func location(
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
