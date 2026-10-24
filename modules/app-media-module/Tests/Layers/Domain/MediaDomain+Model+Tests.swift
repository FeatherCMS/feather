import Foundation
import MediaModule
import Testing

@testable import MediaDomain

@Suite
struct MediaDomainModelTests {
    @Test
    func mediaAssetCreateDefaultsToUploadedStatus() {
        let asset = Asset.File.Model.create(
            folderId: "folder-1",
            name: "hero",
            slug: "hero",
            slugPath: "products/hero",
            storageObjectId: "storage-1",
            extension: "jpg",
            contentType: "image/jpeg",
            sizeBytes: 123,
            title: "Hero",
            altText: "Product hero"
        )

        #expect(asset.status == .uploaded)
        #expect(asset.slugPath == "products/hero")
    }

    @Test
    func mediaAssetUpdateAppliesOptionalFieldChanges() {
        var asset = Asset.File.Model(
            id: "asset-1",
            folderId: nil,
            name: "hero",
            slug: "hero",
            slugPath: "hero",
            storageObjectId: "storage-1",
            extension: "jpg",
            contentType: "image/jpeg",
            sizeBytes: 123,
            status: .uploaded,
            title: "Old title",
            altText: "Old description",
            createdAt: .init(),
            updatedAt: .init(),
            deletedAt: nil
        )

        asset.update(title: .set("New title"), altText: .clear)

        #expect(asset.title == "New title")
        #expect(asset.altText == nil)
    }

    @Test
    func mediaAssetSlugNormalizesItsName() {
        #expect(
            Asset.File.Model.slug(from: "Featured image") == "featured-image"
        )
    }

    @Test
    func mediaFolderUpdateDerivesItsSlugPath() throws {
        var folder = Asset.Folder.Model(
            id: "folder-1",
            parentId: "parent-1",
            name: "Old name",
            slug: "old-name",
            slugPath: "parent/old-name",
            assetCount: 0,
            totalSizeBytes: 0,
            createdAt: .init(),
            updatedAt: .init(),
            deletedAt: nil
        )

        try folder.update(name: .set("New folder"), parentPath: "parent")

        #expect(folder.name == "New folder")
        #expect(folder.slug == "new-folder")
        #expect(folder.slugPath == "parent/new-folder")
    }

    @Test
    func mediaFolderCreateNormalizesNameAndSetsParentPath() throws {
        let folder = try Asset.Folder.Model.create(
            parentId: "parent-1",
            name: " New folder ",
            parentPath: "parent"
        )

        #expect(folder.name == "New folder")
        #expect(folder.slug == "new-folder")
        #expect(folder.slugPath == "parent/new-folder")
    }

    @Test
    func mediaFolderUpdateAdjustsAggregates() throws {
        var folder = Asset.Folder.Model(
            id: "folder-1",
            parentId: nil,
            name: "Media",
            slug: "media",
            slugPath: "media",
            assetCount: 2,
            totalSizeBytes: 100,
            createdAt: .init(),
            updatedAt: .init(),
            deletedAt: nil
        )

        folder.updateAggregates(
            assetCountDelta: 1,
            totalSizeBytesDelta: 50
        )

        #expect(folder.assetCount == 3)
        #expect(folder.totalSizeBytes == 150)
    }

    @Test
    func mediaAssetVariantStoresVariantAndProcessorIdentity() {
        let variant = Asset.File.Variant.Model.create(
            assetNodeFileId: "asset-1",
            variantId: "variant-1",
            variantProcessorId: "processor-1",
            storageObjectId: "object-1"
        )

        #expect(variant.assetNodeFileId == "asset-1")
        #expect(variant.variantId == "variant-1")
        #expect(variant.variantProcessorId == "processor-1")
        #expect(variant.storageObjectId == "object-1")
    }

    @Test
    func mediaAssetStorageObjectStoresCanonicalFileMetadata() {
        let object = StorageObject.Model.create(
            key: "variants/preview",
            extension: "webp",
            contentType: "image/webp",
            sizeInBytes: 123
        )

        #expect(object.key == "variants/preview")
        #expect(object.extension == "webp")
        #expect(object.contentType == "image/webp")
        #expect(object.sizeInBytes == 123)
    }

    @Test
    func mediaExtensionMatcherMatchesCanonicalExtension() {
        let asset = Asset.File.Model(
            id: "asset-1",
            folderId: nil,
            name: "hero",
            slug: "hero",
            slugPath: "hero",
            storageObjectId: "storage-1",
            extension: "jpg",
            contentType: "image/jpeg",
            sizeBytes: 123,
            status: .uploaded,
            title: nil,
            altText: nil,
            createdAt: .init(),
            updatedAt: .init(),
            deletedAt: nil
        )
        let processor = Variant.Processor.Model(
            id: "processor-1",
            variantId: "variant-1",
            name: "preview",
            matchExtensions: "png, jpg",
            commandTemplate: "cp {input.fullname} {output.fullname}",
            isActive: true,
            createdAt: .init(),
            updatedAt: .init()
        )

        #expect(
            Asset.ExtensionMatcher.matches(
                extension: asset.extension,
                processor: processor
            )
        )
    }
}
