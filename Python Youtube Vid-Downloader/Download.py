from pytube import YouTube

link = input("Paste YouTube link here: ")
yt = YouTube(link)

video = yt.streams.get_highest_resolution()
video.download()
print("Done!")
