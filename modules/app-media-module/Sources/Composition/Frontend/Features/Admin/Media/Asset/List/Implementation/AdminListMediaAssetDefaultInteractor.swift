import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListMediaAssetDefaultInteractor: AdminListMediaAssetInteractor {
    let repository: AdminListMediaAssetOpenAPIRepository

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
        let result = try await repository.listAssets(
            page: page,
            search: search,
            parentId: effectiveParentId,
            allowedExtensions: picker.allowedExtensions.values
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
        let entries = try await loadEntries(
            result.items,
            previewVariant: picker.previewVariant
        )
        return .init(
            entries: entries,
            pageState: result.pageState,
            parentId: effectiveParentId,
            currentFolder: currentFolder,
            ancestors: ancestors,
            view: view,
            picker: picker
        )
    }

    func remove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }

    func resolveRemoveItems(
        ids: [String]
    ) async throws -> [NewAdminRemoveItemContext] {
        let assets = try await repository.resolveAssets(ids: ids)
        let assetsByID = assets.reduce(
            into: [String: Components.Schemas.MediaAssetResolveItemSchema]()
        ) { result, asset in
            result[asset.id] = asset
        }
        var result: [NewAdminRemoveItemContext] = []
        result.reserveCapacity(ids.count)
        for id in ids {
            if let asset = assetsByID[id] {
                result.append(
                    .init(
                        id: id,
                        label: assetFilename(for: asset, id: id)
                    )
                )
                continue
            }
            if let folderName = try await folderName(for: id) {
                result.append(.init(id: id, label: folderName))
            }
            else {
                result.append(.init(id: id, label: id))
            }
        }
        return result
    }

    private func assetFilename(
        for asset: Components.Schemas.MediaAssetResolveItemSchema,
        id: String
    ) -> String {
        let path = URL(string: asset.url)?.path ?? asset.url
        if let filename = path.split(separator: "/").last,
            !filename.isEmpty
        {
            return String(filename).removingPercentEncoding ?? String(filename)
        }
        return id
    }

    private func folderName(for id: String) async throws -> String? {
        do {
            return try await repository.getFolder(id: id).name
        }
        catch let error as OpenAPIRepositoryError {
            if case .notFound = error {
                return nil
            }
            throw error
        }
    }

}

extension AdminListMediaAssetDefaultInteractor {
    fileprivate func findFolderPath(
        _ path: String
    ) async throws -> String? {
        let components =
            path
            .split(separator: "/")
            .map { $0.whitespaceTrimmed }
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

            do {
                try await repository.createFolder(
                    name: name,
                    parentId: parentId
                )
            }
            catch let error as OpenAPIRepositoryError {
                guard case .conflict = error else { throw error }
            }

            let resolvedFolders = try await repository.listFolders(
                parentId: parentId
            )
            guard
                let created = resolvedFolders.first(where: {
                    $0.name.caseInsensitiveCompare(name) == .orderedSame
                })
            else {
                return nil
            }
            parentId = created.id
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

    fileprivate func loadEntries(
        _ items: [Components.Schemas.MediaAssetNodeSearchItemSchema],
        previewVariant: String?
    ) async throws -> [AdminListMediaAssetModel.EntryItem] {
        let assetIDs = items.compactMap { $0.file?.id }
        let variantKeys = previewVariant.map {
            $0 == "preview" ? [$0] : [$0, "preview"]
        }
        let assets = try await repository.resolveAssets(
            ids: assetIDs,
            variants: variantKeys
        )
        let assetsByID = assets.reduce(
            into: [String: Components.Schemas.MediaAssetResolveItemSchema]()
        ) { result, asset in
            result[asset.id] = asset
        }

        var result: [AdminListMediaAssetModel.EntryItem] = []
        result.reserveCapacity(items.count)
        for item in items {
            if let asset = item.file {
                let preview = assetsByID[asset.id]
                    .flatMap {
                        preferredPreview(
                            from: $0.variants,
                            key: previewVariant
                        )
                    }
                result.append(
                    .asset(
                        .init(
                            asset: asset,
                            preview: preview
                        )
                    )
                )
            }
            else if let folder = item.folder {
                result.append(.folder(folder))
            }
        }
        return result
    }

    private func preferredPreview(
        from variants: [Components.Schemas.MediaAssetResolveVariantSchema],
        key: String?
    ) -> Components.Schemas.MediaAssetResolveVariantSchema? {
        if let key,
            let preferred = variants.first(where: { $0.key == key })
        {
            return preferred
        }
        return variants.first(where: { $0.key == "preview" })
    }
}
