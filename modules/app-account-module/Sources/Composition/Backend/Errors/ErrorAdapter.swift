import AccountApplication
import AccountDomain
import AccountModule
import NIOHTTP1

public enum ErrorAdapter {

    public static func adapt(_ error: any Error) -> (any Error)? {
        if let error = error as? Invitation.Resend.UseCase.Error {
            return AccountErrorAdapter(
                error: error,
                status: .notFound,
                message: error.message,
                logMessage: error.message,
                reason: "invitation_not_found"
            )
        }
        if let error = error as? Invitation.CompleteRegistration.UseCase.Error {
            return AccountErrorAdapter(
                error: error,
                status: .notFound,
                message: error.message,
                logMessage: error.message,
                reason: "invitation_not_found"
            )
        }
        if let error = error as? Invitation.Validate.UseCase.Error {
            return AccountErrorAdapter(
                error: error,
                status: .notFound,
                message: error.message,
                logMessage: error.message,
                reason: "invitation_not_found"
            )
        }
        if let error = error as? Settings.Model.Error {
            let message: String
            switch error {
            case .invalidUserId:
                message = "User ID is invalid."
            case .invalidLanguage:
                message = "Language is invalid."
            case .invalidTimezone:
                message = "Timezone is invalid."
            case .invalidPageSize:
                message = "Page size is invalid."
            }
            return AccountErrorAdapter(
                error: error,
                status: .badRequest,
                message: message,
                logMessage: String(describing: error),
                reason: String(describing: error)
            )
        }
        return nil
    }
}
