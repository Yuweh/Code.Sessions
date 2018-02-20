

//Convert UIImage to Data, here is a snippet that can help you:
let img = UIImage(named:"someImage.png")
let data = UIImageJPEGRepresentation(img, 1.0)

//What is coded :D

    func savePhoto(){
        let imageData = UIImageJPEGRepresentation(img.image!, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    //*********************************** SAMPLE ********************************

//FOR PNG:

if let image = UIImage(named: "example.png") {
    if let data = UIImagePNGRepresentation(image) {
        let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
        try? data.write(to: filename)
    }
}


//FOR JPEG

if let image = UIImage(named: "example.png") {
    if let data = UIImageJPEGRepresentation(image, 0.8) {
        let filename = getDocumentsDirectory().appendingPathComponent("copy.jpeg")
        try? data.write(to: filename)
    }
}
    
    
    
