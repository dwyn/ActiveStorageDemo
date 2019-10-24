LOCAL STORAGE SETUP ONLY:
Step 1:
In your terminal: 
	rails active_storage:install
	rails db:migrate

Step 2:
In config/storage.yml:
local:
  service: Disk
  root: <%= Rails.root.join("storage") %>
 
test:
  service: Disk
  root: <%= Rails.root.join("tmp/storage") %>
 
Step 3:
In config/environments/development.rb
config.active_storage.service = :local

  Step 4: 
In your model class that will have an associated image:
class Post < ApplicationRecord 
    has_one_attached :image  #one associated image
    has_many_attached :images   #many associated images
end

Step 5:
In the form for the model with an associated image:
 <%= form.label :image %> 
<%= form.file_field :image %>

Step 6:
In the strong params method in the Controller that processes that form:
params.require(:post).permit(:title, :body, :image) #one image
OR
params.require(:post).permit(:title, :body, images: []) #many images


Step 7:
In the view to display the image:
 if @post.image.attached?
   <%= image_tag url_for(@post.image) %>
end
STORAGE SETUP ON AMAZON - for production:

You must first have an AWS account and create a bucket before proceeding.

Step 1:
Set up your AWS credentials.  
In your terminal type:  
EDITOR=’subl --wait’ rails credentials:edit
 (replace ‘subl’ with whichever editor you use)

This will open a credentials file for you to edit. When you save and close it, the file is encrypted so it can be pushed to github without fear of someone using your credentials. 

In the credentials file:
aws: 
     access_key_id: abc123 
     secret_access_key: def456
(Paste your access key and secret access key instead of those letters and numbers)
*If you have trouble getting this to work, you can use the .env file instead - just be sure .env is listed in the .gitignore

If this is your first time using the credentials file, you will also need to set up the RAILS_MASTER_KEY in your .env file. This can be found in the config/master.key file. Also, be sure to add config/master.key to your .gitignore


Step 2:
In config/storage.yml:

 amazon:
   service: S3
   access_key_id: <%= Rails.application.credentials.dig(:aws, :access_key_id) %>
   secret_access_key: <%= Rails.application.credentials.dig(:aws, :secret_access_key) %>
   region: us-east-1
   bucket: your_own_bucket

Step 3:
In config/environments/production.rb
config.active_storage.service = :amazon

Step 4:
Add this gem to your gemfile & bundle install:
gem "aws-sdk-s3", require: false

Step 5:
When using has_one photo, it is better to attach/upload your photo like this in the create action:
if @post.save
      @post.image.purge
      @post.image.attach(params[:post][:image])
end




If you want Thumbnail Images or to resize images in general:
Step 1:
  Add gem "mini_magick" to your gemfile and bundle. 

Step 2:
 Display your image using the following code:
 <%= image_tag url_for(@post.image.variant(resize: “100X100”)) %> 
If you want the variant to be remembered, you can call this instead:  
 <%= image_tag url_for(@post.image.variant(resize: “100X100”).processed.service_url) %>  

This will save a processed version so that it doesn’t have to be transformed into a thumbnail every time it is loaded from the web service where it’s stored. 


Mini Magick Resources:
https://api.rubyonrails.org/classes/ActiveStorage/Variant.html
https://www.imagemagick.org/script/mogrify.php


Active Storage Resources:
https://guides.rubyonrails.org/active_storage_overview.html
https://medium.com/world-of-mind/rails-image-upload-with-active-storage-and-google-cloud-storage-6269e04ba93c
https://phase2online.com/blog/2018/10/03/easily-upload-files-with-active-storage-in-rails-5-2/
https://medium.com/@anaharris/how-to-add-image-upload-functionality-to-your-rails-app-9f7fc3f3d042


Credentials Resources:
https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2
https://blog.eq8.eu/til/rails-52-credentials-tricks.html
https://medium.com/cedarcode/rails-5-2-credentials-9b3324851336
