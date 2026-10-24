import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Edit.Interactor {
    struct Default: Interface {
        let repository: Asset.File.Edit.Repository.OpenAPI

        func load(
            id: String
        ) async throws -> Asset.File.Edit.Model {
            let item = try await repository.getAsset(id: id)
            return .init(
                id: item.id,
                title: item.title ?? "",
                altText: item.altText ?? "",
                error: nil
            )
        }

        func update(
            id: String,
            input: Asset.File.Edit.Form.Input
        ) async throws -> Asset.File.Edit.Model {
            let item = try await repository.updateAsset(
                id: id,
                title: input.normalizedTitle,
                altText: input.normalizedAltText
            )
            return .init(
                id: item.id,
                title: item.title ?? "",
                altText: item.altText ?? "",
                error: nil
            )
        }
    }
}
