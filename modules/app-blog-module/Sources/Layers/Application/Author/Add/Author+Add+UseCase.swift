import BlogDomain
public import BlogModule
public import FeatherApplication
public import FeatherModuleKit
import SystemApplication
import WebApplication

//
//  Author.Add.UseCase.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Author.Add {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Author.Add.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Author.Add.Scope>
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
                let prefix =
                    try await scope.variable.get(
                        "blog.author.path_prefix"
                    ) ?? "authors"
                return try await scope.author.insert(
                    Author.Model.create(
                        name: input.name,
                        excerpt: input.excerpt,
                        content: input.content,
                        profileImageAssetId: input.profileImageAssetId,
                        metadata: input.metadata.asMetadataBase(
                            template: "blog.author",
                            slug: input.metadata.slug.prefixedSlug(with: prefix)
                        )
                    )
                )
            }
            return .init(
                id: model.id,
                name: model.name,
                excerpt: model.excerpt,
                content: model.content,
                profileImageAssetId: model.profileImageAssetId,
                metadata: model.metadata.asDetail,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }
    }
}
