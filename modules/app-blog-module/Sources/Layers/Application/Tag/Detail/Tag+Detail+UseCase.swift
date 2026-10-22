public import BlogModule
public import FeatherApplication
public import FeatherModuleKit
import WebApplication

//
//  GetTag.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Tag.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        struct Error: UseCaseError {
            let message: String
        }

        let authorizer: any Authorizer
        let query: any QueryExecutor<Tag.Detail.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Tag.Detail.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Tag.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let id = input.id

            return try await query.run { scope in
                let tag = try await scope.tag.find(id: id)
                guard
                    let metadata = try await scope.metadata.find(
                        referenceType: "blog.tag",
                        referenceID: id
                    )
                else {
                    throw Error(message: "Tag metadata not found")
                }
                return .init(
                    id: tag.id,
                    title: tag.title,
                    excerpt: tag.excerpt,
                    content: tag.content,
                    imageAssetId: tag.imageAssetId,
                    metadata: metadata,
                    createdAt: tag.createdAt,
                    updatedAt: tag.updatedAt
                )
            }
        }
    }
}
