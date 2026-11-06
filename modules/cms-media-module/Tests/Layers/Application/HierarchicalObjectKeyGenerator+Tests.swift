import FeatherDomain
import FeatherInfrastructure
import MediaDomain
import MediaModule
import Testing

@testable import MediaApplication

@Suite
struct HierarchicalObjectKeyGeneratorTests {
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
