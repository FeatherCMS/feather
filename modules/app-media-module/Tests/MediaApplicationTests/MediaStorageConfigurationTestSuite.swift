import FeatherDomain
import FeatherInfrastructure
import Testing

@testable import MediaApplication

@Suite
struct HierarchicalObjectKeyGeneratorTestSuite {
    @Test
    func hierarchicalShardingIsEnabledByDefault() {
        let generator = HierarchicalObjectKeyGenerator()

        #expect(generator.depth == 2)
        #expect(generator.segmentLength == 2)
    }

    @Test
    func shardingConfigurationNormalizesInvalidValues() {
        let generator = HierarchicalObjectKeyGenerator(
            depth: -1,
            segmentLength: 0
        )

        #expect(generator.depth == 0)
        #expect(generator.segmentLength == 1)
    }

    @Test
    func buildsShardPrefixesForObjectKeys() throws {
        let generator = HierarchicalObjectKeyGenerator(
            depth: 2,
            segmentLength: 2
        )

        #expect(try generator.generate(from: "123456789") == "12/34/56789")
    }

    @Test
    func rejectsEmptyValues() {
        let generator = HierarchicalObjectKeyGenerator()

        #expect(throws: ObjectKeyGeneratorError.self) {
            try generator.generate(from: "")
        }
    }

    @Test
    func zeroDepthStillUsesAssetIDAsTheObjectNamespace() throws {
        let generator = HierarchicalObjectKeyGenerator(
            depth: 0,
            segmentLength: 2
        )

        #expect(try generator.generate(from: "123456789") == "123456789")
    }
}

@Suite
struct MediaPublicURLTestSuite {
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
            ) == "/12/34/56789/originals/example/projects/Hero%20Image.png"
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
                == "/12/34/56789/variants/cover/example/projects/Hero%20Image.webp"
        )
    }
}
