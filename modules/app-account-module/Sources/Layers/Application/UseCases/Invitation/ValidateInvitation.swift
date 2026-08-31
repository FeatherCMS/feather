import AccountDomain
import FeatherApplication
import FeatherContracts
import Foundation

public struct ValidateInvitation: UseCase {

    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let query: any QueryExecutor<ReadInvitation>

    public init(
        query: any QueryExecutor<ReadInvitation>
    ) {
        self.query = query
    }

    public struct Input: DTO {
        public let token: String

        public init(token: String) {
            self.token = token
        }
    }

    public func execute(
        input: Input
    ) async throws -> InvitationDetail {
        try await query.run { scope in
            let invitation = try await scope.invitation.getBy(token: input.token)
            guard invitation.expiresAt > .init() else {
                throw Error(message: "Invitation not found")
            }
            return invitation
        }
    }
}
