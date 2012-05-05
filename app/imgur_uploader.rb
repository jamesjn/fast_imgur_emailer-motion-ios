class ImgurUploader
  attr_accessor :delegate
  attr_accessor :image

  def uploadImage image
    imageData = UIImageJPEGRepresentation(image,0.3)
    image64Bstr = [imageData].pack('m')
    NSLog("%@", image64Bstr)
    uploadCall = "key=b1507316815a853a7a23318ff905a486&image="+image64Bstr
    request = NSMutableURLRequest.requestWithURL(NSURL.URLWithString("http://api.imgur.com/2/upload"))
    request.setHTTPMethod("POST")
    request.setValue(NSString.stringWithFormat("%d", uploadCall.length), forHTTPHeaderField:("Content-length"))
    request.setHTTPBody(uploadCall.dataUsingEncoding(NSUTF8StringEncoding))
    theConnection = NSURLConnection.alloc.initWithRequest(request, delegate:self)
    if(theConnection)
      @receivedData = NSMutableData.data
    end
  end

  def connection(connection, didReceiveData:data)
    @receivedData.appendData(data)
    NSLog("Did receieve data")
  end

  def connectionDidFinishLoading(connection)
    parser = NSXMLParser.alloc.initWithData(@receivedData)
    parser.setDelegate(self)
    parser.parse
    NSLog("Did finish loading")
  end

  def parserDidEndDocument(parser)
    NSLog("Did finish parsing")
    NSLog("%s", @imageURL)
    #delegate.imageUploadedWithURLString(@imageURL)
  end

  def parser(parser, didStartElement:elementName, namespaceURI:namespaceURI, qualifiedName:qName, attributes:attributeDict)
    @currentNode = elementName
  end

  def parser(parser, didEndElement:elementName, namespaceURI:namespaceURI, qualifiedName:qName)
    if(@currentNode.isEqualToString(elementName))
      @currentNode = ""
    end
  end

  def parser(parser, foundCharacters:string)
    if(@currentNode.isEqualToString("original"))
      NSLog("found characters")
      NSLog(string)
      @imageURL = string
    end 
  end

end
