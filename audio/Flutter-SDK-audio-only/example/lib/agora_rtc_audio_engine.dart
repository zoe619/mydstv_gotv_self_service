import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AgoraRtcEngine {
  static const MethodChannel _channel = const MethodChannel('agora_rtc_engine');

  // Core Events
  /// Reports a warning during SDK runtime.
  ///
  /// In most cases, the app can ignore the warning reported by the SDK because the SDK can usually fix the issue and resume running.
  static void Function(int warn) onWarning;

  /// Reports an error during SDK runtime.
  ///
  /// In most cases, the SDK cannot fix the issue and resume running. The SDK requires the app to take action or informs the user about the issue.
  static void Function(int err) onError;

  /// Occurs when a user joins a specified channel.
  ///
  /// The channel name assignment is based on channelName specified in the [joinChannel] method.
  /// If the uid is not specified when [joinChannel] is called, the server automatically assigns a uid.
  static void Function(String channel, int uid, int elapsed)
      onJoinChannelSuccess;

  /// Occurs when a user rejoins the channel after being disconnected due to network problems.
  ///
  /// When a user loses connection with the server because of network problems, the SDK automatically tries to reconnect and triggers this callback upon reconnection.
  static void Function(String channel, int uid, int elapsed)
      onRejoinChannelSuccess;

  /// Occurs when a user leaves the channel.
  ///
  /// When the app calls the [leaveChannel] method, the SDK uses this callback to notify the app when the user leaves the channel.
  static VoidCallback onLeaveChannel;

  /// Occurs when the user role switches in a live broadcast.
  static void Function(ClientRole oldRole, ClientRole newRole)
      onClientRoleChanged;

  /// Occurs when a remote user (Communication)/host (Live Broadcast) joins the channel.
  ///
  /// Communication profile: This callback notifies the app when another user joins the channel. If other users are already in the channel, the SDK also reports to the app on the existing users.
  /// Live-broadcast profile: This callback notifies the app when the host joins the channel. If other hosts are already in the channel, the SDK also reports to the app on the existing hosts. Agora recommends having at most 17 hosts in a channel
  static void Function(int uid, int elapsed) onUserJoined;

  /// Occurs when a remote user (Communication)/host (Live Broadcast) leaves the channel.
  ///
  /// There are two reasons for users to become offline:
  /// 1. Leave the channel: When the user/host leaves the channel, the user/host sends a goodbye message. When this message is received, the SDK determines that the user/host leaves the channel.
  /// 2. Drop offline: When no data packet of the user or host is received for a certain period of time (20 seconds for the communication profile, and more for the live broadcast profile), the SDK assumes that the user/host drops offline. A poor network connection may lead to false detections, so Agora recommends using the signaling system for reliable offline detection.
  static void Function(int uid, int elapsed) onUserOffline;

  /// Occurs when the network connection state changes.
  static void Function(int state, int reason) onConnectionStateChanged;

  /// Occurs when the SDK cannot reconnect to Agora's edge server 10 seconds after its connection to the server is interrupted.
  ///
  /// The SDK triggers this callback when it cannot connect to the server 10 seconds after calling [joinChannel], regardless of whether it is in the channel or not.
  static VoidCallback onConnectionLost;

  /// Occurs when an API method is executed.
  static void Function(int error, String api, String result) onApiCallExecuted;

  /// Occurs when the token expires in 30 seconds.
  static void Function(String token) onTokenPrivilegeWillExpire;

  /// Occurs when the token expires.
  static VoidCallback onRequestToken;

  // Media Events
  /// Occurs when the microphone is enabled/disabled.
  static void Function(bool enabled) onMicrophoneEnabled;

  /// Reports which users are speaking and the speakers' volume.
  ///
  /// This callback reports the ID and volume of the loudest speakers at the moment in the channel. This callback is disabled by default and can be enabled by the [enableAudioVolumeIndication] method.
  static void Function(int totalVolume, List<AudioVolumeInfo> speakers)
      onAudioVolumeIndication;

  /// Reports which user is the loudest speaker.
  ///
  /// If the user enables the audio volume indication by calling [enableAudioVolumeIndication], this callback returns the uid of the active speaker whose voice is detected by the audio volume detection module of the SDK.
  static void Function(int uid) onActiveSpeaker;

  /// Occurs when the first local audio frame is sent.
  static void Function(int elapsed) onFirstLocalAudioFrame;

  /// Occurs when the first remote audio frame is received.
  static void Function(int uid, int elapsed) onFirstRemoteAudioFrame;

  /// Occurs when a remote user's audio stream is muted/unmuted.
  static void Function(int uid, bool muted) onUserMuteAudio;

  /// Occurs when the subscribed media stream falls back to audio-only stream due to poor network conditions or switches back to video stream after the network conditions improve.
  ///
  /// If you call [setRemoteSubscribeFallbackOption] and set option as STREAM_FALLBACK_OPTION_AUDIO_ONLY(2), this callback is triggered when the remotely subscribed media stream falls back to audio-only mode due to poor uplink conditions, or when the remotely subscribed media stream switches back to the video after the uplink network condition improves.
  static void Function(int uid, bool isFallbackOrRecover)
      onRemoteSubscribeFallbackToAudioOnly;

  // Device Events
  /// Occurs when the local audio pkayout route changes.
  ///
  /// This callback returns that the audio route switched to an earpiece, speakerphone, headset, or Bluetooth device.
  static void Function(int routing) onAudioRouteChanged;

  // Statistics Events
  /// Reports the statistics of the audio stream from each remote user/host.
  ///
  /// The SDK triggers this callback once every two seconds for each remote user/host. If a channel includes multiple remote users, the SDK triggers this callback as many times.
  static void Function(RemoteAudioStats stats) onRemoteAudioStats;

  /// Reports the statistics of the RtcEngine once every two seconds.
  static void Function(RtcStats stats) onRtcStats;

  /// Reports the last mile network quality of each user in the channel once every two seconds.
  ///
  /// Last mile refers to the connection between the local device and Agora's edge server. This callback reports once every two seconds the uplink last mile network conditions of each user in the channel. If a channel includes multiple users, then this callback will be triggered as many times.
  static void Function(int uid, int txQuality, int rxQuality) onNetworkQuality;

  /// Reports the transport-layer statistics of each remote audio stream.
  ///
  /// This callback reports the transport-layer statistics, such as the packet loss rate and time delay, once every two seconds after the local user receives an audio packet from a remote user.
  static void Function(int uid, int delay, int lost, int rxKBitRate)
      onRemoteAudioTransportStats;

  // Miscellaneous Events
  /// Occurs when the media engine is loaded.
  static VoidCallback onMediaEngineLoadSuccess;

  /// Occurs when the media engine starts.
  static VoidCallback onMediaEngineStartCallSuccess;

  // Core Methods
  /// Creates an RtcEngine instance.
  ///
  /// The Agora SDK only supports one RtcEngine instance at a time, therefore the app should create one RtcEngine object only.
  /// Only users with the same App ID can join the same channel and call each other.
  static Future<void> create(String appid) async {
    _addMethodCallHandler();
    return await _channel.invokeMethod('create', {'appId': appid});
  }

  /// Destroys the RtcEngine instance and releases all resources used by the Agora SDK.
  ///
  /// This method is useful for apps that occasionally make voice or video calls, to free up resources for other operations when not making calls.
  /// Once the app calls destroy to destroy the created RtcEngine instance, you cannot use any method or callback in the SDK.
  static Future<void> destroy() async {
    _removeMethodCallHandler();
    return await _channel.invokeMethod('destroy');
  }

  /// Sets the channel profile.
  ///
  /// RtcEngine needs to know the application scenario to set the appropriate channel profile to apply different optimization methods.
  /// Users in the same channel must use the same channel profile.
  /// Before calling this method to set a new channel profile, [destroy] the current RtcEngine and [create] a new RtcEngine first.
  /// Call this method before [joinChannel], you cannot configure the channel profile when the channel is in use.
  static Future<void> setChannelProfile(ChannelProfile profile) async {
    return await _channel
        .invokeMethod('setChannelProfile', {'profile': profile.index});
  }

  /// Sets the role of a user (Live Broadcast only).
  ///
  /// This method sets the role of a user, such as a host or an audience (default), before joining a channel.
  /// This method can be used to switch the user role after a user joins a channel.
  static Future<void> setClientRole(ClientRole role) async {
    int roleValue = _intFromClientRole(role);
    return await _channel.invokeMethod('setClientRole', {'role': roleValue});
  }

  /// Allows a user to join a channel.
  ///
  /// Users in the same channel can talk to each other, and multiple users in the same channel can start a group chat. Users with different App IDs cannot call each other.
  /// You must call the [leaveChannel] method to exit the current call before joining another channel.
  /// A channel does not accept duplicate uids, such as two users with the same uid. If you set uid as 0, the system automatically assigns a uid.
  static Future<bool> joinChannel(
      String token, String channelId, String info, int uid) async {
    final bool success = await _channel.invokeMethod('joinChannel',
        {'token': token, 'channelId': channelId, 'info': info, 'uid': uid});
    return success;
  }

  /// Allows a user to leave a channel.
  ///
  /// If you call the [destroy] method immediately after calling this method, the leaveChannel process interrupts, and the SDK does not trigger the onLeaveChannel callback.
  static Future<bool> leaveChannel() async {
    final bool success = await _channel.invokeMethod('leaveChannel');
    return success;
  }

  /// Renews the token when the current token expires.
  ///
  /// The app should retrieve a new token from the server and call this method to renew it. Failure to do so results in the SDK disconnecting from the server.
  static Future<void> renewToken(String token) async {
    return await _channel.invokeMethod('renewToken', {'token': token});
  }

  /// Enables interoperability with the Agora Web SDK (Live Broadcast only).
  ///
  /// Use this method when the channel profile is Live Broadcast. Interoperability with the Agora Web SDK is enabled by default when the channel profile is Communication.
  static Future<void> enableWebSdkInteroperability(bool enabled) async {
    return await _channel
        .invokeMethod('enableWebSdkInteroperability', {'enabled': enabled});
  }

  /// Gets the connection state of the SDK.
  static Future<int> getConnectionState() async {
    final int state = await _channel.invokeMethod('getConnectionState');
    return state;
  }

  // Core Audio
  /// Enables the audio module.
  ///
  /// The audio module is enabled by default.
  /// This method affects the internal engine and can be called after calling the [leaveChannel] method. You can call this method either before or after joining a channel.
  /// This method resets the internal engine and takes some time to take effect. Agora recommends using the following API methods to control the audio engine modules separately:
  /// [enableLocalAudio], [muteLocalAudioStream], [muteRemoteAudioStream], [muteAllRemoteAudioStreams].
  static Future<void> enableAudio() async {
    await _channel.invokeMethod('enableAudio');
  }

  /// Disables the audio module.
  ///
  /// The audio module is enabled by default.
  /// This method affects the internal engine and can be called after calling the [leaveChannel] method. You can call this method either before or after joining a channel.
  /// This method resets the engine and takes some time to take effect. Agora recommends using the following API methods to control the audio engine modules separately:
  /// [enableLocalAudio], [muteLocalAudioStream], [muteRemoteAudioStream], [muteAllRemoteAudioStreams].
  static Future<void> disableAudio() async {
    await _channel.invokeMethod('disableAudio');
  }

  /// Sets the audio parameters and application scenarios.
  ///
  /// You must call this method before calling the [joinChannel] method.
  static Future<void> setAudioProfile(AudioProfile profile, AudioScenario scenario) async {
    await _channel.invokeMethod(
        'setAudioProfile', {'profile': profile.index, 'scenario': scenario.index});
  }

  /// Adjusts the recording volume.
  static Future<void> adjustRecordingSignalVolume(int volume) async {
    await _channel
        .invokeMethod('adjustRecordingSignalVolume', {'volume': volume});
  }

  /// Adjusts the playback volume.
  static Future<void> adjustPlaybackSignalVolume(int volume) async {
    await _channel
        .invokeMethod('adjustPlaybackSignalVolume', {'volume': volume});
  }

  /// Enables the [onAudioVolumeIndication] callback at a set time interval to report on which users are speaking and the speakers' volume.
  ///
  /// Once this method is enabled, the SDK returns the volume indication in the [onAudioVolumeIndication] callback at the set time interval, regardless of whether any user is speaking in the channel.
  static Future<void> enableAudioVolumeIndication(
      int interval, int smooth) async {
    await _channel.invokeMethod('enableAudioVolumeIndication',
        {'interval': interval, 'smooth': smooth});
  }

  /// Enables/Disables the local audio capture.
  ///
  /// The audio function is enabled by default. This method disables/re-enables the local audio function, that is, to stop or restart local audio capture and processing.
  /// This method does not affect receiving or playing the remote audio streams, and is applicable to scenarios where the user wants to receive remote audio streams without sending any audio stream to other users in the channel.
  /// The SDK triggers the [onMicrophoneEnabled] callback once the local audio function is disabled or re-enabled.
  /// Call this method after calling the [joinChannelmethod].
  static Future<void> enableLocalAudio(bool enabled) async {
    await _channel.invokeMethod('enableLocalAudio', {'enabled': enabled});
  }

  /// Sends/Stops sending the local audio stream.
  ///
  /// When muted is set as true, this method does not disable the microphone and thus does not affect any ongoing recording.
  static Future<void> muteLocalAudioStream(bool muted) async {
    await _channel.invokeMethod('muteLocalAudioStream', {'muted': muted});
  }

  /// Receives/Stops receiving a specified audio stream.
  ///
  /// If you called the [muteAllRemoteAudioStreams] method and set muted as true to stop receiving all remote video streams, ensure that the [muteAllRemoteAudioStreams] method is called and set muted as false before calling this method.
  /// The [muteAllRemoteAudioStreams] method sets all remote audio streams, while this method sets a specified remote user's audio stream.
  static Future<void> muteRemoteAudioStream(int uid, bool muted) async {
    await _channel
        .invokeMethod('muteRemoteAudioStream', {'uid': uid, 'muted': muted});
  }

  /// Receives/Stops receiving all remote audio streams.
  static Future<void> muteAllRemoteAudioStreams(bool muted) async {
    await _channel.invokeMethod('muteAllRemoteAudioStreams', {'muted': muted});
  }

  /// Sets whether to receive all remote audio streams by default.
  ///
  /// You can call this method either before or after [joinChannel]. If you call this method after joining a channel, the remote audio streams of all subsequent users are not received.
  static Future<void> setDefaultMuteAllRemoteAudioStreams(bool muted) async {
    await _channel
        .invokeMethod('setDefaultMuteAllRemoteAudioStreams', {'muted': muted});
  }

  // Audio Routing Controller
  /// Sets the default audio playback route.
  static Future<void> setDefaultAudioRouteToSpeaker(
      bool defaultToSpeaker) async {
    await _channel.invokeMethod('setDefaultAudioRouteToSpeaker',
        {'defaultToSpeaker': defaultToSpeaker});
  }

  /// Enables/Disables the audio playback route to the speakerphone.
  ///
  /// This method sets whether the audio is routed to the speakerphone or earpiece.
  static Future<void> setEnableSpeakerphone(bool enabled) async {
    await _channel.invokeMethod('setEnableSpeakerphone', {'enabled': enabled});
  }

  /// Checks whether the speakerphone is enabled.
  static Future<bool> isSpeakerphoneEnabled() async {
    final bool enabled = await _channel.invokeMethod('isSpeakerphoneEnabled');
    return enabled;
  }

  // Miscellaneous Methods
  /// Gets the SDK version.
  static Future<String> getSdkVersion() async {
    final String version = await _channel.invokeMethod('getSdkVersion');
    return version;
  }

  // CallHandler
  static void _addMethodCallHandler() {
    _channel.setMethodCallHandler((MethodCall call) {
      Map values = call.arguments;

      switch (call.method) {
        // Core Events
        case 'onWarning':
          if (onWarning != null) {
            onWarning(values['warn']);
          }
          break;
        case 'onError':
          if (onError != null) {
            onError(values['err']);
          }
          break;
        case 'onJoinChannelSuccess':
          if (onJoinChannelSuccess != null) {
            onJoinChannelSuccess(
                values['channel'], values['uid'], values['elapsed']);
          }
          break;
        case 'onRejoinChannelSuccess':
          if (onRejoinChannelSuccess != null) {
            onRejoinChannelSuccess(
                values['channel'], values['uid'], values['elapsed']);
          }
          break;
        case 'onLeaveChannel':
          if (onLeaveChannel != null) {
            onLeaveChannel();
          }
          break;
        case 'onClientRoleChanged':
          if (onClientRoleChanged != null) {
            ClientRole oldRole = _clientRoleFromInt(values['oldRole']);
            ClientRole newRole = _clientRoleFromInt(values['newRole']);
            onClientRoleChanged(oldRole, newRole);
          }
          break;
        case 'onUserJoined':
          if (onUserJoined != null) {
            onUserJoined(values['uid'], values['elapsed']);
          }
          break;
        case 'onUserOffline':
          if (onUserOffline != null) {
            onUserOffline(values['uid'], values['reason']);
          }
          break;
        case 'onConnectionStateChanged':
          if (onConnectionStateChanged != null) {
            onConnectionStateChanged(values['state'], values['reason']);
          }
          break;
        case 'onConnectionLost':
          if (onConnectionLost != null) {
            onConnectionLost();
          }
          break;
        case 'onApiCallExecuted':
          if (onApiCallExecuted != null) {
            onApiCallExecuted(values['error'], values['api'], values['result']);
          }
          break;
        case 'onTokenPrivilegeWillExpire':
          if (onTokenPrivilegeWillExpire != null) {
            onTokenPrivilegeWillExpire(values['token']);
          }
          break;
        case 'onRequestToken':
          if (onRequestToken != null) {
            onRequestToken();
          }
          break;
        // Media Events
        case 'onMicrophoneEnabled':
          if (onMicrophoneEnabled != null) {
            onMicrophoneEnabled(values['enabled']);
          }
          break;
        case 'onAudioVolumeIndication':
          if (onAudioVolumeIndication != null) {
            List<dynamic> speakerValues = values['speakers'];
            List<AudioVolumeInfo> speakers = List<AudioVolumeInfo>();
            for (Map speakerValue in speakerValues) {
              AudioVolumeInfo info =
                  AudioVolumeInfo(speakerValue['uid'], speakerValue['volume']);
              speakers.add(info);
            }
            onAudioVolumeIndication(values['totalVolume'], speakers);
          }
          break;
        case 'onActiveSpeaker':
          if (onActiveSpeaker != null) {
            onActiveSpeaker(values['uid']);
          }
          break;
        case 'onFirstLocalAudioFrame':
          if (onFirstLocalAudioFrame != null) {
            onFirstLocalAudioFrame(values['elapsed']);
          }
          break;
        case 'onFirstRemoteAudioFrame':
          if (onFirstRemoteAudioFrame != null) {
            onFirstRemoteAudioFrame(values['uid'], values['elapsed']);
          }
          break;
        case 'onUserMuteAudio':
          if (onUserMuteAudio != null) {
            onUserMuteAudio(values['uid'], values['muted']);
          }
          break;        
        // Device Events
        case 'onAudioRouteChanged':
          if (onAudioRouteChanged != null) {
            onAudioRouteChanged(values['routing']);
          }
          break;
        // Statistics Events
        case 'onRemoteAudioStats':
          if (onRemoteAudioStats != null) {
            Map statsValue = values['stats'];
            RemoteAudioStats stats = RemoteAudioStats();
            stats.uid = statsValue['uid'];
            stats.quality = statsValue['quality'];
            stats.networkTransportDelay = statsValue['networkTransportDelay'];
            stats.jitterBufferDelay = statsValue['jitterBufferDelay'];
            stats.audioLossRate = statsValue['audioLossRate'];
            onRemoteAudioStats(stats);
          }
          break;
        case 'onRtcStats':
          if (onRtcStats != null) {
            Map statsValue = values['stats'];
            RtcStats stats = RtcStats();
            stats.totalDuration = statsValue['totalDuration'];
            stats.txBytes = statsValue['txBytes'];
            stats.rxBytes = statsValue['rxBytes'];
            stats.txKBitRate = statsValue['txKBitRate'];
            stats.rxKBitRate = statsValue['rxKBitRate'];

            stats.txAudioKBitRate = statsValue['txAudioKBitRate'];
            stats.rxAudioKBitRate = statsValue['rxAudioKBitRate'];
            stats.txVideoKBitRate = statsValue['txVideoKBitRate'];
            stats.rxVideoKBitRate = statsValue['rxVideoKBitRate'];
            stats.users = statsValue['users'];
            stats.lastmileDelay = statsValue['lastmileDelay'];
            stats.cpuTotalUsage = statsValue['cpuTotalUsage'];
            stats.cpuAppUsage = statsValue['cpuAppUsage'];
            onRtcStats(stats);
          }
          break;
        case 'onNetworkQuality':
          if (onNetworkQuality != null) {
            onNetworkQuality(
                values['uid'], values['txQuality'], values['rxQuality']);
          }
          break;
        case 'onRemoteAudioTransportStats':
          if (onRemoteAudioTransportStats != null) {
            onRemoteAudioTransportStats(values['uid'], values['delay'],
                values['lost'], values['rxKBitRate']);
          }
          break;
        // Miscellaneous Events
        case 'onMediaEngineLoadSuccess':
          if (onMediaEngineLoadSuccess != null) {
            onMediaEngineLoadSuccess();
          }
          break;
        case 'onMediaEngineStartCallSuccess':
          if (onMediaEngineStartCallSuccess != null) {
            onMediaEngineStartCallSuccess();
          }
          break;
        default:
      }
    });
  }

  static void _removeMethodCallHandler() {
    _channel.setMethodCallHandler(null);
  }

  static ClientRole _clientRoleFromInt(int value) {
    switch (value) {
      case 1:
        return ClientRole.Broadcaster;
        break;
      case 2:
        return ClientRole.Audience;
        break;
      default:
        return ClientRole.Audience;
    }
  }

  static int _intFromClientRole(ClientRole role) {
    switch (role) {
      case ClientRole.Broadcaster:
        return 1;
        break;
      case ClientRole.Audience:
        return 2;
        break;
      default:
        return 2;
    }
  }

  static VideoRenderMode _videoRenderModeFromInt(int value) {
    switch (value) {
      case 1:
        return VideoRenderMode.Hidden;
        break;
      case 2:
        return VideoRenderMode.Fit;
        break;
      default:
        return VideoRenderMode.Hidden;
    }
  }

  static int _intFromVideoRenderMode(VideoRenderMode mode) {
    switch (mode) {
      case VideoRenderMode.Hidden:
        return 1;
        break;
      case VideoRenderMode.Fit:
        return 2;
        break;
      default:
        return 1;
    }
  }
}

