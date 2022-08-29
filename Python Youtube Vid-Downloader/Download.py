from pytube import YouTube

link = input("Paste YouTube link here: ")
yt = YouTube(link)

#Showing details.
print("Downloading video: ",yt.title)
print("Number of views: ",yt.views)
print("Length of video: ",yt.length)
print("Video rating: ",yt.rating)

# Obtaining highest resolution possible.
video = yt.streams.get_highest_resolution()

print("Downloading...")
video.download()
print("Done!")
