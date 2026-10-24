import BlogDomain
public import BlogModule
public import FeatherApplication
public import FeatherModuleKit
import WebDomain

//
//  RemovePost.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Post.Remove {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Post.Remove.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Post.Remove.Scope>
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
                _ = try await scope.metadata.delete(
                    referenceType: "blog.post",
                    referenceIds: input.ids
                )
                return try await scope.post.delete(ids: input.ids)
            }
            return .init(ids: ids)
        }
    }
}