class AudioVolumeInfo {
  int uid;
  int volume;

  AudioVolumeInfo(int uid, int volume) {
    this.uid = uid;
    this.volume = volume;
  }
}

class RtcStats {
  int totalDuration;
  int txBytes;
  int rxBytes;
  int txKBitRate;
  int rxKBitRate;
  int txAudioKBitRate;
  int rxAudioKBitRate;
  int txVideoKBitRate;
  int rxVideoKBitRate;
  int users;
  int lastmileDelay;
  double cpuTotalUsage;
  double cpuAppUsage;
}

class LocalVideoStats {
  int sentBitrate;
  int sentFrameRate;
}

class RemoteVideoStats {
  int uid;
  int delay;
  int width;
  int height;
  int receivedBitrate;
  int receivedFrameRate;
  int rxStreamType;
}

class RemoteAudioStats {
  int uid;
  int quality;
  int networkTransportDelay;
  int jitterBufferDelay;
  int audioLossRate;
}

/// The image enhancement options in [AgoraRtcEngine.setBeautyEffectOptions].
class BeautyOptions {
  /// The lightening contrast level.
  ///
  /// 0: low contrast level.
  /// 1: (default) normal contrast level.
  /// 2: high contrast level.
  LighteningContrastLevel lighteningContrastLevel = LighteningContrastLevel.Normal;

