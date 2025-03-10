import Flutter
import UIKit
import FCUUID

public class FlutterUdidPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_udid", binaryMessenger: registrar.messenger())
        let instance = FlutterUdidPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getUDID":
            self.getUniqueDeviceIdentifierAsString(result: result);
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func getUniqueDeviceIdentifierAsString(result: @escaping FlutterResult) {
        // Run the UDID retrieval on a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            // Get the UDID on background thread
            let udid = FCUUID.uuidForDevice()
            
            // Switch back to main thread for Flutter result callback
            DispatchQueue.main.async {
                if let udid = udid, !udid.isEmpty {
                    result(udid)
                } else {
                    result(FlutterError(code: "UNAVAILABLE",
                                       message: "UDID not available",
                                       details: nil))
                }
            }
        }
    }
}
