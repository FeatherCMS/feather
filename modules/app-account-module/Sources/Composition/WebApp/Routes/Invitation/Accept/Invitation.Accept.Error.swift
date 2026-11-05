import AccountModule
import FeatherWebShared

extension Invitation.Accept {
    enum Error {
        case invitationUnavailable
        case requestFailed

        init(repositoryError: OpenAPIRepositoryError) {
            switch repositoryError {
            case .notFound:
                self = .invitationUnavailable
            case .failure(let failure) where failure.statusCode == 404:
                self = .invitationUnavailable
            default:
                self = .requestFailed
            }
        }

        var message: String {
            switch self {
            case .invitationUnavailable:
                return "This invitation link is invalid, expired, or has already been used. Ask the person who invited you for a new link."
            case .requestFailed:
                return "We could not process this invitation. Please try again."
            }
        }
    }
}
