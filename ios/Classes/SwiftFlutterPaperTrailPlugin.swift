import Flutter
import UIKit
import PaperTrailLumberjack

extension DDLogLevel {
    static func fromString(logLevelString:String) -> DDLogLevel {
        switch logLevelString {
        case "error":
            return DDLogLevel.error
        case "warning":
            return DDLogLevel.warning
        case "info":
            return DDLogLevel.info
        case "debug":
            return DDLogLevel.debug
        default:
            return DDLogLevel.info
        }
    }
}

public class SwiftFlutterPaperTrailPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_paper_trail", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterPaperTrailPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "initLogger" {
            self.setupLoggerAndParseArguments(call, result: result)
        }
        if call.method == "log"{
            logMessageAndParseArguments(call, result: result)
        }
    }
    
    private func logMessageAndParseArguments(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        guard let params = call.arguments as? Dictionary<String,String> else {
            result(nil)
            return
        }
        
        guard let message = params["message"] else {
            result(nil)
            return
        }
        guard let logLevelString = params["logLevel"] else {
            result(nil)
            return
        }
        let logLevel = DDLogLevel.fromString(logLevelString: logLevelString)
        switch logLevel {
        case .debug:
            DDLogDebug(message)
        case .info:
            DDLogInfo(message)
        case .error:
            DDLogError(message)
        default:
            DDLogError(message)
        }
        
        result("logged")
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
        result("Logger initialized")
    }
    
    private func setupLogger(hostName:String, port:UInt, programName:String, machineName:String){
        let paperTrailLogger = RMPaperTrailLogger.sharedInstance()!
        paperTrailLogger.host = hostName
        paperTrailLogger.port = port
        
        paperTrailLogger.programName = programName
        paperTrailLogger.machineName = machineName
        DDLog.add(paperTrailLogger)
    }
}
