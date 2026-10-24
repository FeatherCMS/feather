import BlogDomain
public import BlogModule
public import FeatherApplication
public import FeatherModuleKit
import SystemApplication
import WebApplication

//
//  AddTag.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Tag.Add {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Tag.Add.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Tag.Add.Scope>
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
                        "blog.tag.path_prefix"
                    ) ?? "tags"
                return try await scope.tag.insert(
                    Tag.Model.create(
                        title: input.title,
                        excerpt: input.excerpt,
                        content: input.content,
                        imageAssetId: input.imageAssetId,
                        metadata: input.metadata.asMetadataBase(
                            template: "blog.tag",
                            slug: input.metadata.slug.prefixedSlug(with: prefix)
                        )
                    )
                )
            }
            return .init(
                id: model.id,
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId,
                metadata: model.metadata.asSnapshot,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }
    }
}
