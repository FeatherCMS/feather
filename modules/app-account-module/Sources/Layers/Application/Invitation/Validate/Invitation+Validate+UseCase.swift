public import AccountModule
public import FeatherApplication
public import FeatherModuleKit
import Foundation

extension Invitation.Validate {
    public struct UseCase: FeatherApplication.UseCase {

        let query: any QueryExecutor<Scope>

        public init(
            query: any QueryExecutor<Scope>
        ) {
            self.query = query
        }

        public func execute(
            input: Input
        ) async throws -> Output {
            try await query.run { scope in
                let invitation = try await scope.query.find(
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
