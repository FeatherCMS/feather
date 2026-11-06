import FeatherValidation
import HTML
import MediaModule

extension Asset.Folder.Edit.Interactor {
    struct Default: Interface {
        let repository: any Asset.Folder.Edit.Repository.Interface

        func load(
            id: String
        ) async throws -> Asset.Folder.Edit.Model {
            try await repository.getFolder(id: id)
        }

        func update(
            id: String,
            input: Asset.Folder.Edit.Form.Input
        ) async throws -> Asset.Folder.Edit.Model {
            try await repository.updateFolder(
                id: id,
                name: input.normalizedName
            )
        }
    }
}
