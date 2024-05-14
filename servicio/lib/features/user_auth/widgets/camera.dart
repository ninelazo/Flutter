import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class camera extends StatefulWidget {
  const camera({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription?> cameras;


  @override
  State<camera> createState() => _cameraState();
}

class _cameraState extends State<camera> {

  late CameraController _cameraController;
  bool _RearCamara = true;


  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    super.dispose();
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (!_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.auto);
      XFile picture = await _cameraController.takePicture();
    } on CameraException catch (e) {
      AlertDialog(title: const Text("Error"), content: Text("$e"));
    }
  }


  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            (_cameraController.value.isInitialized)
                ? CameraPreview(_cameraController)
                : Container(
              color: Colors.blue,
              child: const Center(
                child: SpinKitWaveSpinner(color: Colors.blue),
              ),
            ),
            Align(alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 20,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24)),
                    color: Colors.blue
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 30,
                        icon: Icon(Icons.camera_alt_rounded),
                        onPressed: () {
                          setState(() =>
                          _RearCamara = !_RearCamara);
                          initCamera(widget.cameras![_RearCamara ? 0 : 1]!);
                        },
                      ),
                    ),
                    Expanded(child: IconButton(
                      onPressed: takePicture,
                      iconSize: 50,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.circle, color: Colors.red,),
                    )),
                    const Spacer(),
                  ],),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