  /// The brightness level. 
  ///
  /// The value ranges from 0.0 (original) to 1.0.
  double lighteningLevel = 0;

  /// The sharpness level. 
  /// 
  ///The value ranges from 0.0 (original) to 1.0. This parameter is usually used to remove blemishes.
  double smoothnessLevel = 0;

  /// The redness level. 
  /// 
  /// The value ranges from 0.0 (original) to 1.0. This parameter adjusts the red saturation level.
  double rednessLevel = 0;

  Map<String, double> _jsonMap() {
    return {
      "lighteningContrastLevel": lighteningContrastLevel.index.toDouble(), 
      "lighteningLevel": lighteningLevel, 
      "smoothnessLevel": smoothnessLevel, 
      "rednessLevel": rednessLevel,
      };
  }
}

/// Properties of the video encoder configuration.
class VideoEncoderConfiguration {
  /// The video frame dimension used to specify the video quality in the total number of pixels along a frame's width and height.
  ///
  /// The dimension does not specify the orientation mode of the output ratio. For how to set the video orientation, see [VideoOutputOrientationMode].
  /// Whether 720p can be supported depends on the device. If the device cannot support 720p, the frame rate will be lower than the one listed in the table. Agora optimizes the video in lower-end devices.
  Size dimensions = Size(640, 360);

