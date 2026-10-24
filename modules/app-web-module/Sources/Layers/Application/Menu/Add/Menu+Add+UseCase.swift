public import FeatherApplication
public import FeatherModuleKit
import WebDomain
public import WebModule

extension Menu.Add {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let model = try await transaction.run { scope in
                if try await scope.menu.find(key: input.key) != nil {
                    throw Error(message: "Menu key already exists")
                }
                return try await scope.menu.insert(
                    Menu.Model.create(
                        key: input.key,
                        name: input.name,
                        notes: input.notes
                    )
                )
            }
            return Output(model: model)
        }
    }
}
