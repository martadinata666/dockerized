import os
import shutil
import glob

src_path = r"/mnt/nfs_ssd/downloads"
doc_path = r"/mnt/nfs_ssd/media/docs/"
video_path = r"/mnt/nfs_ssd/media/videos/"
musik_path = r"/mnt/nfs_ssd/media/musik/"
pic_path = r"/mnt/nfs_ssd/media/bilder/"
other_path= r"/mnt/nfs_ssd/media/other/"

doc = ["/*.doc", "/*.odt", "/*.docx", "/*.txt", "/*.pdf", "/*.xml", "/*.rtf","/*.ppt", "/*.pptx"]
musik = ["/*.mp3", "/*.wav", "/*.m4a"]
video = ["/*.mp4", "/*.mov", "/*.avi"]
bilder = ["/*.jpg", "/*.jpeg", "/*.png", "/*.gif", "/*.svg", "/*.bmp"]
#other = ["/*.exe",]

for i in doc:
    files = glob.glob(src_path + i)
    for file in files:
        file_name = os.path.basename(file)
        shutil.move(file, doc_path + file_name)
        #print('Moved:', file)

for i in video:
    files = glob.glob(src_path + i)
    for file in files:
        file_name = os.path.basename(file)
        shutil.move(file, video_path + file_name)
        #print('Moved:', file)

for i in musik:
    files = glob.glob(src_path + i)
    for file in files:
        file_name = os.path.basename(file)
        shutil.move(file, musik_path + file_name)
        #print('Moved:', file)

for i in bilder:
    files = glob.glob(src_path + i)
    for file in files:
        file_name = os.path.basename(file)
        shutil.move(file, doc_path + file_name)
        #print('Moved:', file)

download_path = r"/mnt/nfs_ssd/downloads/"

for file in os.listdir('/mnt/nfs_ssd/downloads/'):
    if not file in bilder and doc and musik and video:
        source = download_path + file
        dest = other_path + file
        if os.path.isfile(source):
            shutil.move(source, dest)
            # print('Moved:', i)