  /// The frame rate of the video (fps).
  /// 
  /// We do not recommend setting this to a value greater than 30.
  int frameRate = 15;

  /// The minimum video encoder frame rate (fps). 
  /// 
  /// The default value (-1) means the SDK uses the lowest encoder frame rate.
  int minFrameRate = -1;

  /// The bitrate of the video.
  /// 
  /// Sets the video bitrate (Kbps). If you set a bitrate beyond the proper range, the SDK automatically adjusts it to a value within the range. You can also choose from the following options:
  ///  - Standard: (recommended) In this mode, the bitrates differ between the Live-broadcast and Communication profiles:
  ///   - Communication profile: the video bitrate is the same as the base bitrate.
  ///   - Live-broadcast profile: the video bitrate is twice the base bitrate.
  ///  - Compatible: In this mode, the bitrate stays the same regardless of the profile. In the Live-broadcast profile, if you choose this mode, the video frame rate may be lower than the set value.
  /// Agora uses different video codecs for different profiles to optimize the user experience. For example, the Communication profile prioritizes the smoothness while the Live-broadcast profile prioritizes the video quality (a higher bitrate). Therefore, Agora recommends setting this parameter as AgoraVideoBitrateStandard.
  int bitrate = AgoraVideoBitrateStandard;

  /// The minimum encoding bitrate.
  /// 
  /// The Agora SDK automatically adjusts the encoding bitrate to adapt to network conditions.
  /// Using a value greater than the default value forces the video encoder to output high-quality images but may cause more packet loss and hence sacrifice the smoothness of the video transmission.
  /// Unless you have special requirements for image quality, Agora does not recommend changing this value.
  int minBitrate = -1;

