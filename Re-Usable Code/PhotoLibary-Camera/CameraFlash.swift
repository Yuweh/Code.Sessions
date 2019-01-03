

//private func flashOn(device:AVCaptureDevice)
    {
        do{
            if (device.hasTorch)
            {
                try device.lockForConfiguration()
                device.torchMode = .on
                device.flashMode = .on
                device.unlockForConfiguration()
            }
        }catch{
            //DISABEL FLASH BUTTON HERE IF ERROR 
            print("Device tourch Flash Error ");
        }
    }
    
    //
     private func flashOff(device:AVCaptureDevice)
    {
        do{
            if (device.hasTorch){
                try device.lockForConfiguration()
                device.torchMode = .off
                device.flashMode = .off
                device.unlockForConfiguration()
            }
        }catch{
            //DISABEL FLASH BUTTON HERE IF ERROR
            print("Device tourch Flash Error ");
        }
    }
    
    
    //MARK: FLASH UITLITY METHODS
    func toggleFlash() {
        var device : AVCaptureDevice!

        if #available(iOS 10.0, *) {
            let videoDeviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDuoCamera], mediaType: AVMediaTypeVideo, position: .unspecified)!
            let devices = videoDeviceDiscoverySession.devices!
            device = devices.first!

        } else {
            // Fallback on earlier versions
            device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        }

        if ((device as AnyObject).hasMediaType(AVMediaTypeVideo))
        {
            if (device.hasTorch)
            {
                self.session.beginConfiguration()
                //self.objOverlayView.disableCenterCameraBtn();
                if device.isTorchActive == false {
                    self.flashOn(device: device)
                } else {
                    self.flashOff(device: device);
                }
                //self.objOverlayView.enableCenterCameraBtn();
                self.session.commitConfiguration()
            }
        }
    }
    
    
    //SHORT BUT SWEET
        @IBAction func didTouchFlashButton(_ sender: Any) {
    if let avDevice = AVCaptureDevice.default(for: AVMediaType.video) {
        if (avDevice.hasTorch) {
            do {
                try avDevice.lockForConfiguration()
            } catch {
                print("aaaa")
            }

            if avDevice.isTorchActive {
                avDevice.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                avDevice.torchMode = AVCaptureDevice.TorchMode.on
            }
        }
        // unlock your device
        avDevice.unlockForConfiguration()
    }
}
    
    
    //CODE USED for: UIImagePickerController -> that has FlashModeSettings XD

//
	@objc fileprivate func takePicturePressed() {
        if isFlashModeOn {
            picker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.on
            picker.takePicture()
            return
        }
        picker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.off
		picker.takePicture()
	}



//
	@objc fileprivate func flashPressed(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected

        if !sender.isSelected {
            self.isFlashModeOn = false
            return
        }
        self.isFlashModeOn = true
        return
	}


    
    
    
