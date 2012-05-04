class ImgurUploader
  def self.uploadImage(image)
    imageData = UIImagePNGRepresentation(image);
    uploadCall = "key=b1507316815a853a7a23318ff905a486&image="+imageData.to_s
    request = NSMutableURLRequest.requestWithURL("http://api.imgur.com/2/upload")
    request.setHTTPMethod("POST")
    request.setValue(uploadCall.length, forHTTPHeaderField:("Content-length"))
    request.setHTTPBody(uploadCall.dataUsingEncoding(NSUTF8StringEncoding))
    theConnection = NSURLConnection.alloc.initWithRequest(request, delegate:self)
    if(theConnection)
      receivedData = NSMutableData.data
    end
  end
end
