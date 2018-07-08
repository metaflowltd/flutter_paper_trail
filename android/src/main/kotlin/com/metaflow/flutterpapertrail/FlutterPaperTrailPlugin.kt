package com.metaflow.flutterpapertrail

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import me.jagdeep.papertrail.timber.PapertrailTree
import timber.log.Timber

class FlutterPaperTrailPlugin : MethodCallHandler {

  private var _treeBuilder: PapertrailTree.Builder? = null
  private var _tree: PapertrailTree? = null
  private var _programName: String? = null

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter_paper_trail")
      channel.setMethodCallHandler(FlutterPaperTrailPlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when {
        call.method == "initLogger" -> initLoggerAndParseArguments(call, result)
        call.method == "setUserId" -> configureUserAndParseArguments(call, result)
        call.method == "log" -> logAndParseArguments(call, result)
        else -> result.notImplemented()
    }
  }

  private fun configureUserAndParseArguments(call: MethodCall, result: Result){
    if (call.arguments !is Map<*, *>){
      result.error("missing arguments", "", null)
      return
    }

    val arguments = call.arguments as Map<*, *>?

    if (arguments == null){
      result.error("missing arguments", "", null)
      return
    }

    val userId = arguments["userId"] as String?
    if (userId == null){
      result.error("missing argument userId", "", null)
      return
    }

    if (_tree == null || _programName == null || _treeBuilder == null ){
      result.error("Cannot call configure user before init logger", "", null)
      return
    }
    _treeBuilder!!.program(userId + "--on--" + _programName!!)

    Timber.uproot(_tree!!)
    _tree = _treeBuilder!!.build()
    Timber.plant(_tree!!)
    result.success("Logger updated")

  }

  private fun logAndParseArguments(call: MethodCall, result: Result){
    if (call.arguments !is Map<*, *>){
      result.error("missing arguments", "", null)
      return
    }

    val arguments = call.arguments as Map<*, *>?

    if (arguments == null){
      result.error("missing arguments", "", null)
      return
    }

    val message = arguments["message"] as String?
    if (message == null){
      result.error("missing argument message", "", null)
      return
    }

    val logLevel = arguments["logLevel"] as String?
    if (logLevel == null){
      result.error("missing argument logLevel", "", null)
      return
    }

    when (logLevel) {
        "error" -> Timber.e(message)
        "warning" -> Timber.w(message)
        "info" -> Timber.i(message)
        "debug" -> Timber.d(message)
        else -> Timber.i(message)
    }

    result.success("logged")
  }

  private fun initLoggerAndParseArguments(call: MethodCall, result: Result){
    if (call.arguments !is Map<*, *>){
      result.error("missing arguments", "", null)
      return
    }

    val arguments = call.arguments as Map<*, *>?

    if (arguments == null){
      result.error("missing arguments", "", null)
      return
    }

    val hostName = arguments["hostName"] as String?
    if (hostName == null){
      result.error("missing arguments", "", null)
      return
    }

    val machineName = arguments["machineName"] as String?
    if (machineName == null){
      result.error("missing argument machineName", "", null)
      return
    }

    val portString = arguments["port"] as String?
    if (portString == null){
      result.error("missing argument port", "", null)
      return
    }

    val port =
    try {
       portString.toInt()
    } catch (e: Exception) {
      result.error("port is not a number", "", null)
      return
    }

    _programName = arguments["programName"] as String?
    if (_programName == null){
      result.error("missing argument programName", "", null)
      return
    }

    val safeMachineName = cleanString(machineName)

    if (_tree != null){
      Timber.uproot(_tree!!)
    }

    _treeBuilder = PapertrailTree.Builder()
            .system(safeMachineName)
            .program(_programName!!)
            .logger(_programName!!)
            .host(hostName)
            .port(port)

    _tree = _treeBuilder!!.build()
    Timber.plant(_tree!!)
    result.success("Logger initialized")
  }

  private fun cleanString(stringToClean: String): String {
    val re = Regex("[^A-Za-z0-9 ]")
    return re.replace(stringToClean, "")
  }

}

