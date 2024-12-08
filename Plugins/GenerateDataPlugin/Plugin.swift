import Foundation
import PackagePlugin

@main
struct GenerateDataPlugin: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: any PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        let disk = FileManager.default
        let tool = try context.tool(named: "GenerateData")

        print("Cleaning plugin work directory...")
        disk.forceClean(directory: context.pluginWorkDirectoryURL)

        let files = try filesFromDirectory(path: URL(string: target.directory.string)!)
            .filter { url in
                url.pathExtension == "yml"
            }

        return files.map { input in
            let output = context.pluginWorkDirectoryURL.appending(path: "Generated-" + input.lastPathComponent.replacingOccurrences(of: ".yml", with: ".swift"))

            print("XXX \(input) -> \(output)")

            return .buildCommand(
                displayName: "Compile NutriData \(input.lastPathComponent)",
                executable: tool.url,
                arguments: [
                    "--input", input.absoluteString.replacingOccurrences(of: "file://", with: ""),
                    "--output", output.absoluteString.replacingOccurrences(of: "file://", with: "")
                ],
                environment: [:],
                inputFiles: [
                    input
                ],
                outputFiles: [
                    output
                ]
            )
        }
    }
}

private extension FileManager {
    func forceClean(directory: URL) {
        try? removeItem(at: directory)
        try? createDirectory(at: directory, withIntermediateDirectories: false)
    }
}

func filesFromDirectory(path providedPath: URL) throws -> [URL] {
    return try FileManager.default.contentsOfDirectory(at: providedPath, includingPropertiesForKeys: nil)
}
