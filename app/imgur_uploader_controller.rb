class ImgurUploaderController < UIViewController
  attr_accessor :viewImageView

  def viewDidLoad
    @items = []
    @viewImageView = UIImageView.alloc.init
    @viewImageView.image = load_picture_from "http://i.imgur.com/bbg8Y.jpg"
    @viewImageView.frame = [[10,50],[300,200]]
    view.addSubview(@viewImageView)

    url_label = UILabel.new
    url_label.font = UIFont.systemFontOfSize(20)
    url_label.text = 'URL'
    url_label.textAlignment = UITextAlignmentCenter
    url_label.textColor = UIColor.whiteColor
    url_label.backgroundColor = UIColor.clearColor
    url_label.frame = [[10, 250], [300,50]]
    view.addSubview(url_label)
    
    @url_label = url_label

    button_load = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button_load.setTitle('Camera', forState:UIControlStateNormal)
    button_load.addTarget(self, action:'useCamera', forControlEvents:UIControlEventTouchUpInside)
    button_load.frame = [[50, 300],[75,50]]
    view.addSubview(button_load)

    upload_imgur_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    upload_imgur_button.setTitle('Imgur', forState:UIControlStateNormal)
    upload_imgur_button.addTarget(self, action:'uploadImgur', forControlEvents:UIControlEventTouchUpInside)
    upload_imgur_button.frame = [[150, 300],[75,50]]
    view.addSubview(upload_imgur_button)

    @filter_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @filter_button.setTitle('b/w filter', forState:UIControlStateNormal)
    @filter_button.addTarget(self, action:'filter_image', forControlEvents:UIControlEventTouchUpInside)
    @filter_button.frame = [[250,300],[75,50]]
    view.addSubview(@filter_button)
  end

  def filter_image
    gray_copy = create_gray_copy(@viewImageView.image)
    @viewImageView.image = gray_copy
  end

  def create_gray_copy(image)
    cgImage = image.CGImage
    provider = CGImageGetDataProvider(cgImage)
    bitmapData = CGDataProviderCopyData(provider)
    data = CFDataGetBytePtr(bitmapData)
p data

    width = image.size.width
    height = image.size.height
    myDataLength = width * height * 4;

    0.step(myDataLength, 4) do |i|
      r_pixel = data[i].bytes.first
      g_pixel = data[i+1].bytes.first
      b_pixel = data[i+2].bytes.first

      outputRed = (r_pixel * 0.393) + (g_pixel *0.769) + (b_pixel * 0.189);
      outputGreen = (r_pixel * 0.349) + (g_pixel *0.686) + (b_pixel * 0.168);
      outputBlue = (r_pixel * 0.272) + (g_pixel *0.534) + (b_pixel * 0.131);

      if(outputRed>255)
        outputRed=255
      end
      if(outputGreen>255)
        outputGreen=255
      end
      if(outputBlue>255)
        outputBlue=255
      end

      data[i] = outputRed.to_s(16)
      data[i+1] = outputGreen.to_s(16)
      data[i+2] = outputBlue.to_s(16)
    end

    provider2 = CGDataProviderCreateWithData(NULL, data, myDataLength, NULL)
    bitsPerComponent = 8
    bitsPerPixel = 32
    bytesPerRow = 4 * width
    ceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB()
    bitmapInfo = kCGBitmapByteOrderDefault
    renderingIntent = kCGRenderingIntentDefault
    imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider2, NULL, NO, renderingIntent)

    CGColorSpaceRelease(colorSpaceRef)
    CGDataProviderRelease(provider2)
    CFRelease(bitmapData)

    sepiaImage = UIImage.imageWithCGImage(imageRef)
    CGImageRelease(imageRef)
    sepiaImage
  end

  def uploadImgur
    imgur_uploader = ImgurUploader.alloc.init
    imgur_uploader.delegate = self
    imgur_uploader.uploadImage(@viewImageView.image)
  end

  def imageUploadedWithURLString(image_url) 
    @url_label.text = image_url 
  end

  def useCamera
    imagePicker = UIImagePickerController.alloc.init
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceTypeCamera)
      imagePicker.setSourceType(UIImagePickerControllerSourceTypeCamera)
    else
      imagePicker.setSourceType(UIImagePickerControllerSourceTypePhotoLibrary)
    end

    imagePicker.mediaTypes = [KUTTypeImage]
    imagePicker.delegate = self
    presentModalViewController(imagePicker, animated:true)
  end

  def viewWillAppear(animated)
    navigationItem.title = 'Imgur file uploader' 
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'seeList')
  end

  def imagePickerController(picker, didFinishPickingMediaWithInfo:info)
    image = info.objectForKey(UIImagePickerControllerOriginalImage)
    @viewImageView.setImage(image)
    dismissModalViewControllerAnimated(true)
  end

  def seeList
    7.times do
      addImageItem
    end
    image_list_controller = ImageListController.alloc.init
    image_list_controller.setItems(@items)
    navigationController.pushViewController(image_list_controller, animated:true)
  end

  private

  def load_picture_from url
    url = NSURL.URLWithString(url)
    @image = UIImage.imageWithData(NSData.dataWithContentsOfURL(url))
  end

  def addImageItem
    @item = [] if @item.nil?
    url = "http://i.imgur.com/bbg8Y.jpg"
    @items << url
  end
  
end
