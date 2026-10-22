public import FeatherApplication
public import FeatherDomain
public import FeatherModuleKit
import MediaDomain
public import MediaModule

//
//  Asset.File.Edit.UseCase.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Asset.File.Edit {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Asset.File.Edit.Scope>
        let objectKeyGenerator: any ObjectKeyGenerator

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Asset.File.Edit.Scope>,
            objectKeyGenerator: any ObjectKeyGenerator
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
            self.objectKeyGenerator = objectKeyGenerator
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

            return try await transaction.run { scope in
                guard var asset = try await scope.assets.find(id: input.id)
                else {
                    throw Asset.File.Edit.Error(message: "Asset not found")
                }

                asset.title = input.title.apply(to: asset.title)
                asset.altText = input.altText.apply(to: asset.altText)

                let updated = try await scope.assets.update(asset)
                return .init(
                    detail: try .init(
                        id: updated.id,
                        folderId: updated.folderId,
                        name: updated.name,
                        slug: updated.slug,
                        slugPath: updated.slugPath,
                        url: mediaAssetPublicURL(
                            id: updated.id,
                            slugPath: updated.slugPath,
                            filename: updated.name,
                            extension: updated.extension,
                            objectKeyGenerator: objectKeyGenerator
                        ),
                        extension: updated.extension,
                        contentType: updated.contentType,
                        sizeBytes: updated.sizeBytes,
                        status: updated.status.rawValue,
                        title: updated.title,
                        altText: updated.altText,
                        createdAt: updated.createdAt,
                        updatedAt: updated.updatedAt
                    )
                )
            }
        }
    }
}