  /// The video orientation mode of the video.
  VideoOutputOrientationMode orientationMode = VideoOutputOrientationMode.Adaptative;

  /// The video encoding degradation preference under limited bandwidth.
  DegradationPreference degradationPreference = DegradationPreference.MaintainQuality;

  Map<String, dynamic> _jsonMap() {
    return {
      'width': dimensions.width.toInt(),
      'height': dimensions.height.toInt(),
      'frameRate': frameRate,
      'minFrameRate': minFrameRate,
      'bitrate': bitrate,
      'minBitrate': minBitrate,
      'orientationMode': orientationMode.index,
      'degradationPreference': degradationPreference.index,
      };
  }
}

const int AgoraVideoBitrateStandard = 0;
const int AgoraVideoBitrateCompatible = -1;

enum ChannelProfile {
  /// This is used in one-on-one or group calls, where all users in the channel can talk freely.
  Communication,

  /// Host and audience roles that can be set by calling the [AgoraRtcEngine.setClientRole] method. The host sends and receives voice/video, while the audience can only receive voice/video.
  LiveBroadcasting,
}

enum ClientRole { Broadcaster, Audience, }

enum VideoOutputOrientationMode {
  /// Adaptive mode.
  /// 
  /// The video encoder adapts to the orientation mode of the video input device. When you use a custom video source, the output video from the encoder inherits the orientation of the original video.
  /// If the width of the captured video from the SDK is greater than the height, the encoder sends the video in landscape mode. The encoder also sends the rotational information of the video, and the receiver uses the rotational information to rotate the received video.
  /// If the original video is in portrait mode, the output video from the encoder is also in portrait mode. The encoder also sends the rotational information of the video to the receiver.
  Adaptative,

