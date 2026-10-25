import FeatherValidation
import HTML
import MediaModule

extension Asset.File.Edit.Interactor {
    struct Default: Interface {
        let repository: any Asset.File.Edit.Repository.Interface

        func load(
            id: String
        ) async throws -> Asset.File.Edit.Model {
            try await repository.getAsset(id: id)
        }

        func update(
            id: String,
            input: Asset.File.Edit.Form.Input
        ) async throws -> Asset.File.Edit.Model {
            try await repository.updateAsset(
                id: id,
                title: input.normalizedTitle,
                altText: input.normalizedAltText
            )
        }
    }
}
