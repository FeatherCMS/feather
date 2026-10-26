import FeatherDBAL
public import FeatherDatabase
public import FeatherInfrastructure
import MediaDomain
import MediaModule

public struct TableSeedMigration: DatabaseMigration {
    public let context: DatabaseTransactionContext

    public var connection: any DatabaseConnection {
        context.connection
    }

    public init(
        context: DatabaseTransactionContext
    ) {
        self.context = context
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let variantRepository = Variant.Repository.Database(context: context)
        let processorRepository = Variant.Processor.Repository.Database(
            context: context
        )

        let variant: Variant.Model
        if var existing = try await variantRepository.list()
            .first(where: { $0.key == "preview" })
        {
            existing.name = "Preview"
            existing.isRequired = true
            existing.isActive = true
            variant = try await variantRepository.update(existing)
        }
        else {
            variant = try await variantRepository.insert(
                Variant.Model.create(
                    key: "preview",
                    name: "Preview",
                    isRequired: true,
                    isActive: true
                )
            )
        }

        let coverVariant: Variant.Model
        if var existing = try await variantRepository.list()
            .first(where: { $0.key == "cover" })
        {
            existing.name = "Cover"
            existing.isRequired = false
            existing.isActive = true
            coverVariant = try await variantRepository.update(existing)
        }
        else {
            coverVariant = try await variantRepository.insert(
                Variant.Model.create(
                    key: "cover",
                    name: "Cover",
                    isRequired: false,
                    isActive: true
                )
            )
        }

        let definitions = [
            Variant.Processor.Model.create(
                variantId: variant.id,
                name: "ImageMagick",
                matchExtensions: "png,jpg,jpeg,bmp",
                commandTemplate:
                    "convert -define jpeg:size=512x512 {input.fullname} -filter Triangle -resize 256x256^ -gravity center -background none -extent 256x256 -strip -quality 82 -define webp:method=3 {output.dirname}/{output.basename}.webp",
                isActive: true
            ),
            Variant.Processor.Model.create(
                variantId: variant.id,
                name: "Ghostscript",
                matchExtensions: "pdf",
                commandTemplate:
                    "gs -dSAFER -dBATCH -dNOPAUSE -dNOPROMPT -sDEVICE=pngalpha -r300 -dFirstPage=1 -dLastPage=1 -dUseCropBox -dFIXEDMEDIA -dPDFFitPage -g256x256 -sOutputFile=\"{output.dirname}/{output.basename}.png\" \"{input.fullname}\"",
                isActive: true
            ),
            Variant.Processor.Model.create(
                variantId: variant.id,
                name: "FFmpeg",
                matchExtensions: "mp4,mov,avi",
                commandTemplate:
                    "ffmpeg -y -ss 00:00:01 -i \"{input.fullname}\" -frames:v 1 -vf \"scale=256:256:force_original_aspect_ratio=decrease,pad=256:256:(ow-iw)/2:(oh-ih)/2\" \"{output.dirname}/{output.basename}.png\"",
                isActive: true
            ),
        ]

        let existingProcessors = try await processorRepository.list(
            variantId: variant.id
        )
        for definition in definitions {
            if var existing = existingProcessors.first(where: {
                $0.name == definition.name
            }) {
                existing.matchExtensions = definition.matchExtensions
                existing.commandTemplate = definition.commandTemplate
                existing.isActive = true
                _ = try await processorRepository.update(existing)
            }
            else {
                _ = try await processorRepository.insert(
                    definition
                )
            }
        }

        let coverDefinitions = [
            Variant.Processor.Model.create(
                variantId: coverVariant.id,
                name: "ImageMagick",
                matchExtensions: "png,jpg,jpeg,bmp",
                commandTemplate:
                    "convert -define jpeg:size=2560x1280 {input.fullname} -filter Triangle -resize 1920x960^ -gravity center -background none -extent 1920x960 -strip -quality 82 -define webp:method=3 {output.dirname}/{output.basename}.webp",
                isActive: true
            ),
            Variant.Processor.Model.create(
                variantId: coverVariant.id,
                name: "FFmpeg",
                matchExtensions: "mp4,mov,avi",
                commandTemplate:
                    "ffmpeg -y -ss 00:00:01 -i \"{input.fullname}\" -frames:v 1 -vf \"scale=1920:960:force_original_aspect_ratio=increase,crop=1920:960\" \"{output.dirname}/{output.basename}.png\"",
                isActive: true
            ),
        ]

        let existingCoverProcessors = try await processorRepository.list(
            variantId: coverVariant.id
        )
        for definition in coverDefinitions {
            if var existing = existingCoverProcessors.first(where: {
                $0.name == definition.name
            }) {
                existing.matchExtensions = definition.matchExtensions
                existing.commandTemplate = definition.commandTemplate
                existing.isActive = true
                _ = try await processorRepository.update(existing)
            }
            else {
                _ = try await processorRepository.insert(
                    definition
                )
            }
        }
    }
}
