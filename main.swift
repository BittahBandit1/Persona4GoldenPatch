import AppKit
import CryptoKit

let original = "0f327c7669e6cac72aaf355181b1e51edd12fee4d71709fc1802dbf0da70546e"
let patched = "7d1625bcafe13dcc1ee2abce7083656a09d9fab8f37b1d016d3ac014ce85fd49"
func digest(_ data: Data) -> String {
    SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
}
struct PatchError: LocalizedError {
    let message: String
    init(_ message: String) { self.message = message }
    var errorDescription: String? { message }
}
func patch(_ source: URL, _ destination: URL) throws {
    var data = try Data(contentsOf: source)
    switch digest(data) {
    case original: break
    case patched: throw PatchError("This executable already has the fix.")
    default: throw PatchError("Unsupported executable. Select the original 64-bit Steam build 10836033.")
    }
    let code: [UInt8] = [0x0f,0xa2,0x50,0xb8,0x0f,0xa2,0x90,0x90,0x2d,0x74,0xec,0xe3,0xbf,0x58,0xc3]
    let start = 0x90fa650
    data.replaceSubrange(start..<start+25, with: code + Array(repeating: UInt8(0x90), count: 25-code.count))
    guard digest(data) == patched else { throw PatchError("Output verification failed.") }
    try data.write(to: destination, options: .withoutOverwriting)
}
func chooseFiles() throws {
    let open = NSOpenPanel()
    open.title = "Select your original Persona 4 Golden executable"
    guard open.runModal() == .OK, let source = open.url else { return }
    let save = NSSavePanel()
    save.title = "Save a new patched copy (choose an unused filename)"
    save.nameFieldStringValue = "P4G-patched.exe"
    guard save.runModal() == .OK, let output = save.url else { return }
    try patch(source, output)
    let alert = NSAlert()
    alert.messageText = "Patched copy verified and saved"
    alert.informativeText = output.path
    alert.runModal()
}
if CommandLine.arguments.count == 3 {
    do { try patch(URL(fileURLWithPath: CommandLine.arguments[1]), URL(fileURLWithPath: CommandLine.arguments[2])) }
    catch { FileHandle.standardError.write(Data((error.localizedDescription + "\n").utf8)); exit(1) }
} else {
    let app = NSApplication.shared
    app.setActivationPolicy(.regular)
    app.activate(ignoringOtherApps: true)
    do { try chooseFiles() } catch { NSAlert(error: error).runModal() }
}
