import AdminOpenAPI
import Hummingbird

struct AdminListMediaAssetDefaultInteractor: AdminListMediaAssetInteractor {
    let repository: AdminMediaAssetOpenAPIRepository

    func listMediaAssets(
        page: Int,
        search: String?,
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode,
        picker: AdminListMediaAssetModel.PickerState
    ) async throws -> AdminListMediaAssetModel {
        let effectiveParentId: String?
        if parentId == nil,
            picker.isEnabled,
            let defaultFolderPath = picker.defaultFolderPath,
            !defaultFolderPath.isEmpty
        {
            effectiveParentId = try await findFolderPath(defaultFolderPath)
        }
        else {
            effectiveParentId = parentId
        }
        async let assetsResult = repository.listAssets(
            page: page,
            search: search,
            parentId: effectiveParentId,
            allowedExtensions: picker.allowedExtensions
        )
        async let foldersResult = repository.listFolders(
            parentId: effectiveParentId
        )

        let currentFolder: Components.Schemas.MediaFolderDetailSchema?
        if let effectiveParentId {
            currentFolder = try await repository.getFolder(
                id: effectiveParentId
            )
        }
        else {
            currentFolder = nil
        }
        let ancestors = try await loadAncestors(for: currentFolder)
        let result = try await assetsResult
        let folders = try await foldersResult
        let items = try await loadAssetItems(result.items)
        return .init(
            folders: folders,
            items: items,
            total: result.total,
            page: result.page,
            pageSize: result.pageSize,
            parentId: effectiveParentId,
            currentFolder: currentFolder,
            ancestors: ancestors,
            view: view,
            picker: picker
        )
    }

    func bulkRemove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }

    func deleteFolder(
        id: String
    ) async throws {
        try await repository.deleteFolder(id: id)
    }
}

extension AdminListMediaAssetDefaultInteractor {
    fileprivate func findFolderPath(
        _ path: String
    ) async throws -> String? {
        let components =
            path
            .split(separator: "/")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        guard !components.isEmpty else {
            return nil
        }
        var parentId: String?
        for name in components {
            let folders = try await repository.listFolders(parentId: parentId)
            if let existing = folders.first(where: {
                $0.name.caseInsensitiveCompare(name) == .orderedSame
            }) {
                parentId = existing.id
                continue
            }
            return nil
        }
        return parentId
    }

    fileprivate func loadAncestors(
        for currentFolder: Components.Schemas.MediaFolderDetailSchema?
    ) async throws -> [Components.Schemas.MediaFolderDetailSchema] {
        var result: [Components.Schemas.MediaFolderDetailSchema] = []
        var cursor = currentFolder
        while let parentId = cursor?.parentId {
            let parent = try await repository.getFolder(id: parentId)
            result.insert(parent, at: 0)
            cursor = parent
        }
        return result
    }

    fileprivate func loadAssetItems(
        _ items: [Components.Schemas.MediaAssetListItemSchema]
    ) async throws -> [AdminListMediaAssetModel.AssetItem] {
        try await withThrowingTaskGroup(
            of: (Int, AdminListMediaAssetModel.AssetItem).self
        ) { group in
            for (index, asset) in items.enumerated() {
                group.addTask {
                    let variants = try await repository.getVariants(
                        id: asset.id
                    )
                    return (
                        index,
                        .init(
                            asset: asset,
                            preview: variants.first
                        )
                    )
                }
            }
            var collected: [(Int, AdminListMediaAssetModel.AssetItem)] = []
            for try await item in group {
                collected.append(item)
            }
            return collected.sorted { $0.0 < $1.0 }.map(\.1)
        }
    }
}