  /// Landscape mode.
  /// 
  /// The video encoder always sends the video in landscape mode. The video encoder rotates the original video before sending it and the rotational information is 0. This mode applies to scenarios involving CDN live streaming.
  FixedLandscape,

  /// Portrait mode.
  /// 
  /// The video encoder always sends the video in portrait mode. The video encoder rotates the original video before sending it and the rotational information is 0. This mode applies to scenarios involving CDN live streaming.
  FixedPortrait,
}

/// The video encoding degradation preference under limited bandwidth.
enum DegradationPreference {
  /// Degrades the frame rate to guarantee the video quality.
  MaintainQuality,

  /// Degrades the video quality to guarantee the frame rate.
  MaintainFramerate,

  /// Reserved for future use.
  Balanced,
}

enum VideoRenderMode {
  /// Uniformly scale the video until it fills the visible boundaries (cropped). One dimension of the video may have clipped contents.
  Hidden,

  /// Uniformly scale the video until one of its dimension fits the boundary (zoomed to fit). Areas that are not filled due to the disparity in the aspect ratio are filled with black.
  Fit,
}

enum UserPriority {
  High,
  Normal,
}

enum StreamFallbackOptions {
  /// No fallback behavior for the local/remote stream when the uplink/downlink network condition is unreliable. The quality of the stream is not guaranteed.
  Disabled,

