import Flutter
import UIKit
import PaperTrailLumberjack
import DeviceKit

public class SwiftFlutterPaperTrailPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_paper_trail", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterPaperTrailPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
        if call.method == "initLogger" {
            self.setupLoggerAndParseArguments(call, result: result)
        }
    }
    
    private func setupLoggerAndParseArguments(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        guard let params = call.arguments as? Dictionary<String,String> else {
            result(nil)
            return
        }
        
        guard let hostName = params["hostName"] else {
            result(nil)
            return
        }
        guard let programName = params["programName"] else {
            result(nil)
            return
        }
        guard let machineName = params["machineName"] else {
            result(nil)
            return
        }
        
        guard let portString = params["port"] else {
            result(nil)
            return
        }
        guard let port = UInt(portString) else{
            result(nil)
            return
        }
        self.setupLogger(hostName: hostName, port: port, programName: programName, machineName: machineName)
        result("OK")
    }
    
    private func setupLogger(hostName:String, port:UInt, programName:String, machineName:String ){
        let paperTrailLogger = RMPaperTrailLogger.sharedInstance()!
        paperTrailLogger.host = hostName + ".papertrailapp.com" //Your host here
        paperTrailLogger.port = port //Your port number here
        
        paperTrailLogger.programName = programName
        paperTrailLogger.machineName = Device().description
        DDLog.add(paperTrailLogger)
        DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
        
    }
}
