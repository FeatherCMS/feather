import BlogDomain
public import BlogModule
public import FeatherApplication
public import FeatherModuleKit

//
//  RemoveAuthorLink.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension AuthorLink.Remove {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<AuthorLink.Remove.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<AuthorLink.Remove.Scope>
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

            let ids: [String] = try await transaction.run { scope in
                var ids: [String] = []
                for id in input.ids {
                    guard let model = try await scope.authorLink.find(id: id),
                        model.authorId == input.authorId
                    else { continue }
                    ids.append(model.id)
                }
                guard !ids.isEmpty else { return [] }
                return try await scope.authorLink.delete(ids: ids)
            }
            return .init(ids: ids)
        }
    }
}