  /// Under unreliable downlink network conditions, the remote stream falls back to the low-video stream (low resolution and low bitrate). You can only set this option in [AgoraRtcEngine.setRemoteSubscribeFallbackOption].
  /// Nothing happens when you set this in [AgoraRtcEngine.setLocalPublishFallbackOption].
  VideoStreamLow,

  /// Under unreliable uplink network conditions, the published stream falls back audio only.
  /// Under unreliable downlink network conditions, the remote stream first falls back to the low-video stream (low resolution and low bitrate); and then to an audio-only stream if the network condition deteriorates.
  AudioOnly,
}

enum AudioProfile {
  /// Default audio profile. In the communication profile, the default value is [SpeechStandard]; in the live-broadcast profile, the default value is [MusicStandard].
  Default,

  /// Sampling rate of 32 kHz, audio encoding, mono, and a bitrate of up to 18 Kbps.
  SpeechStandard,

  /// Sampling rate of 48 kHz, music encoding, mono, and a bitrate of up to 48 Kbps.
  MusicStandard,

  /// Sampling rate of 48 kHz, music encoding, stereo, and a bitrate of up to 56 Kbps.
  MusicStandardStereo,

  /// Sampling rate of 48 kHz, music encoding, mono, and a bitrate of up to 128 Kbps.
  MusicHighQuality,

  /// Sampling rate of 48 kHz, music encoding, stereo, and a bitrate of up to 192 Kbps.
  MusicHighQualityStereo,
}

enum AudioScenario {
  /// Default.
  Default,

  /// Entertainment scenario, supporting voice during gameplay.
  ChatRoomEntertainment,

  /// Education scenario, prioritizing fluency and stability.
  Education,

  /// Live gaming scenario, enabling the gaming audio effects in the speaker mode in a live broadcast scenario. Choose this scenario for high-fidelity music playback.
  GameStreaming,

  /// Showroom scenario, optimizing the audio quality with external professional equipment.
  ShowRoom,

  /// Gaming scenario.
  ChatRoomGaming,
}

enum LighteningContrastLevel {
  /// Low contrast level.
  Low,

  /// Normal contrast level.
  Normal,

  ///High contrast level.
  High,
}
