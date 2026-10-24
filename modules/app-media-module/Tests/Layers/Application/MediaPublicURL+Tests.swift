import FeatherDomain
import FeatherInfrastructure
import MediaDomain
import MediaModule
import Testing

@testable import MediaApplication

@Suite
struct MediaPublicURLTests {
    @Test
    func storageObjectsUsePublicTopLevelFolderAndTwoLevelShard() throws {
        let sharder = HierarchicalObjectKeyGenerator(
            depth: 2,
            segmentLength: 2
        )

        #expect(
            try StorageObject.Model.storageKey(
                assetID: "abcdefghijklmno",
                key: "variants/cover",
                extension: "webp",
                objectKeyGenerator: sharder
            ) == "public/ab/cd/efghijklmno/variants/cover.webp"
        )
    }

    @Test
    func emitsReadableOriginalAndVariantURLsWithTheConfiguredPrefix() throws {
        let sharder = HierarchicalObjectKeyGenerator(depth: 2, segmentLength: 2)

        #expect(
            try mediaAssetPublicURL(
                id: "123456789",
                slugPath: "example/projects/hero-image",
                filename: "Hero Image",
                extension: "png",
                objectKeyGenerator: sharder
            )
                == "/public/12/34/56789/originals/example/projects/Hero%20Image.png"
        )
        #expect(
            try mediaVariantPublicURL(
                assetId: "123456789",
                slugPath: "example/projects/hero-image",
                filename: "Hero Image",
                variantKey: "cover",
                extension: "webp",
                objectKeyGenerator: sharder
            )
                == "/public/12/34/56789/variants/cover/example/projects/Hero%20Image.webp"
        )
    }
}
