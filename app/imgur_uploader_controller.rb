class ImgurUploaderController < UIViewController
  attr_accessor :viewImageView

  def viewDidLoad
    @items = []
    @viewImageView = UIImageView.alloc.init
    @viewImageView.image = load_picture_from "http://i.imgur.com/bbg8Y.jpg"
    @viewImageView.frame = [[10,50],[300,200]]
    view.addSubview(@viewImageView)

    button_load = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button_load.setTitle('Camera', forState:UIControlStateNormal)
    button_load.addTarget(self, action:'useCamera', forControlEvents:UIControlEventTouchUpInside)
    button_load.frame = [[50, 250],[100,50]]
    view.addSubview(button_load)

    upload_imgur_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    upload_imgur_button.setTitle('Imgur', forState:UIControlStateNormal)
    upload_imgur_button.addTarget(self, action:'uploadImgur', forControlEvents:UIControlEventTouchUpInside)
    upload_imgur_button.frame = [[150, 250],[100,50]]
    view.addSubview(upload_imgur_button)
  end

  def uploadImgur
    imgur_uploader = ImgurUploader.alloc.init
    imgur_uploader.delegate = self
    imgur_uploader.uploadImage(@viewImageView.image)
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
