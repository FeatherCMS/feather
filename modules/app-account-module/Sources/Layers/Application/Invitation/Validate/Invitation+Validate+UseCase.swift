public import AccountModule
public import FeatherApplication
public import FeatherModuleKit
import Foundation

extension Invitation.Validate {
    public struct UseCase: FeatherApplication.UseCase {

        public struct Error: UseCaseError {
            public let message: String

            public init(message: String) {
                self.message = message
            }
        }

        let query: any QueryExecutor<Invitation.Detail.Scope>

        public init(
            query: any QueryExecutor<Invitation.Detail.Scope>
        ) {
            self.query = query
        }

        public func execute(
            input: Invitation.Validate.Input
        ) async throws -> Invitation.Detail.Output {
            try await query.run { scope in
                let invitation = try await scope.query.getBy(
                    token: input.token
                )
                guard invitation.expiresAt > .init() else {
                    throw Error(message: "Invitation not found")
                }
                return invitation
            }
        }
    }
}
