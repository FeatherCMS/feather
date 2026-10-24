import BlogDomain
public import BlogModule
public import FeatherApplication
public import FeatherModuleKit
import WebDomain

//
//  RemoveTag.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Tag.Remove {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Tag.Remove.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Tag.Remove.Scope>
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

            let ids = try await transaction.run { scope in
                var deletedIds: [String] = []
                for id in input.ids {
                    try await scope.post.removeTag(id: id)
                }
                _ = try await scope.metadata.delete(
                    referenceType: "blog.tag",
                    referenceIds: input.ids
                )
                deletedIds = try await scope.tag.delete(ids: input.ids)
                return deletedIds
            }
            return .init(ids: ids)
        }
    }
}
